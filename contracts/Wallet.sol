
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/**
 * @title  Destroyable  
 * @author Lodgerio Padlan
 * @dev 
    - Anyone should be able to deposit ether into the smart contract
    - The contract creator should be able to input 
        (1): the addresses of the owners and 
        (2): the numbers of approvals required for a transfer, in the constructor. 
             For example, input 3 addresses and set the approval limit to 2. 
    - Anyone of the owners should be able to create a transfer request(createTransfer()). 
      The creator of the transfer request will specify what amount and to what address the transfer will be made.
    - Owners should be able to approve transfer requests.
    - When a transfer request has the required approvals, the transfer should be sent. 

    Test: In Remix
        1. set the following values
            _owners = ["0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372"]
            _limit  = 2

            click "transact"

        2. make a deposit to the 3 addresses above - from Value = 20 ether, click deposit()
        3. createTransfer() 
                - two parameters :
                  30000000000000000000 (30 + 18 zeros), address of one of the owners (see onlyOwners in createTransfer())          

        4. click getTransferRequests(), you will see all the transfer objects and its transfer request = 0 (zero bec it is the first element in the array transferRequests.length)
        5. enter 0 and click approve()
        6. select a new address (one of the owners) > click approve() with 0 value (zero bec it is the first element in the array transferRequests.length)


 * @notice  A simply smart contract to demonstrate a multisig wallet where multiple "signatures" or approvals are needed for an outgoing transfer to take place.
*/

contract Wallet {
    address[] public owners;
    uint limit; 
    
    // this is created as a control file
    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    event TransferRequestCreated(uint _id, uint _amount, address _initiator, address _receiver);
    event ApprovalReceived(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);

    Transfer[] transferRequests;
    
    mapping(address => mapping(uint => bool)) approvals;
    // diagram
	//      address1 -> mapping -> uint | bool
	//							    1     true
	//								2     false
	//		address2 -> mapping -> uint | bool
	//							    1     true
	//								2     false

    // save value :  approvals[msg.sender][_id] = true;  



    // Should only allow people in the owners list to continue the execution.
    modifier onlyOwners(){
        bool owner = false;
        for(uint i=0; i<owners.length;i++){
            if(owners[i] == msg.sender){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }

    // should initialize the owners list and the limit (number of approvals) 
    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit;
    }
    
    // empty function because we only need to deposit money. No need to return anything as we are not monitoring any balances.
    function deposit() public payable {}
    
    // create an instance of the Transfer struct and add it to the transferRequests array
    // initially set "hasBeenSent" to false 
      function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );        
    }

    
    // R1.Set your approval for one of the transfer requests.
    // R2.Need to update the Transfer object.
    // R3.Need to update the mapping to record the approval for the msg.sender.
    // R4.When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    // R5.An owner should not be able to vote twice.
    // R6.An owner should not be able to vote on a tranfer request that has already been sent.
    function approve(uint _id) public onlyOwners {
        // R5
        require(approvals[msg.sender][_id] == false);  // false when we start this function
        // R6
        require(transferRequests[_id].hasBeenSent == false); 
        
        // R3, R5
        approvals[msg.sender][_id] = true;          // after the first "require" of approve()babove, set it to true so  
        // R1, R2, R5
        transferRequests[_id].approvals++;          // increase the value of approvals. When a transfer request has the required approvals, the transfer should be sent.  
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);

        // R4  
        // transfer the amount if number of approvals has been met. 
        if(transferRequests[_id].approvals >= limit){
            // R2 
            transferRequests[_id].hasBeenSent = true;  // 
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
            emit TransferApproved(_id);
        }
    }
    
    //Should return all transfer requests
    function getTransferRequests() public view returns (Transfer[] memory){
        return transferRequests;
    }
    
    
}