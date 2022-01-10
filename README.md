# walletTruffleProject
## A simply smart contract to demonstrate a multisig wallet where multiple "signatures" or approvals are needed for an outgoing transfer to take place.

Requirements:

- Anyone should be able to deposit ether into the smart contract
- The contract creator should be able to input 
  - the addresses of the owners and 
  - the numbers of approvals required for a transfer, in the constructor. For example, input 3 addresses and set the approval limit to 2. 
- Anyone of the owners should be able to create a transfer request(createTransfer()). The creator of the transfer request will specify what amount and to what address the transfer will be made.
- Owners should be able to approve transfer requests.
- When a transfer request has the required approvals, the transfer should be sent. 


Test: In Remix
1. set the following values :
> - _owners = ["0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372"]
> - _limit  = 2
> - click "transact"

2. make a deposit to the 3 addresses above - from Value = 20 ether, click deposit()
3. createTransfer() 
> - two parameters :
> - 30000000000000000000 (30 + 18 zeros), address of one of the owners (see onlyOwners in createTransfer())          
4. click getTransferRequests(), you will see all the transfer objects and its transfer request = 0 (zero bec it is the first element in the array transferRequests.length)
5. enter 0 and click approve()
6. select a new address (one of the owners) > click approve() with 0 value (zero bec it is the first element in the array transferRequests.length)

Migrate:
>      PS D:\blockchain\walletTruffleProject> truffle console
>      truffle(development)> migrate --reset

      Compiling your contracts...
      ===========================
      > Compiling .\contracts\Migrations.sol
      > Compiling .\contracts\Wallet.sol
      > Artifacts written to D:\blockchain\walletTruffleProject\build\contracts
      > Compiled successfully using:
         - solc: 0.8.10+commit.fc410830.Emscripten.clang



      Starting migrations...
      ======================
      > Network name:    'development'
      > Network id:      5777
      > Block gas limit: 6721975 (0x6691b7)


      1_initial_migration.js
      ======================

         Deploying 'Migrations'
         ----------------------
         > transaction hash:    0xef4e23c2af6311295ab5dbeca6a8a69f5f42084df0a6cf8d1bcf97b99651ef08
         > Blocks: 0            Seconds: 0
         > contract address:    0x5bf32f4Aa6D35B7A37F5b4dDd0DaFAbB9437C2c6
         > block number:        247
         > block timestamp:     1641806833
         > account:             0x949CE02E352E9Ed86AdcCeC797474Efaf6034e91
         > balance:             93.874064579987
         > gas used:            248854 (0x3cc16)
         > gas price:           20 gwei
         > value sent:          0 ETH
         > total cost:          0.00497708 ETH


         > Saving migration to chain.
         > Saving artifacts
         -------------------------------------
         > Total cost:          0.00497708 ETH


      Summary
      =======
      > Total deployments:   1
      > Final cost:          0.00497708 ETH


      - Blocks: 0            Seconds: 0
      - Saving migration to chain.
