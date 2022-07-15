// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/Contract.sol";

contract ContractTest is Test {
    Contract c;
    function setUp() public {
        c = new Contract();
    }

    function testEpoch() public {
        c.increaseEpoch_wlL();
    }

    function testCounterArray() public {
        c.addUserArray();
        c.countByArray_XBR(0);
        c.addUserArray();
        c.countByArray_XBR(1);
        c.countByArray_XBR(1);
    }

    function testCounterMap() public {
        c.countByMap_w_4(5);
    }

    function testCounterEvent() public {
        c.triggerCounterEvent_956(5);
    }
}
