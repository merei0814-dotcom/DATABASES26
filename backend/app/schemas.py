from datetime import datetime
from typing import Any
from pydantic import BaseModel, Field


class StrategyConfig(BaseModel):
    selected_wallets: list[str] = Field(default_factory=list)
    min_wallet_buy_count: int = Field(default=2, ge=1)
    accumulation_window_hours: int = Field(default=48, ge=1)
    wallet_profitability_threshold: float = Field(default=0.05, ge=-1, le=10)
    liquidity_threshold_usd: float = Field(default=50_000, ge=0)
    entry_delay_hours: int = Field(default=24, ge=0)
    position_size_pct: float = Field(default=0.25, gt=0, le=1)
    holding_period_hours: int = Field(default=120, ge=1)
    take_profit_pct: float = Field(default=0.20, ge=0)
    stop_loss_pct: float = Field(default=0.10, ge=0, le=1)
    trading_fee_bps: float = Field(default=30, ge=0)
    slippage_bps: float = Field(default=50, ge=0)
    train_pct: float = Field(default=0.70, gt=0.1, lt=0.95)
    initial_capital: float = Field(default=100_000, gt=0)


class StrategyCreate(BaseModel):
    name: str = "Smart Money Accumulation"
    hypothesis: str = "When multiple historically strong wallets buy the same token in a short window, subsequent risk-adjusted returns may be positive."
    dataset_id: int
    config: StrategyConfig = Field(default_factory=StrategyConfig)


class DatasetOut(BaseModel):
    id: int
    name: str
    label: str
    source: str
    coverage_start: datetime | None
    coverage_end: datetime | None
    transaction_count: int
    token_count: int
    wallet_count: int
    quality_status: str
    provenance: dict[str, Any]


class BacktestCreate(BaseModel):
    strategy_id: int

