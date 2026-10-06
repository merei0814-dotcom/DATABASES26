import json
from datetime import datetime, timedelta, timezone
from random import Random


WALLETS = ["WALLET_ALPHA", "WALLET_BETA", "WALLET_GAMMA", "WALLET_DELTA", "WALLET_NOISE_1", "WALLET_NOISE_2"]


def build_synthetic_dataset() -> dict:
    """Deterministic fixture with a calibration period and forward target moves."""
    rng = Random(7)
    start = datetime(2025, 1, 1, tzinfo=timezone.utc)
    prices: dict[str, list[dict]] = {}
    tokens = ["ALPHA", "BETA", "GAMMA", "NOISE"]
    for token in tokens:
        points = []
        base = {"ALPHA": 10.0, "BETA": 14.0, "GAMMA": 8.0, "NOISE": 11.0}[token]
        for day in range(90):
            if token == "ALPHA" and day >= 30:
                base *= 1.018 if day < 48 else 0.997
            elif token == "BETA" and day >= 55:
                base *= 1.012 if day < 70 else 0.996
            elif token == "GAMMA" and day >= 65:
                base *= 0.992
            else:
                base *= 1 + rng.uniform(-0.012, 0.012)
            points.append({"timestamp": (start + timedelta(days=day)).isoformat(), "price": round(base, 6), "liquidity_usd": 220_000 if token != "NOISE" else 40_000})
        prices[token] = points

    transactions = []
    seq = 0
    def add(wallet, token, day, side, price, amount_usd, liquidity=None):
        nonlocal seq
        seq += 1
        ts = start + timedelta(days=day, hours=6 if side == "buy" else 18)
        transactions.append({
            "signature": f"synthetic-{seq:05d}", "slot": 250000000 + seq, "timestamp": ts.isoformat(),
            "wallet": wallet, "token": token, "side": side, "token_amount": round(amount_usd / price, 6),
            "price_usd": price, "volume_usd": amount_usd, "decimals": 6,
            "liquidity_usd": liquidity if liquidity is not None else 220_000, "transaction_type": "SWAP"
        })

    # Historical wallet-performance calibration, all before target signals.
    for wallet in WALLETS[:4]:
        add(wallet, "GAMMA", 2, "buy", prices["GAMMA"][2]["price"], 4_000)
        add(wallet, "GAMMA", 12, "sell", prices["GAMMA"][12]["price"] * 1.18, 4_720)
    add(WALLETS[4], "GAMMA", 2, "buy", prices["GAMMA"][2]["price"], 4_000)
    add(WALLETS[4], "GAMMA", 12, "sell", prices["GAMMA"][12]["price"] * 0.94, 3_760)

    # Clustered accumulation generates observable signals for ALPHA and BETA.
    for wallet, day in zip(WALLETS[:4], [30, 30, 31, 31]):
        add(wallet, "ALPHA", day, "buy", prices["ALPHA"][day]["price"], 9_000, 220_000)
    for wallet, day in zip(WALLETS[:3], [56, 56, 57]):
        add(wallet, "BETA", day, "buy", prices["BETA"][day]["price"], 8_000, 220_000)
    add(WALLETS[4], "NOISE", 35, "buy", prices["NOISE"][35]["price"], 8_000, 40_000)
    add(WALLETS[5], "NOISE", 35, "buy", prices["NOISE"][35]["price"], 8_000, 40_000)
    transactions.sort(key=lambda x: (x["timestamp"], x["slot"], x["signature"]))
    return {
        "name": "Solana Smart Money Sandbox · Jan–Mar 2025",
        "label": "SYNTHETIC", "source": "Deterministic local generator (seed=7)",
        "coverage_start": start.isoformat(), "coverage_end": (start + timedelta(days=89)).isoformat(),
        "transactions": transactions, "prices": prices,
        "provenance": {
            "provider": "local.synthetic", "retrieved_at": "2025-01-01T00:00:00+00:00", "seed": 7,
            "coverage": "2025-01-01 through 2025-03-31", "historical_market_data": "synthetic daily marks",
            "missing_data": [], "limitations": ["This dataset is not on-chain data and must not be interpreted as realized Solana performance."]
        }
    }


def dataset_json(data: dict) -> tuple[str, str, str]:
    return json.dumps(data["provenance"]), json.dumps(data["transactions"]), json.dumps(data["prices"])

