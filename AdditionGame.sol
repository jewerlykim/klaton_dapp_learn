// SPDX-License-Identifier: Jewelry.Kim
pragma solidity 0.8.13;

contract AdditionGame {
    address public owner; // 주소형 타입

    constructor() { // don't need public(visibility)
        owner = msg.sender; // 배포하는 계정
    }

    function getSenderBalance() public view returns(uint) {
        return msg.sender.balance;
    }

    function getBalance() public view returns (uint) { // view 읽기 전용
        return address(this).balance;
    }

    function transfer(uint _value) public returns (bool) {
        _value *= 10e18;
        require(getBalance() >= _value);
        payable(msg.sender).transfer(_value);
        return true;
    }
}