pragma solidity ^0.8;

error NotWhiteListed(address) ;
error Waitfor(uint256);
contract FaucetDispenser {

    event received(uint256);

   address public owner ;

   constructor(){
       owner = msg.sender;
   }

    address[3] whiteList ;

    modifier onlyWhitelisted()
    {
        if(msg.sender != whiteList[0] && msg.sender != whiteList[1] && msg.sender != whiteList[2])
        {
            revert NotWhiteListed(msg.sender);
        }
   _; }

    modifier timeCheck() {
        if(lastTs[msg.sender] + 10 minutes > block.timestamp){
            revert Waitfor( lastTs[msg.sender] + 10 minutes - block.timestamp);
        }
    _;}

    mapping (address => uint256) lastTs;
    
    
    function getFacuet(address payable  rec) public onlyWhitelisted timeCheck{
        lastTs[rec] = block.timestamp;
        rec.transfer(5 ether);
    } 

    function whiteListSetter(uint8 no, address AdminAdd)  public  {
        require(msg.sender == owner, "Not owner");
        whiteList[no] = AdminAdd;
    }

    function takeDown() public {
        require(msg.sender == owner, "Not owner");
        address payable   x = payable(owner);
        x.transfer(address(this).balance);
    }

    receive() external payable {
        emit received(msg.value);
    }
}