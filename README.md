```markdown
# Field Trip Insurance Smart Contract 🏫

Insure school field trips with transparent, rules-based payouts on the Aptos blockchain. Participants contribute premiums; an authorized trip leader processes claims within preset limits. Simple. Auditable. Fast.

---

## ✨ Features

- ✅ Create insurance pools with an authorized trip leader
- ✅ Multiple participants can contribute premiums
- ✅ Secure claim processing with authorization checks
- ✅ Maximum payout limits and balance validation
- ✅ Read-only view functions for transparent state
- ✅ Comprehensive unit tests (8 scenarios)

---

## 📚 Contract Surface

- Entry functions
  - `create_insurance_pool(creator, trip_leader, max_payout)`
  - `contribute_premium(participant, pool_owner, amount)`
  - `request_payout(leader, pool_owner, recipient, amount)`

- View functions
  - `pool_exists(pool_owner) -> bool`
  - `get_pool_info(pool_owner) -> (total_premiums, trip_leader, max_payout)`
  - `get_total_premiums(pool_owner) -> u64`
  - `get_max_payout(pool_owner) -> u64`
  - `get_trip_leader(pool_owner) -> address`

---

## 🗂️ Project Structure

```
field-trip-insurance/
├─ Move.toml
├─ sources/
│  └─ FieldTripInsurance.move
└─ tests/
   └─ field_trip_insurance_tests.move   (or tests embedded in module)
```

---

## ⚙️ Quick Start

1) Install Aptos CLI and set up a profile

2) Configure addresses
- Open `Move.toml` and set the `MyModule` address to the deploying account

3) Build & test
```
aptos move test
```

4) Publish to devnet/testnet
```
aptos move publish --profile devnet
```

---

## 🧪 Testing

Covers:
- Pool creation
- Premium contributions
- Successful payout
- Rejections for unauthorized leader, exceeding max payout, insufficient premiums
- Multi-participant, multi-claim flow

Run:
```
aptos move test
```

Expected:
```
Test result: OK. Total tests: 8; passed: 8; failed: 0
```

---

## 🔐 Security Model

- Only the configured trip leader can request payouts
- Claim amount must be ≤ `max_payout` and ≤ `total_premiums`
- Uses `AptosCoin` for simplicity; can be generalized to other coins
- Consider a dedicated custodial pool account for production deployments

---

## 🛣️ Roadmap

- Support custom fungible assets
- Emit events for contributions and payouts
- Refund policy for unused premiums
- Admin functions to update leader and limits with governance
- Next.js dashboard for non-technical users

---

## 🤝 Contributing

- Issues and PRs welcome—please include tests
- Keep functions small and explicit
- Follow Move and Aptos best practices

---

## 🧾 License

MIT — use freely and build safer trips on-chain.
```
