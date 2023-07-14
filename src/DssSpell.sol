// SPDX-FileCopyrightText: © 2020 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.8.16;

import "dss-exec-lib/DssExec.sol";
import "dss-exec-lib/DssAction.sol";

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/coastdao/community/xxx.md -q -O - 2>/dev/null)"
    string public constant override description =
    "2023-07-14 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 5%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.05)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmVp4mhhbwWGTfbh2BzwQB9eiBrQBKiqcPRZCaAxNUaar6
    //
    // uint256 internal constant X_PCT_RATE      = ;

    // 50%
    uint256 constant FIFTY_PCT_RATE = 1000000012857214317438491659;

    // --- DEPLOYED COLLATERAL ADDRESSES ---
    address internal constant STFX                     = 0x5aF7AC9DfE8C894E88a197033E550614f2214665;
    address internal constant PIP_STFX                 = 0x1EFf47a1Ad1821a095B56A8613B4e76471cAA744;
    address internal constant MCD_JOIN_STFX_A          = 0x0163a6ad232189728271c2E9b0B52D41b0127566;
    address internal constant MCD_CLIP_STFX_A          = 0x7C519FC50D1DB8ffd07d0Db13d2627F3bEf48953;
    address internal constant MCD_CLIP_CALC_STFX_A     = 0x0DBFA7E800bF135654156d6b8A7fB0d81dC676e1;

    function actions() public override {
        // ----------------------------- Collateral onboarding -----------------------------
        //  Add STFX-A as a new Vault Type

        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk:                  "STFX-A",
                gem:                  STFX,
                join:                 MCD_JOIN_STFX_A,
                clip:                 MCD_CLIP_STFX_A,
                calc:                 MCD_CLIP_CALC_STFX_A,
                pip:                  PIP_STFX,
                isLiquidatable:       true,
                isOSM:                true,
                whitelistOSM:         true,
                ilkDebtCeiling:       10_000_000,         // line starts at IAM gap value
                minVaultAmount:       1_000,           // debt floor - dust in DAI
                maxLiquidationAmount: 1_000_000,
                liquidationPenalty:   13_00,             // 13% penalty on liquidation
                ilkStabilityFee:      FIFTY_PCT_RATE,   // 50% stability fee
                startingPriceFactor:  110_00,            // Auction price begins at 110% of oracle price
                breakerTolerance:     40_00,             // Allows for a 40% hourly price drop before disabling liquidation
                auctionDuration:      7200,
                permittedDrop:        45_00,             // 45% price drop before reset
                liquidationRatio:     200_00,            // 200% collateralization
                kprFlatReward:        50,               // 50 DAI tip - flat fee per kpr
                kprPctReward:         10                 // 0.1% chip - per kpr
            })
        );

        DssExecLib.setStairstepExponentialDecrease(MCD_CLIP_CALC_STFX_A, 90 seconds, 99_00);
//        DssExecLib.setIlkAutoLineParameters("STFX-A", 15_000_000, 3_000_000, 4 hours);  // disable STFX-A auto line

        // -------------------- Changelog Update ---------------------
        DssExecLib.setChangelogAddress("STFX",                 STFX);
        DssExecLib.setChangelogAddress("PIP_STFX",             PIP_STFX);
        DssExecLib.setChangelogAddress("MCD_JOIN_STFX_A",      MCD_JOIN_STFX_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_STFX_A",      MCD_CLIP_STFX_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_STFX_A", MCD_CLIP_CALC_STFX_A);

        DssExecLib.setChangelogVersion("0.0.2");
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
