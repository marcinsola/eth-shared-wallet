
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint) public allowance;

    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed!");
        _;
    }

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function setAllowance(address _to, uint _amount) public onlyOwner {
        emit AllowanceChanged(_to, msg.sender, allowance[_to], _amount);
        allowance[_to] = _amount;
    }

    function reduceAllowance(address _to, uint _amount) public ownerOrAllowed(_amount) {
        require(allowance[_to] - _amount > 0, "Too much to reduce");
        emit AllowanceChanged(_to, msg.sender, allowance[_to], allowance[_to] - _amount);
        allowance[_to] -= _amount;
    }
}
