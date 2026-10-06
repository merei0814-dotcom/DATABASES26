from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "development"
    database_url: str = "sqlite:///./data/quant_lab.db"
    helius_api_key: str | None = None
    helius_rpc_url: str = "https://mainnet.helius-rpc.com"
    frontend_origin: str = "http://localhost:3000"
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()

