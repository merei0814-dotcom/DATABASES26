from datetime import datetime, timezone
from app.factors import wallet_profitability_before, accumulation_signal
from app.synthetic import build_synthetic_dataset
from app.backtest import run_backtest


def test_synthetic_is_reproducible():
    assert build_synthetic_dataset() == build_synthetic_dataset()


def test_profitability_never_uses_future_trade():
    tx = [{"timestamp": "2025-01-01T00:00:00+00:00", "slot": 1, "signature": "a", "wallet": "w", "token": "x", "side": "buy", "token_amount": 1, "price_usd": 10}, {"timestamp": "2025-01-02T00:00:00+00:00", "slot": 2, "signature": "b", "wallet": "w", "token": "x", "side": "sell", "token_amount": 1, "price_usd": 20}]
    assert wallet_profitability_before(tx, datetime(2025, 1, 2, tzinfo=timezone.utc)) == {}
    assert wallet_profitability_before(tx, datetime(2025, 1, 3, tzinfo=timezone.utc))["w"] == 1.0


def test_signal_requires_prior_wallet_profitability():
    data = build_synthetic_dataset()
    target = next(x for x in data["transactions"] if x["token"] == "ALPHA")
    result = accumulation_signal(data["transactions"], target, {"accumulation_window_hours": 48, "min_wallet_buy_count": 2, "wallet_profitability_threshold": .05, "selected_wallets": []})
    assert result["is_signal"] and result["wallet_count"] >= 2


def test_backtest_has_costs_and_split_metrics():
    data = build_synthetic_dataset()
    config = {"selected_wallets": [], "min_wallet_buy_count": 2, "accumulation_window_hours": 48, "wallet_profitability_threshold": .05, "liquidity_threshold_usd": 50_000, "entry_delay_hours": 24, "position_size_pct": .25, "holding_period_hours": 120, "take_profit_pct": .2, "stop_loss_pct": .1, "trading_fee_bps": 30, "slippage_bps": 50, "train_pct": .7, "initial_capital": 100_000}
    result = run_backtest(data["transactions"], data["prices"], config)
    assert len(result["trades"]) >= 1
    trade = result["trades"][0]
    assert trade["net_return"] < trade["gross_return"]
    assert result["metrics"]["out_of_sample"]["number_of_trades"] >= 0


def test_missing_price_is_explicitly_skipped():
    data = build_synthetic_dataset(); data["prices"]["ALPHA"] = []
    config = {"selected_wallets": [], "min_wallet_buy_count": 2, "accumulation_window_hours": 48, "wallet_profitability_threshold": .05, "liquidity_threshold_usd": 50_000, "entry_delay_hours": 24, "position_size_pct": .25, "holding_period_hours": 120, "take_profit_pct": .2, "stop_loss_pct": .1, "trading_fee_bps": 30, "slippage_bps": 50, "train_pct": .7, "initial_capital": 100_000}
    result = run_backtest(data["transactions"], data["prices"], config)
    assert any(x["reason"] == "missing_entry_price" for x in result["skipped_trades"])

