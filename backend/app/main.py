import json
from datetime import datetime
from fastapi import BackgroundTasks, Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import desc, func
from sqlalchemy.orm import Session
from .config import settings
from .db import Base, engine, get_db, SessionLocal
from .models import Backtest, Dataset, Strategy, Trade
from .schemas import BacktestCreate, DatasetOut, StrategyCreate
from .synthetic import WALLETS, build_synthetic_dataset, dataset_json
from .backtest import run_backtest

Base.metadata.create_all(bind=engine)
app = FastAPI(title="Solana Quant Research Lab API", version="0.1.0", description="Reproducible quantitative research API for Solana datasets.")
app.add_middleware(CORSMiddleware, allow_origins=[settings.frontend_origin, "http://localhost:3000"], allow_methods=["*"], allow_headers=["*"])


def dataset_response(d: Dataset):
    return {"id": d.id, "name": d.name, "label": d.label, "source": d.source, "coverage_start": d.coverage_start, "coverage_end": d.coverage_end, "transaction_count": d.transaction_count, "token_count": d.token_count, "wallet_count": d.wallet_count, "quality_status": d.quality_status, "provenance": json.loads(d.provenance_json)}


@app.get("/health")
def health(): return {"status": "ok", "environment": settings.app_env}


@app.post("/api/datasets/seed", response_model=DatasetOut)
def seed_dataset(db: Session = Depends(get_db)):
    data = build_synthetic_dataset()
    existing = db.query(Dataset).filter(Dataset.name == data["name"]).first()
    if existing: return dataset_response(existing)
    provenance, transactions, prices = dataset_json(data)
    row = Dataset(name=data["name"], label="SYNTHETIC", source=data["source"], coverage_start=datetime.fromisoformat(data["coverage_start"]), coverage_end=datetime.fromisoformat(data["coverage_end"]), transaction_count=len(data["transactions"]), token_count=len(data["prices"]), wallet_count=len(set(x["wallet"] for x in data["transactions"])), quality_status="COMPLETE_FOR_SYNTHETIC_PRICES", provenance_json=provenance, transactions_json=transactions, prices_json=prices)
    db.add(row); db.commit(); db.refresh(row)
    return dataset_response(row)


@app.get("/api/datasets", response_model=list[DatasetOut])
def list_datasets(db: Session = Depends(get_db)): return [dataset_response(x) for x in db.query(Dataset).order_by(desc(Dataset.created_at)).all()]


@app.get("/api/datasets/{dataset_id}", response_model=DatasetOut)
def get_dataset(dataset_id: int, db: Session = Depends(get_db)):
    row = db.get(Dataset, dataset_id)
    if not row: raise HTTPException(404, "Dataset not found")
    return dataset_response(row)


@app.post("/api/strategies")
def create_strategy(payload: StrategyCreate, db: Session = Depends(get_db)):
    if not db.get(Dataset, payload.dataset_id): raise HTTPException(404, "Dataset not found")
    row = Strategy(name=payload.name, hypothesis=payload.hypothesis, dataset_id=payload.dataset_id, config_json=payload.config.model_dump_json())
    db.add(row); db.commit(); db.refresh(row)
    return {"id": row.id, "name": row.name, "hypothesis": row.hypothesis, "dataset_id": row.dataset_id, "config": payload.config.model_dump()}


@app.get("/api/strategies")
def list_strategies(db: Session = Depends(get_db)):
    return [{"id": x.id, "name": x.name, "hypothesis": x.hypothesis, "dataset_id": x.dataset_id, "config": json.loads(x.config_json)} for x in db.query(Strategy).order_by(desc(Strategy.created_at)).all()]


