import asyncio
import httpx
from datetime import datetime


class HeliusProvider:
    """Historical transaction provider; market prices remain a separate provider contract."""
    def __init__(self, api_key: str, rpc_url: str = "https://mainnet.helius-rpc.com"):
        self.api_key, self.rpc_url = api_key, rpc_url.rstrip("/")

    async def get_transactions_for_address(self, address: str, start: datetime | None = None, end: datetime | None = None, limit: int = 100):
        params = {"transactionDetails": "full", "sortOrder": "asc", "limit": min(limit, 100)}
        filters = {"status": "succeeded", "tokenAccounts": "all"}
        if start or end:
            filters["blockTime"] = {k: int(v.timestamp()) for k, v in (("gte", start), ("lte", end)) if v}
        params["filters"] = filters
        cursor = None
        seen = set()
        output = []
        async with httpx.AsyncClient(timeout=30) as client:
            while True:
                request_params = {"api-key": self.api_key}
                body_params = dict(params)
                if cursor:
                    body_params["paginationToken"] = cursor
                response = await client.post(f"{self.rpc_url}/", params=request_params, json={"jsonrpc": "2.0", "id": 1, "method": "getTransactionsForAddress", "params": [address, body_params]})
                response.raise_for_status()
                payload = response.json()
                rows = payload.get("result", {}).get("data", payload.get("result", []))
                for row in rows:
                    key = row.get("signature") or row.get("transaction", {}).get("signatures", [None])[0]
                    if key and key not in seen:
                        seen.add(key); output.append(row)
                cursor = payload.get("result", {}).get("paginationToken")
                if not cursor or not rows:
                    break
                await asyncio.sleep(0.15)
        return output

    @staticmethod
    def normalize_swap(row: dict) -> dict | None:
        """Only accepts an explicitly classified swap; transfers are not treated as trades."""
        if str(row.get("type", row.get("eventType", ""))).upper() != "SWAP":
            return None
        return {"signature": row.get("signature"), "slot": row.get("slot", 0), "timestamp": datetime.fromtimestamp(row["timestamp"]).isoformat() if isinstance(row.get("timestamp"), (int, float)) else row.get("timestamp"), "wallet": row.get("feePayer") or row.get("source"), "token": row.get("tokenTransfers", [{}])[0].get("mint"), "transaction_type": "SWAP", "raw": row}

