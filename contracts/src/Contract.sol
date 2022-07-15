// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Contract {
    uint256 public epoch;

    // first dimension is epoch
    // second dimension is user
    // value is counter
    uint256[][] public denseArray = [[0]];

    // maps epoch => [userCount, userCount, ...]; where index corresponds to user's id
    mapping(uint256 => uint256[]) public counterArray;

    // maps epoch => user id => count
    mapping(uint256 => mapping(uint256 => uint256)) public counterMap;

    event CounterEvent(uint256 epoch, uint256 id);

    /// ------------------------------------------------
    /// Function names optimized with:
    /// https://emn178.github.io/solidity-optimize-name/
    /// ------------------------------------------------
    function increaseEpoch_wlL() public {
        unchecked { epoch++; }
    }

    function countByArray_XBR(uint256 id) public {
        unchecked { counterArray[epoch][id]++; }
    }

    function countByMap_w_4(uint256 id) public {
        unchecked { counterMap[epoch][id]++; }
    }

    function countByDense_S7M(uint256 id) public {
        unchecked { denseArray[epoch][id]++; }
    }

    function triggerCounterEvent_956(uint256 id) public {
        emit CounterEvent(epoch, id);
    }

    /// ------------------------------------------------
    /// Utility functions to get the contract into a testable state
    /// ------------------------------------------------
    function addUserArray() public {
        if (counterArray[epoch].length == 0) {
            counterArray[epoch] = [0];
        } else {
            counterArray[epoch].push(0);
        }
    }

    // function addUserDense() public {
    //     // add to the epoch dimension if it doesnt exist
    //     if (denseArray.length < epoch + 1) {
    //         denseArray.push([0]);
    //     } else {
    //         denseArray[epoch].push([0]);
    //     }
    // }
}
