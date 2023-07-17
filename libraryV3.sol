// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Library{
    address owner;
    uint public bookSerial = 0;
    uint public bookSerialtemp;
    uint public BorrowTime;
    uint lateFee;

    constructor(){
        owner =payable (msg.sender);
    }
    struct Details{
        uint bookSerial;  // increment of Books taken
        string studentId; 
        string studentName;
        string bookId; // bcz of same book having different book id
        string bookName;
        uint lateFee ; 
        uint BorrowTime; // recorded time for book taken
    }   mapping (string=>mapping(uint=>Details))getDetails;
        mapping  (string=>Details)getSerial;
   
    event Borrowed(string _id,string _name,string _bookId, string _bookName);

    function payFee(string memory _id,uint _bookSerial,address payable  _to,uint _feeAmt) payable  public returns (uint)  {
            uint time = getDetails[_id][_bookSerial].BorrowTime;
            lateFee = calculateDays(block.timestamp + 86400 - time)*15; //What actually to be paid  later (15/1000)
            address payable to =_to;
            _feeAmt = msg.value;
            require(lateFee == _feeAmt,"Not sufficient");
            bool sent = to.send(_feeAmt); // what actually sending
            require(sent, "Failed to send Ether");
            getDetails[_id][_bookSerial].lateFee = 0;

            return(lateFee);
        }
    
       function Borrow(string memory _id,string memory _name,string memory _bookId,string memory _bookName) public{
            BorrowTime = block.timestamp;
            bookSerialtemp = getSerial[_id].bookSerial++;            
            getDetails[_id][bookSerialtemp] = Details(bookSerialtemp,_id,_name,_bookId,_bookName,lateFee,BorrowTime);
            emit Borrowed(_id, _name,_bookId, _bookName);
            
        }

        function GetDetails(string memory _id,uint _bookSerial)public view returns(Details memory){    
        
           Details memory student = getDetails[_id][_bookSerial];
           
           return student;

        }


  function calculateDays(uint256 secondsValue) public pure returns (uint256) {
    uint256 secondsInDay = 86400;
    uint256 daysValue = secondsValue / secondsInDay;
    return daysValue;
}
        function howMuchToPay(string memory _id,uint _bookSerial) public  view  returns (uint ){
             uint time = getDetails[_id][_bookSerial].BorrowTime;
            
            uint feeToPay = calculateDays(block.timestamp + 86400 - time)*15; //What actually to be paid  later (15/1000)
            return (feeToPay);

        }


}

// 0x60F4b355f9CA0D05F6e59ebB7B473b03E39eB24c

// [
// 	{
// 		"inputs": [],
// 		"stateMutability": "nonpayable",
// 		"type": "constructor"
// 	},
// 	{
// 		"inputs": [
// 			{
// 				"internalType": "string",
// 				"name": "_id",
// 				"type": "string"
// 			},
// 			{
// 				"internalType": "string",
// 				"name": "_name",
// 				"type": "string"
// 			},
// 			{
// 				"internalType": "string",
// 				"name": "_bookId",
// 				"type": "string"
// 			},
// 			{
// 				"internalType": "string",
// 				"name": "_bookName",
// 				"type": "string"
// 			}
// 		],
// 		"name": "Borrow",
// 		"outputs": [],
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"inputs": [
// 			{
// 				"internalType": "string",
// 				"name": "_id",
// 				"type": "string"
// 			},
// 			{
// 				"internalType": "uint256",
// 				"name": "_bookSerial",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "GetDetails",
// 		"outputs": [
// 			{
// 				"components": [
// 					{
// 						"internalType": "uint256",
// 						"name": "bookSerial",
// 						"type": "uint256"
// 					},
// 					{
// 						"internalType": "string",
// 						"name": "studentId",
// 						"type": "string"
// 					},
// 					{
// 						"internalType": "string",
// 						"name": "studentName",
// 						"type": "string"
// 					},
// 					{
// 						"internalType": "string",
// 						"name": "bookId",
// 						"type": "string"
// 					},
// 					{
// 						"internalType": "string",
// 						"name": "bookName",
// 						"type": "string"
// 					},
// 					{
// 						"internalType": "uint256",
// 						"name": "lateFee",
// 						"type": "uint256"
// 					}
// 				],
// 				"internalType": "struct Library.Details",
// 				"name": "",
// 				"type": "tuple"
// 			}
// 		],
// 		"stateMutability": "view",
// 		"type": "function"
// 	},
// 	{
// 		"inputs": [],
// 		"name": "bookSerial",
// 		"outputs": [
// 			{
// 				"internalType": "uint256",
// 				"name": "",
// 				"type": "uint256"
// 			}
// 		],
// 		"stateMutability": "view",
// 		"type": "function"
// 	},
// 	{
// 		"inputs": [],
// 		"name": "bookSerialtemp",
// 		"outputs": [
// 			{
// 				"internalType": "uint256",
// 				"name": "",
// 				"type": "uint256"
// 			}
// 		],
// 		"stateMutability": "view",
// 		"type": "function"
// 	},
// 	{
// 		"inputs": [
// 			{
// 				"internalType": "string",
// 				"name": "_id",
// 				"type": "string"
// 			},
// 			{
// 				"internalType": "uint256",
// 				"name": "_bookSerial",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "payFee",
// 		"outputs": [
// 			{
// 				"internalType": "uint256",
// 				"name": "",
// 				"type": "uint256"
// 			}
// 		],
// 		"stateMutability": "payable",
// 		"type": "function"
// 	}
// ]
