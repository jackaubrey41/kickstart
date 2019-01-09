pragma solidity ^0.4.25;

contract Kickstart {
    
    //struct of Request
    struct Request {
        string description;                             // Purpose of Request
        uint amount;                                    // Ether to transfer
        address recipient;                              // Who gets de money
        bool complete;                                  // Whether the request is done
        mapping ( address => bool) approvalsMap;        // Track who has voted, 0x0 no voted, T or F voted.
        uint approvalCount;                             // Track number of approvals. Increase 1 with each approval.
    }
    
    address public manager;                             // @ of person who is managin dthe campaign. Campaign argument
    uint public minimumContribution;                   // Minimum donation required to be approver. Campaign argument
    mapping ( uint => address ) public approversMap;    // list of addresses of contributors indexed
    Request[] public requeslist;                        // List of requests created by mnanager in this campaign. Dinamic array

    uint private numContributors;                                 // contributors count index
  //  uint private amountContribution;

    constructor (uint _minimumContribution) public {    // Constructor Campaign minimum contribution is argument
        manager = msg.sender;                           // who deploy is the manager
        minimumContribution = _minimumContribution;     // Init minimumContribution internal varialble
        numContributors = 0 ;                                     // Init index array contributors
    }
    
    function contribute () public payable {             // Payable function
        require ( msg.value >= minimumContribution );   // Require that contribution is equal or major to minimumContribution
        numContributors++;                              // increase number of contributors and index of array
        approversMap[numContributors] = msg.sender;     // set @ in list of contributors
    }
    
    function getBalance() public view returns(uint) {   // retorna la suma de contribuciones al proyecto
        return address(this).balance;                   // retorna el balance del smart contrcat. función this accede a SmartContract
    }
}
