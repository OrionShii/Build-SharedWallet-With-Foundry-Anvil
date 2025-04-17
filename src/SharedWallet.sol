// SPDX-License-Identifier:MIT
pragma solidity ^0.8.25;


contract SharedWallet{
    event DepositSuccesfull(address indexed sender, uint256 amount);
    event SpenderSet(address indexed spender, uint256 allowance);
    event WithdrawalSuccesfull(address indexed spender, uint256 amount);
    error NotOwner();
    error DepositCannotBeZero();
    error SpenderValueMismatch();
    error NotEnoughAllowance();
    error NotEnoughMoneytoAllow();
    error WithdrawalFailed();
    address public owner;
    
    mapping(address=>uint256) public spendersAllowance;
    constructor(address[] memory _spenderAddress,uint256[] memory _spendersAllowance) payable {
        owner=msg.sender;
        if(_spenderAddress.length != _spendersAllowance.length) revert SpenderValueMismatch();
        setAllowances(_spenderAddress, _spendersAllowance);
    }

    modifier onlyOwner(){
        if(msg.sender != owner) revert NotOwner();
        _;
    }
    modifier onlySpender(){

        if(spendersAllowance[msg.sender] == 0) revert NotEnoughAllowance();
        _;
    }


    function deposit() payable external onlyOwner{
        if(msg.value == 0) revert DepositCannotBeZero();
        emit DepositSuccesfull(msg.sender, msg.value);
    }
    function setAllowances(address[] memory _spenderAddress,uint256[] memory _spendersAllowance) public onlyOwner{
        if(_spenderAddress.length != _spendersAllowance.length) revert SpenderValueMismatch();
        uint256 length= _spenderAddress.length;
        for(uint256 i=0;i<length;i++){
            if(_spendersAllowance[i]>address(this).balance) revert NotEnoughMoneytoAllow();
            spendersAllowance[_spenderAddress[i]] = _spendersAllowance[i];
            emit SpenderSet(_spenderAddress[i], _spendersAllowance[i]);
        }
    }
    function withdraw(uint256 amount) external onlySpender{
        if(spendersAllowance[msg.sender] < amount) revert NotEnoughAllowance();
        spendersAllowance[msg.sender]-=amount;
        if(address(this).balance < amount) revert NotEnoughMoneytoAllow();
        // (bool success,)=msg.sender.call()
        (bool success,)=msg.sender.call{value:amount}("");
        if(!success) revert WithdrawalFailed();
        emit WithdrawalSuccesfull(msg.sender, amount);
    }
    function getBalance() external view returns(uint256){
        return address(this).balance;
    }
    function getAllowance() external view returns(uint256){
        return spendersAllowance[msg.sender];
    }
    function getOwner() external view returns(address){
        return owner;
    }

}