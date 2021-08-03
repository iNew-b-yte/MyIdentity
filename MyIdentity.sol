/**
 * A simple Contract to store the identities of the users.
 * The idea behind the MyIdentity Contract is to store the identity of the users 
 * in mapping and show certain data of the users keeping the rest of the data hidden from others,
 * so only that particular data is displayed
 *   
 */

//SPDX-License-Identifier: GPL-3.0 
pragma solidity >=0.6.0 < 0.9.0;

/**
 * Title: Abstract_Identity
 * An abstract contract in which all the functions are defined which is used as base for the contract MyIdentity.
 * 
 */
abstract contract Abstract_Identity{
    
    //creates the identity of the user.
    function setIdentity ( string memory Name, uint256 _phone_No, string memory _fatherName, string memory _homeAddress) external virtual;
    
    //returns the address of the user.
    function get_User_Address() external virtual returns(address);
    
    //returns the Name of the user.
    function get_User_Name() external virtual returns(string memory);
    
    //returns the phone no of the user.
    function get_User_PhoneNO() external virtual returns(uint);
    
    //returns the father's name of the user.
    function get_User_Father_Name()external virtual returns(string memory);
    
    //returns the home address of the user.
    function get_User_Home_address()external virtual returns(string memory);
    
    // deletes the identity of the user.
    function destroyIdentity(address addWantToBeDeleted) external virtual;
}


/**
 * Title: Modified
 * This is a contract that contains all the modifier used in the MyIdentity 
 * contract.
 */

 contract Modified{
         address owner;
         address[] UserAddress;
     
     
     //The modifier "OnlyOnce" stops the users from creating their identity again.
         modifier OnlyOnce{
         bool _OnlyOnce = false;
         for ( uint i=0; i<UserAddress.length; i++){
             if(UserAddress[i]==msg.sender){
                 _OnlyOnce = true;
                 break;
             }
         }
         
         //it requires _OnlyOnce to be false, others wise the second part is displayed.
         require(!_OnlyOnce,"You are already registered");
         _;
     }
     
     modifier OnlyOwner{
         
         //It requires msg.sender to be the owner of th contract.
         require(msg.sender==owner,"You are unauthorized");
         _;
     }
    
    
    //This modifier let only users to access their identity
    
    modifier OnlyUser{
        bool _OnyUser=false; //defining and setting the variable _OnyUser to false, which means the user is not in the database.
        for(uint i=0;i<UserAddress.length;i++){ //This loop checks whether the user is present in the UserAddress array and returns true.
            if(UserAddress[i]==msg.sender){
                _OnyUser=true;
            }
                
        }
        
        
        require(_OnyUser,"Prohibited!!! You cannot access others identity");
        _;
    }
    }

/**
 * A contract that stores the identity of the user and let them access only a particular data from their 
 * stored identity keeping the rest of the data hidden.
 * 
 * It inherits an abstract contract "Abstract_Identity" and a function in which Modifiers are defined.
 *
 */
 

contract MyIdentity is Abstract_Identity, Modified{
    
    //constructor in which the owner of the contract is set.
    constructor(){  owner=msg.sender;  }
    
    //The struct "_MyIdentity" stores the address , Name, phone no, father's name 
    //and home address of the user.
    struct _MyIdentity { 
    address _address;
    string Name;
    uint256 phone_No;
    string father_name; 
    string home_address;
   
    }
    
    
    //A mapping which has the address as the key and struct _MyIdentity as the value.
    mapping(address => _MyIdentity) myId;
    
    
    //The function setIdentity takes diiferent parameters from the user and stores it in the mapping.
    //This function also uses a modifier "OnlyOnce" which stops users from creating their identity more than once.
           function setIdentity ( string memory Name, uint256 _phone_No, string memory _fatherName, string memory _homeAddress) external override OnlyOnce{
           myId[msg.sender] = _MyIdentity(msg.sender,Name,_phone_No,_fatherName,_homeAddress);
           
           //Pushing the address of the user to an array "UserAddress".
           UserAddress.push(msg.sender);
     }
     
     //The function "destroyIdentity" deletes the user from the UserAddress array
     // and its data from the mapping.
     //This function uses a modifier OnlyOwner,so only owner can delete the identities.
     function destroyIdentity(address addressWantToBeDeleted) external override OnlyOwner{
         for(uint i=0;i<UserAddress.length;i++){
             if(UserAddress[i]==addressWantToBeDeleted){
                 delete UserAddress[i];
                 delete myId[addressWantToBeDeleted];
             }
         }
     }
     
     //This function returns the name of the user. 
     //This function uses the modifier "OnlyUser", so only users can access their identities.
     function get_User_Name() external override view OnlyUser returns(string memory){
             return myId[msg.sender].Name;
      }
     
     //This function returns the address of the user.
     //This function uses the modifier "OnlyUser", so only users can access their identities.
     function get_User_Address() external override  view OnlyUser returns(address){
             return myId[msg.sender]._address;
      }
      
     //This function returns the phone No of the user. 
     //This function uses the modifier "OnlyUser", so only users can access their identities.
     function get_User_PhoneNO() external override view OnlyUser returns(uint){
             return myId[msg.sender].phone_No;
      }
     //This function returns the father's name of the user.
     //This function uses the modifier "OnlyUser", so only users can access their identities.
     function get_User_Father_Name()external override view OnlyUser returns(string memory){
             return myId[msg.sender].father_name;
      }
      
     //This function returns the home address of the user.
     //This function uses the modifier "OnlyUser", so only users can access their identities.
     function get_User_Home_address()external override view OnlyUser returns(string memory){
             return myId[msg.sender].home_address;    
      }
      
}
    
   
    
    
    