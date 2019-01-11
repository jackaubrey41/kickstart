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
    
    // Variables de tipo storage grabadas en el blockchain
    address public manager;                             // @ of person who is managin dthe campaign. Campaign argument
    uint public minimumContribution;                   // Minimum donation required to be approver. Campaign argument
    mapping ( uint => address ) public approversMap;    // list of addresses of contributors indexed
    Request[] public requests;                        // List of requests created by mananager in this campaign. Dinamic array
    uint private numContributors;                       // contributors count index
    uint private numRequest;
                                                            
                                                            
    constructor (uint _minimumContribution) public {    // Constructor Campaign. MinimumContribution is parameter. Argument must be introduced.
        manager = msg.sender;                           // who deploy is the manager
        minimumContribution = _minimumContribution;     // Init minimumContribution internal varialble
        numContributors = 0 ;                                     // Init index array contributors
        numRequest = 0;
    }
    
    function contribute () public payable {             // Payable function
        require ( msg.value >= minimumContribution );   // Require that contribution is equal or major to minimumContribution
        numContributors++;                              // increase number of contributors and index of array
        approversMap[numContributors] = msg.sender;     // set @ in list of contributors
        // falta comprobar que no se duplica el contribuidor aunque lo ideal es que pudiera incrementar su inversion en el proyecto. 
    }
    
   
   
    // public view es un call data de lectura
    // public (payable or non-payable default) es una transaccion que consume gas
    // la funcion es public (non-payable default) puesto que no añade al balance del contrato pero modifica variables generales en BC?????.
    function createRequest (string _description, uint _amount, address _recipient) public {
        require (msg.sender == manager );               // unicamente puede ejecutar un Request si es el manager
        // falta por ejemplo requerir que como mínimo tengamos un contributor
        // falta por requerir que la direccion destino no sea la del manager
        // falta requerir que el importe sea com maximo el balance disponible
        Request memory newRequest = Request({
           description: _description,
           amount: _amount,
           recipient: _recipient,
           complete: false,
//         approvalsMap. por defecto el valor es 0x0 para cualquier @ potencial
           approvalCount:0
        });
        
        requests[numRequest] = newRequest;
        requests.push(newRequest);                  // si es un array hay que realizar el push para escribir el valor
        numRequest++;                               // escribe en el blockcahin .....public non payable?º
     }
    
    function ApproveRequest () public {             // Called to aprove
       // require be contributor
       // require not vote previously
       // Add my @ to approvalsMap in current request structure
        requests[numRequest].approvalsMap[msg.sender] = true; // mismo error que antes
       
    }                      
    
    function finalizeRequest () public {
        // require only executed by manager
        require(msg.sender == manager);
        // require approvalCount >= numContributors/2
        require ( requests[numRequest].approvalCount >= numContributors/2);
        // send money to recipient (vendor). Public transaccion non payable.
        requests[numRequest].recipient.transfer (requests[numRequest].amount);
        // declara Request completado
        requests[numRequest].complete = true;
    }
    
    function getBalance() public view returns(uint) {   // retorna la suma de contribuciones al proyecto
        return address(this).balance;                   // retorna el balance del smart contrcat. función this accede a SmartContract
    }
}
