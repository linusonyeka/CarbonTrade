;; CarbonTrade - Carbon Credit Trading Smart Contract

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-enough-balance (err u101))
(define-constant err-transfer-failed (err u102))
(define-constant err-invalid-price (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-invalid-fee (err u105))
(define-constant err-refund-failed (err u106))
(define-constant err-same-user (err u107))
(define-constant err-reserve-limit-exceeded (err u108))
(define-constant err-invalid-reserve-limit (err u109))

;; Define data variables
(define-data-var carbon-credit-price uint u500) ;; Price per carbon credit in microstacks
(define-data-var max-credits-per-user uint u50000) ;; Maximum carbon credits a user can add
(define-data-var verification-rate uint u10) ;; Verification fee in percentage
(define-data-var redemption-rate uint u85) ;; Redemption rate in percentage
(define-data-var credit-reserve-limit uint u5000000) ;; Global carbon credit reserve limit
(define-data-var current-credit-reserve uint u0) ;; Current total credits in the system

;; Define data maps
(define-map user-credit-balance principal uint)
(define-map user-stx-balance principal uint)
(define-map credits-for-sale {user: principal} {amount: uint, price: uint})

;; Private functions

;; Calculate verification fee
(define-private (calculate-credit-verification-fee (amount uint))
  (/ (* amount (var-get verification-rate)) u100))

;; Calculate redemption amount
(define-private (calculate-redemption (amount uint))
  (/ (* amount (var-get carbon-credit-price) (var-get redemption-rate)) u100))

;; Update credit reserve
(define-private (update-credit-reserve (amount int))
  (let (
    (current-reserve (var-get current-credit-reserve))
    (new-reserve (if (< amount 0)
                     (if (>= current-reserve (to-uint (- 0 amount)))
                         (- current-reserve (to-uint (- 0 amount)))
                         u0)
                     (+ current-reserve (to-uint amount))))
  )
    (asserts! (<= new-reserve (var-get credit-reserve-limit)) err-reserve-limit-exceeded)
    (var-set current-credit-reserve new-reserve)
    (ok true)))

;; Public functions

;; Set carbon credit price (only contract owner)
(define-public (set-carbon-credit-price (new-price uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> new-price u0) err-invalid-price)
    (var-set carbon-credit-price new-price)
    (ok true)))

;; Set verification fee (only contract owner)
(define-public (set-verification-fee (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= new-rate u100) err-invalid-fee)
    (var-set verification-rate new-rate)
    (ok true)))

;; Set redemption rate (only contract owner)
(define-public (set-redemption-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (<= new-rate u100) err-invalid-fee)
    (var-set redemption-rate new-rate)
    (ok true)))

;; Set credit reserve limit (only contract owner)
(define-public (set-credit-reserve-limit (new-limit uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (>= new-limit (var-get current-credit-reserve)) err-invalid-reserve-limit)
    (var-set credit-reserve-limit new-limit)
    (ok true)))

;; Add credits for sale
(define-public (add-credits-for-sale (amount uint) (price uint))
  (let (
    (current-balance (default-to u0 (map-get? user-credit-balance tx-sender)))
    (current-for-sale (get amount (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: tx-sender}))))
    (new-for-sale (+ amount current-for-sale))
  )
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (> price u0) err-invalid-price)
    (asserts! (>= current-balance new-for-sale) err-not-enough-balance)
    (try! (update-credit-reserve (to-int amount)))
    (map-set credits-for-sale {user: tx-sender} {amount: new-for-sale, price: price})
    (ok true)))

;; Remove credits from sale
(define-public (remove-credits-from-sale (amount uint))
  (let (
    (current-for-sale (get amount (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: tx-sender}))))
  )
    (asserts! (>= current-for-sale amount) err-not-enough-balance)
    (try! (update-credit-reserve (to-int (- amount))))
    (map-set credits-for-sale {user: tx-sender} 
             {amount: (- current-for-sale amount), 
              price: (get price (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: tx-sender})))})
    (ok true)))

;; Remove credits from sale
(define-public (remove-credits-from-sale (amount uint))
  (let (
    (current-for-sale (get amount (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: tx-sender}))))
  )
    (asserts! (>= current-for-sale amount) err-not-enough-balance)
    (try! (update-credit-reserve (to-int (- amount))))
    (map-set credits-for-sale {user: tx-sender} 
             {amount: (- current-for-sale amount), 
              price: (get price (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: tx-sender})))})
    (ok true)))

;; Buy credits from user
(define-public (buy-credits-from-user (seller principal) (amount uint))
  (let (
    (sale-data (default-to {amount: u0, price: u0} (map-get? credits-for-sale {user: seller})))
    (credit-cost (* amount (get price sale-data)))
    (verification-fee (calculate-credit-verification-fee credit-cost))
    (total-cost (+ credit-cost verification-fee))
    (seller-credits (default-to u0 (map-get? user-credit-balance seller)))
    (buyer-balance (default-to u0 (map-get? user-stx-balance tx-sender)))
    (seller-balance (default-to u0 (map-get? user-stx-balance seller)))
    (owner-balance (default-to u0 (map-get? user-stx-balance contract-owner)))
  )
    (asserts! (not (is-eq tx-sender seller)) err-same-user)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (>= (get amount sale-data) amount) err-not-enough-balance)
    (asserts! (>= seller-credits amount) err-not-enough-balance)
    (asserts! (>= buyer-balance total-cost) err-not-enough-balance)
    
    ;; Update seller's credit balance and for-sale amount
    (map-set user-credit-balance seller (- seller-credits amount))
    (map-set credits-for-sale {user: seller} 
             {amount: (- (get amount sale-data) amount), price: (get price sale-data)})
    
    ;; Update buyer's STX and credit balance
    (map-set user-stx-balance tx-sender (- buyer-balance total-cost))
    (map-set user-credit-balance tx-sender (+ (default-to u0 (map-get? user-credit-balance tx-sender)) amount))
    
    ;; Update seller's and contract owner's STX balance
    (map-set user-stx-balance seller (+ seller-balance credit-cost))
    (map-set user-stx-balance contract-owner (+ owner-balance verification-fee))
    
    (ok true)))
