	// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './SafeMath.sol';


 library Counters {

    using SafeMath for uint256; 

    // build your own variable type with the keyword 'struct'

    // is a mechanism to keep track of our values of arithmetic changes
    // to our code 
    struct Counter {
        uint256 _value;
    }

    // we want to find the current value of a count 
    function current(Counter storage counter ) internal view returns(uint256) {
        return counter._value;
    } 

    // funtion that always increments by 1 
    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    // function that always decrement by 1 
    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}