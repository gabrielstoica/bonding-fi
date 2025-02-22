// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Events } from "./utils/Events.sol";
import { Users } from "./utils/Types.sol";
import { ContinuousLinearToken } from "./../src/tokens/ContinousLinearToken.sol";
import "forge-std/Test.sol";

abstract contract Base_Test is Test, Events {
    /*//////////////////////////////////////////////////////////////////////////
                                     VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   TEST CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    ContinuousLinearToken internal linearToken;

    /*//////////////////////////////////////////////////////////////////////////
                                  SET-UP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        users = Users({ admin: createUser("admin"), bob: createUser("bob"), eve: createUser("eve") });

        linearToken = deployContinousLinearToken({
            _name: "ContinuousLinearToken",
            _symbol: "CLT",
            _slope: 0.0005e18,
            _initialPrice: 1e18
        });
    }

    /*//////////////////////////////////////////////////////////////////////////
                            DEPLOYMENT-RELATED FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Deploys a new {ContinuousLinearToken} contract
    function deployContinousLinearToken(
        string memory _name,
        string memory _symbol,
        uint256 _slope,
        uint256 _initialPrice
    ) internal returns (ContinuousLinearToken) {
        return new ContinuousLinearToken(_name, _symbol, _slope, _initialPrice);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                    OTHER HELPERS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Generates a user, labels its address, and funds it with test assets
    function createUser(string memory name) internal returns (address payable) {
        address payable user = payable(makeAddr(name));
        vm.deal({ account: user, newBalance: 100_000 ether });

        return user;
    }
}
