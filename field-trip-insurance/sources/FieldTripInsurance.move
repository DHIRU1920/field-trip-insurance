module MyModule::FieldTripInsurance {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    
    /// Struct representing a field trip insurance pool.
    struct InsurancePool has store, key {
        total_premiums: u64,     // Total premiums collected
        trip_leader: address,    // Authorized trip leader for payouts
        max_payout: u64,         // Maximum payout per claim
    }
    
    /// Function to create insurance pool with trip leader authorization.
    public fun create_insurance_pool(
        creator: &signer, 
        trip_leader: address, 
        max_payout: u64
    ) {
        let pool = InsurancePool {
            total_premiums: 0,
            trip_leader,
            max_payout,
        };
        move_to(creator, pool);
    }
    
    /// Function for participants to contribute insurance premiums.
    public fun contribute_premium(
        participant: &signer, 
        pool_owner: address, 
        amount: u64
    ) acquires InsurancePool {
        let pool = borrow_global_mut<InsurancePool>(pool_owner);
        
        // Transfer premium from participant to pool owner
        let premium = coin::withdraw<AptosCoin>(participant, amount);
        coin::deposit<AptosCoin>(pool_owner, premium);
        
        // Update total premiums collected
        pool.total_premiums = pool.total_premiums + amount;
    }
    
    /// Function for trip leader to request payout for claims.
    public fun request_payout(
        leader: &signer,
        pool_owner: address,
        recipient: address,
        amount: u64
    ) acquires InsurancePool {
        let pool = borrow_global_mut<InsurancePool>(pool_owner);
        let leader_addr = signer::address_of(leader);
        
        // Verify leader authorization and sufficient funds
        assert!(leader_addr == pool.trip_leader, 1);
        assert!(amount <= pool.max_payout, 2);
        assert!(amount <= pool.total_premiums, 3);
        
        // Transfer payout from pool to recipient
        let payout = coin::withdraw<AptosCoin>(leader, amount);
        coin::deposit<AptosCoin>(recipient, payout);
        
        // Update remaining premium pool
        pool.total_premiums = pool.total_premiums - amount;
    }
}
