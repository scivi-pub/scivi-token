pragma solidity ^0.4.23;

import "./BasicToken.sol";
import "./Ownable.sol";

 
contract MintableWithLimits is BasicToken {
  event Mint(address indexed to, uint256 amount);
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Burn(address indexed from, uint256 value);

  
   
    string public name;
    string public symbol;
    uint8 public decimals = 0;
    
    uint256 internal mintCurrentTime;
    uint256 internal burnCurrentTime;
    uint256 internal mintIntervalTime;
    uint256 internal burnIntervalTime;
    
    
  

 /**
  Not sure we need the following two functions for setting a moratorium on minitng process start
   
  
  function getTime() public returns (uint256){                 // Returns current time. Check VISIBILITY 
    return now;
    }
 
 
  function mintUnlocked() internal returns (bool) {           // Checks if current time is greater than set time that would be allowed for minint start 
    return (getTime() >= 1525113448);                         // 04/30/2018 @ 1:21pm (UTC) in this case. Expresed as UNIX time
    return (getTime() >= 1525215600);                       // 05/01/2018 @ 11:00pm (UTC). This should block miniting till the  evening of May 1st, if uncommented and upper line deleted
    }
    
    */

  /**
   * Function to MINT new tokens
   * _to - The address that will receive the minted tokens.
   *  _amount - The amount of tokens to mint.
   * return - a boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
      
    //require (mintUnlocked());                   // prevents minitng untill time is competent for minting campaign start. Not sure if we need it
    require (_amount <= 1000);                    // limits a mint to 1000 tokens
    require (mintTimer());                            // function that returns true in case intervalTime has elapsed (below)
   
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    
    mintIntervalTime = 60;                            // adds 60 sec to pause minting
    mintCurrentTime = now + mintIntervalTime;             // adds 60 sec to pause minting
    
    
    return true;
    }
  
function mintTimer() internal view returns (bool) {       // checks if intervalTime has elapsed, if so returns "true", required for the mint function. Decide on VIEW vs PURE
     return (mintCurrentTime <= now);                      
    }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  
  
 
    
   /**
   * Gives name and symbol
   * Use " " with the string
   */
  constructor (
        string tokenName,
        string tokenSymbol,
        uint256 initialSupply
    ) public {
        name = tokenName;                                   
        symbol = tokenSymbol;
        totalSupply_ = initialSupply;
        balances[owner] = totalSupply_;
        
        
    }
    
    function burnTimer() internal view returns (bool) {       // checks if intervalTime has elapsed, if so returns "true", required for the mint function. Decide on VIEW vs PURE
     return (burnCurrentTime <= now);                      
    }

  
    /**
   * This function allows to destroy (BURN) tokens 
      */
        function burn(uint256 _value) public returns (bool success) {
        require(balances[owner] >= _value);   // Check if the sender has enough
        require (_value <= 1000);                    // limits a burn to 1000 tokens
        require (burnTimer());                            // function that returns true in case intervalTime has elapsed (below)
        balances[owner] -= _value;            // Subtract from the sender
        totalSupply_ -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        
        burnIntervalTime = 60;                            // adds 60 sec to pause burning
        burnCurrentTime = now + burnIntervalTime;             // adds 60 sec to pause burning
        return true;
    }

   
}
