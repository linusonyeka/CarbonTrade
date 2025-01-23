# CarbonTrade Smart Contract

A decentralized carbon credit trading platform built on Stacks blockchain that enables efficient, transparent trading of carbon credits with automated verification and redemption mechanisms.

## Overview

This smart contract facilitates peer-to-peer trading of carbon credits while maintaining market integrity through automated verification, dynamic pricing, and reserve management. It provides a trustless environment for carbon credit transactions with built-in safety measures.

## Key Benefits

- Transparent carbon credit trading
- Automated verification and settlement
- Dynamic market pricing
- Secure ownership tracking
- Reserve limit management
- Efficient redemption process

## Contract Variables

- `carbon-credit-price`: Base price per credit (500 microstacks)
- `max-credits-per-user`: Maximum credits per user (50,000)
- `verification-rate`: Fee for transaction verification (10%)
- `redemption-rate`: Rate for credit redemption (85%)
- `credit-reserve-limit`: Global credit cap (5,000,000)
- `current-credit-reserve`: Current total credits in system

## Core Functions

### Trading Functions
- `add-credits-for-sale(amount, price)`: List credits for sale
- `buy-credits-from-user(seller, amount)`: Purchase credits from another user
- `remove-credits-from-sale(amount)`: Remove listed credits from market
- `redeem-credits(amount)`: Convert credits back to STX at current redemption rate

### Administrative Functions
- `set-carbon-credit-price(new-price)`: Update base credit price
- `set-verification-rate(new-rate)`: Modify verification fee percentage
- `set-redemption-rate(new-rate)`: Adjust credit redemption rate
- `set-credit-reserve-limit(new-limit)`: Update global credit cap
- `set-max-credits-per-user(new-max)`: Change per-user credit limit

### Query Functions
- `get-carbon-credit-price()`: Current credit price
- `get-credit-balance(user)`: User's credit holdings
- `get-credits-for-sale(user)`: Listed credits by user
- `get-current-credit-reserve()`: Total system credits
- `get-verification-rate()`: Current verification fee
- `get-redemption-rate()`: Current redemption rate
- `get-credit-reserve-limit()`: Global credit cap
- `get-max-credits-per-user()`: Per-user credit limit
- `get-stx-balance(user)`: User's STX balance

## Error Handling

### Transaction Errors
- `100`: Unauthorized (not owner)
- `101`: Insufficient balance
- `102`: Transfer failed
- `103`: Invalid price
- `104`: Invalid amount
- `105`: Invalid fee percentage
- `106`: Redemption failed
- `107`: Self-trading attempt
- `108`: Reserve limit breach
- `109`: Invalid reserve limit

## Security Features

1. **Access Control**
   - Owner-only administrative functions
   - Protected critical parameters

2. **Transaction Safety**
   - Balance verification before trades
   - Reserve limit enforcement
   - Automated verification system

3. **Market Integrity**
   - Dynamic pricing mechanism
   - Self-trade prevention
   - Reserve management

## Implementation Guide

1. **Deployment**
   ```bash
   clarinet contract deploy carbon-trade
   ```

2. **Initial Setup**
   - Set base credit price
   - Configure verification rate
   - Set redemption rate
   - Establish reserve limits

3. **Trading Operation**
   - Users list credits for sale
   - Buyers purchase with STX
   - Automatic verification fee collection
   - Redemption available at current rates

## Best Practices

1. **For Traders**
   - Verify credit balance before listing
   - Check current market prices
   - Monitor verification fees
   - Understand redemption rates

2. **For Administrators**
   - Regular market parameter reviews
   - Monitor reserve limits
   - Adjust rates based on market conditions
   - Maintain reasonable fee structures