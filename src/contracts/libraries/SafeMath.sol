// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    // build functions to perform safe math operation that would otherwise rep;ace intuitive preventative measure
    	    // function add r = x + y
    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
            require(r >= x, 'SafeMath: Addition overflow');
        return r;
    }

    // function subtract r = x - y
    function sub(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y <= x, 'SafeMath: subtraction overflow');
        uint256 r = x - y;
        return r;
    }

    // function multiply r = x * y
    function mul(uint256 x, uint256 y) internal pure returns(uint256) {
    // gas optimization
        if(x == 0) {
            return 0;
        }

        uint256 r = x * y;
        require(r / x == y, 'SafeMath: multiplication overflow');
        return r;
    }

    // function divide r = x / y
    function divide(uint256 x, uint256 y) internal pure returns(uint) {
        require(y > 0, 'SafeMath: division by zero');
        uint256 r = x / y;
        return r;  
    }

    // gas spending remains untouched 

    function mod(uint256 x, uint256 y) internal pure returns(uint) {
        require(y != 0, 'Safemath: modulo by zero');
        return x % y;
    }
}