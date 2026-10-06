from datetime import datetime
from sqlalchemy import Boolean, DateTime, Float, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from .db import Base


class Dataset(Base):
    __tablename__ = "datasets"
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(160), unique=True)
    label: Mapped[str] = mapped_column(String(20), default="SYNTHETIC")
    source: Mapped[str] = mapped_column(String(160))
    coverage_start: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    coverage_end: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    transaction_count: Mapped[int] = mapped_column(Integer, default=0)
    token_count: Mapped[int] = mapped_column(Integer, default=0)
    wallet_count: Mapped[int] = mapped_column(Integer, default=0)
    quality_status: Mapped[str] = mapped_column(String(40), default="COMPLETE")
    provenance_json: Mapped[str] = mapped_column(Text, default="{}")
    transactions_json: Mapped[str] = mapped_column(Text, default="[]")
    prices_json: Mapped[str] = mapped_column(Text, default="{}")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    strategies: Mapped[list["Strategy"]] = relationship(back_populates="dataset")


class Strategy(Base):
    __tablename__ = "strategies"
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(160))
    hypothesis: Mapped[str] = mapped_column(Text)
    dataset_id: Mapped[int] = mapped_column(ForeignKey("datasets.id"))
    config_json: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    dataset: Mapped[Dataset] = relationship(back_populates="strategies")
    backtests: Mapped[list["Backtest"]] = relationship(back_populates="strategy")


class Backtest(Base):
    __tablename__ = "backtests"
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    strategy_id: Mapped[int] = mapped_column(ForeignKey("strategies.id"))
    status: Mapped[str] = mapped_column(String(30), default="QUEUED")
    error_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    result_json: Mapped[str] = mapped_column(Text, default="{}")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    strategy: Mapped[Strategy] = relationship(back_populates="backtests")
    trades: Mapped[list["Trade"]] = relationship(back_populates="backtest", cascade="all, delete-orphan")


class Trade(Base):
    __tablename__ = "trades"
    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    backtest_id: Mapped[int] = mapped_column(ForeignKey("backtests.id"))
    token: Mapped[str] = mapped_column(String(80))
    split: Mapped[str] = mapped_column(String(20))
    entry_time: Mapped[datetime] = mapped_column(DateTime)
    exit_time: Mapped[datetime] = mapped_column(DateTime)
    entry_price: Mapped[float] = mapped_column(Float)
    exit_price: Mapped[float] = mapped_column(Float)
    quantity: Mapped[float] = mapped_column(Float)
    gross_return: Mapped[float] = mapped_column(Float)
    net_return: Mapped[float] = mapped_column(Float)
    fees: Mapped[float] = mapped_column(Float)
    slippage_cost: Mapped[float] = mapped_column(Float)
    exit_reason: Mapped[str] = mapped_column(String(40))
    signal_wallet_count: Mapped[int] = mapped_column(Integer, default=0)
    backtest: Mapped[Backtest] = relationship(back_populates="trades")

