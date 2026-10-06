from collections import defaultdict
from datetime import datetime, timedelta


def parse_time(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def wallet_profitability_before(transactions: list[dict], as_of: datetime) -> dict[str, float]:
    """FIFO closed-trade performance using only events strictly before as_of."""
    books: dict[tuple[str, str], list[tuple[float, float]]] = defaultdict(list)
    returns: dict[str, list[float]] = defaultdict(list)
    for tx in sorted(transactions, key=lambda x: (x["timestamp"], x["slot"], x["signature"])):
        ts = parse_time(tx["timestamp"])
        if ts >= as_of:
            break
        key = (tx["wallet"], tx["token"])
        if tx["side"] == "buy":
            books[key].append((float(tx["token_amount"]), float(tx["price_usd"])))
        elif tx["side"] == "sell":
            remaining = float(tx["token_amount"])
            proceeds = float(tx["price_usd"])
            while remaining > 1e-9 and books[key]:
                quantity, cost = books[key][0]
                used = min(quantity, remaining)
                returns[tx["wallet"]].append((proceeds - cost) / cost if cost else 0.0)
                remaining -= used
                if used >= quantity - 1e-9:
                    books[key].pop(0)
                else:
                    books[key][0] = (quantity - used, cost)
    return {wallet: sum(values) / len(values) for wallet, values in returns.items() if values}


def accumulation_signal(transactions: list[dict], signal_tx: dict, config: dict) -> dict:
    signal_time = parse_time(signal_tx["timestamp"])
    cutoff = signal_time - timedelta(hours=config["accumulation_window_hours"])
    scores = wallet_profitability_before(transactions, signal_time)
    eligible = set(config.get("selected_wallets") or []) or set(scores)
    buyers = {
        tx["wallet"] for tx in transactions
        if tx["token"] == signal_tx["token"] and tx["side"] == "buy"
        and cutoff <= parse_time(tx["timestamp"]) <= signal_time
        and tx["wallet"] in eligible
        and scores.get(tx["wallet"], -999) >= config["wallet_profitability_threshold"]
    }
    return {
        "is_signal": len(buyers) >= config["min_wallet_buy_count"],
        "buyers": sorted(buyers), "wallet_count": len(buyers),
        "historical_scores": {wallet: round(scores[wallet], 8) for wallet in buyers}
    }

