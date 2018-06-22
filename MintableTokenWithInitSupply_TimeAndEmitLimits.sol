pragma solidity ^0.4.23;

import "./BasicToken.sol";
import "./Ownable.sol";

 
contract MintableTokenReducedWithBurnLimit2 is BasicToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Burn(address indexed from, uint256 value);

  bool public mintingFinished = false;                         // see below finishMiniting function
   
    string public name;
    string public symbol;
    uint8 public decimals = 0;
    
    uint256 internal mintCurrentTime;
    uint256 internal burnCurrentTime;
    uint256 internal mintIntervalTime;
    uint256 internal burnIntervalTime;
    
    
  modifier canMint() {                                         // see below finishMiniting function      
    require(!mintingFinished);
    _;
  }

  /**
   * Function to MINT new tokens
   * _to - The address that will receive the minted tokens.
   *  _amount - The amount of tokens to mint.
   * return - a boolean that indicates if the operation was successful.
   */
   
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    
    require (_amount <= 1000);                        // limits a mint to 1000 tokens
    require (mintTimer());                            // function that returns true in case intervalTime has elapsed (below)
   
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    
    mintIntervalTime = 60;                                // adds 60 sec to pause minting
    mintCurrentTime = now + mintIntervalTime;             // adds 60 sec to pause minting
        
    return true;
    }
  
function mintTimer() internal view returns (bool) {       // checks if mintIntervalTime has elapsed, if so returns "true", required for the mint function. Decide on VIEW vs PURE
     return (mintCurrentTime <= now);                      
    }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
    }
  
 
    
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
    
    function burnTimer() internal view returns (bool) {       // checks if burnIntervalTime has elapsed, if so returns "true", required for the burn function. Decide on VIEW vs PURE
     return (burnCurrentTime <= now);                      
    }

  
    /**
   * This function allows to destroy (BURN) tokens 
      */
        function burn(uint256 _value) public returns (bool success) {
        require(balances[owner] >= _value);          // Check if the sender has enough
        require (_value <= 1000);                    // limits a burn to 1000 tokens
        require (burnTimer());                       // function that returns true in case intervalTime has elapsed (below)
        balances[owner] -= _value;                   // Subtract from the sender
        totalSupply_ -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        
        burnIntervalTime = 60;                       // adds 60 sec to pause burning
        burnCurrentTime = now + burnIntervalTime;    // adds 60 sec to pause burning
        return true;
    }

  } 