def execute_backtest(backtest_id: int):
    db = SessionLocal()
    row = db.get(Backtest, backtest_id)
    try:
        row.status = "RUNNING"; db.commit()
        strategy = db.get(Strategy, row.strategy_id); dataset = db.get(Dataset, strategy.dataset_id)
        result = run_backtest(json.loads(dataset.transactions_json), json.loads(dataset.prices_json), json.loads(strategy.config_json))
        row.result_json = json.dumps(result); row.status = "COMPLETE"; row.completed_at = datetime.utcnow()
        for trade in result["trades"]:
            trade_copy = {k: trade[k] for k in ["token", "split", "entry_time", "exit_time", "entry_price", "exit_price", "quantity", "gross_return", "net_return", "fees", "slippage_cost", "exit_reason", "signal_wallet_count"]}
            trade_copy["entry_time"] = datetime.fromisoformat(trade_copy["entry_time"])
            trade_copy["exit_time"] = datetime.fromisoformat(trade_copy["exit_time"])
            db.add(Trade(backtest_id=row.id, **trade_copy))
        db.commit()
    except Exception as exc:
        row.status = "FAILED"; row.error_message = str(exc); db.commit()
    finally: db.close()


@app.post("/api/backtests")
def create_backtest(payload: BacktestCreate, tasks: BackgroundTasks, db: Session = Depends(get_db)):
    if not db.get(Strategy, payload.strategy_id): raise HTTPException(404, "Strategy not found")
    row = Backtest(strategy_id=payload.strategy_id, status="QUEUED")
    db.add(row); db.commit(); db.refresh(row); tasks.add_task(execute_backtest, row.id)
    return {"id": row.id, "status": row.status}


@app.get("/api/backtests")
def list_backtests(db: Session = Depends(get_db)):
    return [{"id": x.id, "strategy_id": x.strategy_id, "status": x.status, "created_at": x.created_at, "completed_at": x.completed_at, "error_message": x.error_message} for x in db.query(Backtest).order_by(desc(Backtest.created_at)).all()]


@app.get("/api/backtests/{backtest_id}")
def get_backtest(backtest_id: int, db: Session = Depends(get_db)):
    row = db.get(Backtest, backtest_id)
    if not row: raise HTTPException(404, "Backtest not found")
    result = json.loads(row.result_json) if row.result_json else {}
    strategy = db.get(Strategy, row.strategy_id); dataset = db.get(Dataset, strategy.dataset_id)
    return {"id": row.id, "status": row.status, "error_message": row.error_message, "strategy": {"id": strategy.id, "name": strategy.name, "hypothesis": strategy.hypothesis, "config": json.loads(strategy.config_json)}, "dataset": dataset_response(dataset), "result": result}


@app.get("/api/backtests/{backtest_id}/report")
def report(backtest_id: int, db: Session = Depends(get_db)):
    row = db.get(Backtest, backtest_id)
    if not row: raise HTTPException(404, "Backtest not found")
    strategy = db.get(Strategy, row.strategy_id); dataset = db.get(Dataset, strategy.dataset_id)
    result = json.loads(row.result_json) if row.result_json else {}
    return {"title": f"Research Report · {strategy.name}", "hypothesis": strategy.hypothesis, "dataset": dataset_response(dataset), "strategy_config": json.loads(strategy.config_json), "assumptions": result.get("assumptions", {}), "metrics": result.get("metrics", {}), "limitations": json.loads(dataset.provenance_json).get("limitations", []) + ["Small synthetic sample; performance is illustrative and not a claim of real-world alpha."], "reproducibility": {"dataset_seed": 7, "engine": "event-driven deterministic Python engine", "backtest_id": row.id}}


@app.get("/api/dashboard")
def dashboard(db: Session = Depends(get_db)):
    return {"datasets": [dataset_response(x) for x in db.query(Dataset).order_by(desc(Dataset.created_at)).all()], "strategies": db.query(func.count(Strategy.id)).scalar() or 0, "recent_backtests": [{"id": x.id, "status": x.status, "created_at": x.created_at} for x in db.query(Backtest).order_by(desc(Backtest.created_at)).limit(5).all()], "supported_factors": ["wallet_buy_count", "wallet_profitability", "volume", "liquidity", "token_age", "momentum"]}
