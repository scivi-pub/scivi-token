pragma solidity ^0.4.23;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


    event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
 
  contract BasicToken is Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  
  
  /**
  * @dev total number of tokens in existence
  */
  
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

contract MintableScivi is BasicToken {
  
  event Mint(address indexed to, uint256 amount);
  event Burn(address indexed from, uint256 value);

  
   
    string public name;
    string public symbol;
    uint8 public decimals = 0;
    
    uint256 internal mintCurrentTime;
    uint256 internal burnCurrentTime;
    uint256 internal mintIntervalTime;
    uint256 internal burnIntervalTime;
    
    
    
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


  /**
   * Function to MINT new tokens
   * _to - The address that will receive the minted tokens.
   *  _amount - The amount of tokens to mint.
   * return - a boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
      
    
    require (_amount <= 500000);                    // limits a mint to 500 000 tokens
    require (mintTimer());                            // function that returns true in case intervalTime has elapsed (below)
   
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    
    mintIntervalTime = 7776000;                            // adds 3 months to pause minting
    mintCurrentTime = now + mintIntervalTime;             // adds 3 months
    
    
    return true;
    }
  
   function mintTimer() internal view returns (bool) {       // checks if intervalTime has elapsed, if so returns "true", required for the mint function. Decide on VIEW vs PURE
     return (mintCurrentTime <= now);                      
    }


    
   function burnTimer() internal view returns (bool) {       // checks if intervalTime has elapsed, if so returns "true", required for the mint function. Decide on VIEW vs PURE
     return (burnCurrentTime <= now);                      
    }

  
    /**
   * This function allows to destroy (BURN) tokens 
      */
        function burn(uint256 _value) onlyOwner public returns (bool success) {
        require(balances[owner] >= _value);   // Check if the sender has enough
        require (_value <= 500000);                    // limits a burn to 500 000 tokens
        require (burnTimer());                            // function that returns true in case intervalTime has elapsed (below)
        balances[owner] -= _value;            // Subtract from the sender
        totalSupply_ -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        
        burnIntervalTime = 7776000;                            // adds 3 months to pause burning
        burnCurrentTime = now + burnIntervalTime;             // adds 3 months to pause burning
        return true;
    }

   
}
