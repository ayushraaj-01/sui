module basic_defi_nft::main {

    use sui::object;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::event;

    /// --- NFT struct ---
    struct MyNFT has key, store {
        id: object::UID,
        name: String,
        url: String,
    }

    /// Mint NFT
    public entry fun mint(
        name: String,
        url: String,
        ctx: &mut TxContext
    ) {
        let nft = MyNFT {
            id: object::new(ctx),
            name,
            url
        };
        event::emit(nft);
    }

    /// --- Simple DeFi Vault ---
    struct Vault has key {
        id: object::UID,
        balance: balance::Balance<SUI>
    }

    /// Initialize Vault
    public entry fun init_vault(ctx: &mut TxContext) {
        let vault = Vault {
            id: object::new(ctx),
            balance: balance::zero<SUI>()
        };
        event::emit(vault);
    }

    /// Deposit SUI into vault
    public entry fun deposit(
        vault: &mut Vault,
        coins: Coin<SUI>
    ) {
        let amount = coin::value(&coins);
        let bal = coin::into_balance(coins);
        balance::join(&mut vault.balance, bal);
        event::emit(amount);
    }

    /// Borrow (placeholder for now)
    public entry fun borrow(
        _vault: &mut Vault,
        amount: u64,
        ctx: &mut TxContext
    ) {
        event::emit(amount);
        let _coin = coin::mint<SUI>(amount, ctx);
    }

    /// Repay (placeholder)
    public entry fun repay(
        _vault: &mut Vault,
        coins: Coin<SUI>
    ) {
        let amount = coin::value(&coins);
        event::emit(amount);
        coin::burn(coins);
    }
}
