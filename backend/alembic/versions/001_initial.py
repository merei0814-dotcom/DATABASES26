"""initial quant lab schema"""
from alembic import op
import sqlalchemy as sa

revision = "001_initial"
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    op.create_table("datasets", sa.Column("id", sa.Integer, primary_key=True), sa.Column("name", sa.String(160), unique=True), sa.Column("label", sa.String(20)), sa.Column("source", sa.String(160)), sa.Column("coverage_start", sa.DateTime), sa.Column("coverage_end", sa.DateTime), sa.Column("transaction_count", sa.Integer), sa.Column("token_count", sa.Integer), sa.Column("wallet_count", sa.Integer), sa.Column("quality_status", sa.String(40)), sa.Column("provenance_json", sa.Text), sa.Column("transactions_json", sa.Text), sa.Column("prices_json", sa.Text), sa.Column("created_at", sa.DateTime))
    op.create_table("strategies", sa.Column("id", sa.Integer, primary_key=True), sa.Column("name", sa.String(160)), sa.Column("hypothesis", sa.Text), sa.Column("dataset_id", sa.Integer, sa.ForeignKey("datasets.id")), sa.Column("config_json", sa.Text), sa.Column("created_at", sa.DateTime))
    op.create_table("backtests", sa.Column("id", sa.Integer, primary_key=True), sa.Column("strategy_id", sa.Integer, sa.ForeignKey("strategies.id")), sa.Column("status", sa.String(30)), sa.Column("error_message", sa.Text), sa.Column("result_json", sa.Text), sa.Column("created_at", sa.DateTime), sa.Column("completed_at", sa.DateTime))
    op.create_table("trades", sa.Column("id", sa.Integer, primary_key=True), sa.Column("backtest_id", sa.Integer, sa.ForeignKey("backtests.id")), sa.Column("token", sa.String(80)), sa.Column("split", sa.String(20)), sa.Column("entry_time", sa.DateTime), sa.Column("exit_time", sa.DateTime), sa.Column("entry_price", sa.Float), sa.Column("exit_price", sa.Float), sa.Column("quantity", sa.Float), sa.Column("gross_return", sa.Float), sa.Column("net_return", sa.Float), sa.Column("fees", sa.Float), sa.Column("slippage_cost", sa.Float), sa.Column("exit_reason", sa.String(40)), sa.Column("signal_wallet_count", sa.Integer))

def downgrade():
    op.drop_table("trades"); op.drop_table("backtests"); op.drop_table("strategies"); op.drop_table("datasets")

