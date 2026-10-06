import math
from datetime import datetime, timedelta
from statistics import mean, pstdev
from .factors import accumulation_signal, parse_time


def _price_at_or_after(prices, token, timestamp):
    for point in prices.get(token, []):
        if parse_time(point["timestamp"]) >= timestamp:
            return point
    return None


def _metrics(trades, curve, initial_capital):
    if not trades:
        return {"total_return": None, "net_return": None, "win_rate": None, "max_drawdown": None, "sharpe_ratio": None, "number_of_trades": 0, "average_trade_return": None, "profit_factor": None, "sample_warning": "No completed trades in this split."}
    net_returns = [t["net_return"] for t in trades]
    gross_returns = [t["gross_return"] for t in trades]
    values = [p["equity"] for p in curve]
    peak = initial_capital
    drawdowns = []
    for value in values:
        peak = max(peak, value)
        drawdowns.append(value / peak - 1 if peak else 0)
    stdev = pstdev(net_returns) if len(net_returns) > 1 else 0
    sharpe = (mean(net_returns) / stdev * math.sqrt(len(net_returns))) if stdev > 0 and len(net_returns) > 1 else None
    gains = sum(x for x in net_returns if x > 0)
    losses = abs(sum(x for x in net_returns if x < 0))
    return {
        "total_return": sum(gross_returns), "net_return": sum(net_returns), "win_rate": sum(x > 0 for x in net_returns) / len(net_returns),
        "max_drawdown": min(drawdowns) if drawdowns else None, "sharpe_ratio": sharpe, "number_of_trades": len(trades),
        "average_trade_return": mean(net_returns), "profit_factor": gains / losses if losses > 0 else None,
        "sample_warning": "Small sample: directional metrics are descriptive only." if len(trades) < 10 else None
    }


def run_backtest(transactions: list[dict], prices: dict, config: dict) -> dict:
    events = sorted(transactions, key=lambda x: (x["timestamp"], x["slot"], x["signature"]))
    if not events:
        return {"metrics": {"in_sample": _metrics([], [], config["initial_capital"]), "out_of_sample": _metrics([], [], config["initial_capital"])}, "trades": [], "skipped_trades": [{"reason": "empty_dataset"}], "equity_curve": []}
    start = parse_time(events[0]["timestamp"])
    end = parse_time(events[-1]["timestamp"])
    split_time = start + (end - start) * config["train_pct"]
    cash = config["initial_capital"]
    position = None
    trades = []
    skipped = []
    curve = []
    fee = config["trading_fee_bps"] / 10_000
    slip = config["slippage_bps"] / 10_000
    attempted_signals = set()

    buy_events = [tx for tx in events if tx["side"] == "buy"]
    for tx in buy_events:
        signal_time = parse_time(tx["timestamp"])
        signal = accumulation_signal(events, tx, config)
        if not signal["is_signal"] or tx["token"] in attempted_signals:
            continue
        attempted_signals.add(tx["token"])
        entry_time = signal_time + timedelta(hours=config["entry_delay_hours"])
        point = _price_at_or_after(prices, tx["token"], entry_time)
        split = "in_sample" if signal_time <= split_time else "out_of_sample"
        if point is None:
            skipped.append({"timestamp": tx["timestamp"], "token": tx["token"], "reason": "missing_entry_price", "split": split})
            continue
        if point["liquidity_usd"] < config["liquidity_threshold_usd"]:
            skipped.append({"timestamp": tx["timestamp"], "token": tx["token"], "reason": "insufficient_liquidity", "split": split})
            continue
        allocation = cash * config["position_size_pct"]
        if allocation <= 0:
            skipped.append({"timestamp": tx["timestamp"], "token": tx["token"], "reason": "insufficient_capital", "split": split})
            continue
        entry_price = point["price"] * (1 + slip)
        quantity = allocation * (1 - fee) / entry_price
        cash -= allocation
        exit_point = None
        exit_reason = "holding_period"
        entry_dt = parse_time(point["timestamp"])
        for candidate in prices.get(tx["token"], []):
            ctime = parse_time(candidate["timestamp"])
            if ctime < entry_dt:
                continue
            gross_move = candidate["price"] / entry_price - 1
            if gross_move >= config["take_profit_pct"]:
                exit_point, exit_reason = candidate, "take_profit"
                break
            if gross_move <= -config["stop_loss_pct"]:
                exit_point, exit_reason = candidate, "stop_loss"
                break
            if ctime >= entry_dt + timedelta(hours=config["holding_period_hours"]):
                exit_point = candidate
                break
        if exit_point is None:
            skipped.append({"timestamp": tx["timestamp"], "token": tx["token"], "reason": "missing_exit_price", "split": split})
            cash += allocation
            continue
        exit_price = exit_point["price"] * (1 - slip)
        gross_pnl = (exit_price / entry_price - 1)
        fees = allocation * fee + quantity * exit_price * fee
        slippage_cost = allocation * slip + quantity * exit_price * slip
        proceeds = quantity * exit_price * (1 - fee)
        cash += proceeds
        net_pnl = proceeds / allocation - 1
        trades.append({
            "token": tx["token"], "split": split, "entry_time": point["timestamp"], "exit_time": exit_point["timestamp"],
            "entry_price": entry_price, "exit_price": exit_price, "quantity": quantity, "gross_return": gross_pnl,
            "net_return": net_pnl, "fees": fees, "slippage_cost": slippage_cost, "exit_reason": exit_reason,
            "signal_wallet_count": signal["wallet_count"]
        })

    all_points = sorted(({"timestamp": p["timestamp"], "token": token, "price": p["price"]} for token, rows in prices.items() for p in rows), key=lambda x: x["timestamp"])
    for point in all_points:
        equity = cash
        curve.append({"timestamp": point["timestamp"], "equity": round(equity, 4)})
    return {
        "metrics": {"in_sample": _metrics([t for t in trades if t["split"] == "in_sample"], curve, config["initial_capital"]), "out_of_sample": _metrics([t for t in trades if t["split"] == "out_of_sample"], curve, config["initial_capital"])},
        "trades": trades, "skipped_trades": skipped, "equity_curve": curve,
        "split_time": split_time.isoformat(), "assumptions": {"fees_bps": config["trading_fee_bps"], "slippage_bps": config["slippage_bps"], "execution": "next available daily mark after signal + delay", "position_policy": "one completed position per token; cash allocation is checked before entry"}
    }
