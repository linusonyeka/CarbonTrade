# CarbonTrade Smart Contract

A decentralized carbon credit trading platform built on Stacks blockchain.

## Features

- Buy and sell carbon credits
- Automated verification system
- Credit redemption mechanism
- Reserve limit management
- Dynamic pricing system

## Contract Variables

- `carbon-credit-price`: Base price per credit (500 microstacks)
- `max-credits-per-user`: Maximum credits per user (50,000)
- `verification-rate`: Fee for transaction verification (10%)
- `redemption-rate`: Rate for credit redemption (85%)
- `credit-reserve-limit`: Global credit cap (5,000,000)

## Functions

### Public Functions

- `add-credits-for-sale`: List credits for sale
- `buy-credits-from-user`: Purchase credits
- `redeem-credits`: Redeem credits for STX
- `remove-credits-from-sale`: Delist credits

### Admin Functions

- `set-carbon-credit-price`: Update base price
- `set-verification-rate`: Modify verification fee
- `set-redemption-rate`: Adjust redemption rate
- `set-credit-reserve-limit`: Change global cap
- `set-max-credits-per-user`: Update per-user limit

### Read-Only Functions

- `get-carbon-credit-price`: Current price
- `get-credit-balance`: User balance
- `get-credits-for-sale`: Listed credits
- `get-current-credit-reserve`: Total credits in system

## Error Codes

- `100`: Not owner
- `101`: Insufficient balance
- `102`: Transfer failed
- `103`: Invalid price
- `104`: Invalid amount
- `105`: Invalid fee
- `106`: Refund failed
- `107`: Same user
- `108`: Reserve limit exceeded
- `109`: Invalid reserve limit

## Usage

1. Deploy contract to Stacks blockchain
2. Initialize pricing parameters
3. Users can then buy, sell, and redeem credits

## Security

- Owner-only administrative functions
- Balance checks before transactions
- Reserve limit enforcement
- Transaction verification system