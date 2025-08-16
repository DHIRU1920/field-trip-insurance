# 🏫 Field Trip Insurance — Aptos Move Smart Contract

A lightweight, trust‑minimized insurance pool for school field trips on the Aptos blockchain. Participants contribute premiums to a pool owned by the organizer, and an authorized trip leader executes claim payouts within predefined caps. The contract enforces:
- Authorization: only the trip leader can approve payouts
- Safety limits: max payout per claim
- Solvency: cannot pay more than collected premiums

Transparent. Auditable. Instant.

***

## 🚀 Vision

Empower educators and organizers with a seamless, on‑chain insurance experience:
- Replace paperwork‑heavy claims with code‑enforced rules
- Provide real‑time transparency of balances and limits
- Enable fast, accountable reimbursements during trips
- Offer a reusable blueprint for event‑based community insurance

***

## 📦 Package Status (Devnet)

- Publish Tx: 0x222aa53840ac008b756ebaaaf8862457765e6e9ab8c87f3e82c5f50b5b4f1161
- Network: Devnet
- Status: Success (code::publish_package_txn)

Important: The “Contract Address” is the account (package owner) that published the modules, not the transaction hash. Replace 0xYOUR_ACCOUNT_ADDRESS below with the sender/owner address that published the package.

***

## 📜 Contract Address

- Account/Package: 0xYOUR_ACCOUNT_ADDRESS
- Publish Transaction: 0x222aa53840ac008b756ebaaaf8862457765e6e9ab8c87f3e82c5f50b5b4f1161

Tip:
- Ensure this matches the address in [addresses] of Move.toml (e.g., field_trip_insurance = "0xYOUR_ACCOUNT_ADDRESS").
- On publish, copy the printed package/account address from the CLI and update here.

***

## 🧩 Modules & Entry Points

Assuming your package alias is field_trip_insurance and module name is pool:

- Create pool (organizer sets leader, caps)
  - 0xYOUR_ACCOUNT_ADDRESS::pool::init_pool(leader: address, max_payout: u64)
- Contribute premium
  - 0xYOUR_ACCOUNT_ADDRESS::pool::contribute(amount: u64)
- Approve payout (trip leader only; enforces caps and solvency)
  - 0xYOUR_ACCOUNT_ADDRESS::pool::approve_payout(recipient: address, amount: u64)
- View helpers (if provided as view functions or resources)
  - 0xYOUR_ACCOUNT_ADDRESS::pool::get_balance() -> u64
  - 0xYOUR_ACCOUNT_ADDRESS::pool::get_max_payout() -> u64
  - 0xYOUR_ACCOUNT_ADDRESS::pool::get_leader() -> address

Adjust names to your actual module file(s).

***

## 🏗 Directory Structure

```
field-trip-insurance/
├─ Move.toml
├─ sources/
│  └─ pool.move
├─ scripts/
│  ├─ init_pool.mvt
│  ├─ contribute.mvt
│  └─ approve_payout.mvt
├─ README.md
└─ assets/
   └─ explorer-tx.png
```

***

## ⚙️ Move.toml Template

```toml
[package]
name = "field_trip_insurance"
version = "0.0.1"
authors = ["Your Name "]
license = "Apache-2.0"

[addresses]
field_trip_insurance = "0xYOUR_ACCOUNT_ADDRESS"

[dependencies]
AptosFramework = { git = "https://github.com/aptos-labs/aptos-core.git", subdir = "aptos-move/framework/aptos-framework", rev = "mainnet" }

[dev-addresses]
field_trip_insurance_dev = "0xA11CE"

[dev-dependencies]
```

If you are on Devnet or Testnet, pin the framework revision to a known commit/tag to avoid breaking changes.

***

## 🧠 Core Design

- Single‑pool, single‑asset (APT) model
- Organizer initializes the pool and appoints a trip leader
- Anyone can contribute premiums into the pool
- Only the trip leader can approve payouts
- Payouts:
  - amount ≤ max_payout
  - amount ≤ current pool balance
  - updates pool balance atomically

***

## 🔐 Authorization Model

- Leader-only gating on approve_payout using signer/address checks
- Optional pause flag and owner‑only updates (future scope)
- Resources scoped to package owner; no global access without entry functions

***

## 🧪 Quickstart

1) Configure address
- Set your publishing account in Move.toml under [addresses].

2) Build
```
aptos move compile --named-addresses field_trip_insurance=0xYOUR_ACCOUNT_ADDRESS
```

3) Publish (Devnet)
```
aptos move publish --named-addresses field_trip_insurance=0xYOUR_ACCOUNT_ADDRESS --profile devnet
```
Record:
- Account/Package address printed by CLI
- Publish Tx hash (already provided above)

4) Initialize pool
```
aptos move run \
  --function 0xYOUR_ACCOUNT_ADDRESS::pool::init_pool \
  --args address:0xLEADER_ADDRESS u64:100_000_000 \
  --profile devnet
```
Example: max_payout=0.1 APT if your function uses octas (1 APT = 100_000_000 octas).

5) Contribute premium
```
aptos move run \
  --function 0xYOUR_ACCOUNT_ADDRESS::pool::contribute \
  --args u64:1_000_000_000 \
  --profile devnet
```
Example: 1 APT.

6) Approve payout (leader only)
```
aptos move run \
  --function 0xYOUR_ACCOUNT_ADDRESS::pool::approve_payout \
  --args address:0xRECIPIENT u64:100_000_000 \
  --profile devnet
```

***

## 🧾 Example Module Skeleton (pool.move)

```move
module {{field_trip_insurance}}::pool {
    use std::signer;
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::AptosCoin;

    struct Pool has key {
        owner: address,
        leader: address,
        max_payout: u64,
        balance: Coin,
    }

    public entry fun init_pool(owner: &signer, leader: address, max_payout: u64) {
        // publish Pool resource, set leader and cap, mint empty balance
    }

    public entry fun contribute(sender: &signer, amount: u64) {
        // deposit APT into pool.balance
    }

    public entry fun approve_payout(caller: &signer, recipient: address, amount: u64) {
        // assert signer::address_of(caller) == pool.leader
        // assert amount )
- On‑chain events for contributions and payouts (indexer‑friendly)
- Governance to update leader, caps, and pool status
- Refund policy for unused premiums after trip completion
- Role‑based co‑leaders and emergency controls
- Claim metadata and auditable claim registry
- Web dashboard (Next.js) for non‑technical users

***

## ✅ Verification Checklist

- Explorer shows:
  - Status: Success
  - Function: code::publish_package_txn
  - Sender equals package owner
- README Contract Address matches Move.toml [addresses]
- All entry calls reference 0xYOUR_ACCOUNT_ADDRESS::module::function

***

## 🖼 Attachments

- <img width="455" height="643" alt="image" src="https://github.com/user-attachments/assets/dfea82e6-1a2f-4747-8e82-9c7d4860036b" />


If desired, share the exact package/account address (sender/owner from the publish) and this README will be auto‑filled with the concrete address throughout.
