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

interface VatLike {
    function Line() external view returns (uint256);
    function file(bytes32, uint256) external;
    function ilks(bytes32) external returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust);
}

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/coastdao/community/xxx.md -q -O - 2>/dev/null)"
    string public constant override description =
    "2023-05-19 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.5)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmVp4mhhbwWGTfbh2BzwQB9eiBrQBKiqcPRZCaAxNUaar6
    //
    // uint256 internal constant X_PCT_RATE      = ;

    uint256 constant ONE_FIVE_PCT_RATE = 1000000000472114805215157978;

    // --- DEPLOYED COLLATERAL ADDRESSES ---
    address internal constant WETH                     = 0xA2A4B12EF81E7A26C5a1E0be9340b1972F85E44A;
    address internal constant PIP_WETH                 = 0x3bfB1D2F51a6c569dA24B90EdD5285B2FfCb1276;
    address internal constant MCD_JOIN_WETH_A          = 0xf175216aBA79C24ffAb2ACB4526D9d3115EC376F;
    address internal constant MCD_CLIP_WETH_A          = 0xE25a1c47bFC8fD521C2EBb93179d021f124Fe4FC;
    address internal constant MCD_CLIP_CALC_WETH_A     = 0x908Fa84c747ffA82967cEC1e699BBE6A8CE73678;

    function actions() public override {

        // Reduce ETH-A Debt Ceilings to 0
        uint256 line;
        uint256 lineReduction;
        VatLike vat = VatLike(DssExecLib.vat());

        (,,,line,) = vat.ilks("ETH-A");
        lineReduction += line;
        DssExecLib.removeIlkFromAutoLine("ETH-A");
        DssExecLib.setIlkDebtCeiling("ETH-A", 0);

        // Decrease Global Debt Ceiling in accordance with Offboarded Ilks
        vat.file("Line", vat.Line() - lineReduction);
        // ----------------------------- Collateral onboarding -----------------------------
        //  Add WETH-A as a new Vault Type

        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk:                  "WETH-A",
                gem:                  WETH,
                join:                 MCD_JOIN_WETH_A,
                clip:                 MCD_CLIP_WETH_A,
                calc:                 MCD_CLIP_CALC_WETH_A,
                pip:                  PIP_WETH,
                isLiquidatable:       true,
                isOSM:                true,
                whitelistOSM:         true,
                ilkDebtCeiling:       10_000_000,         // line starts at IAM gap value
                minVaultAmount:       3_000,           // debt floor - dust in DAI
                maxLiquidationAmount: 1_000_000,
                liquidationPenalty:   13_00,             // 13% penalty on liquidation
                ilkStabilityFee:      ONE_FIVE_PCT_RATE, // 1.50% stability fee
                startingPriceFactor:  110_00,            // Auction price begins at 110% of oracle price
                breakerTolerance:     40_00,             // Allows for a 40% hourly price drop before disabling liquidation
                auctionDuration:      7200,
                permittedDrop:        45_00,             // 45% price drop before reset
                liquidationRatio:     150_00,            // 150% collateralization
                kprFlatReward:        50,               // 50 DAI tip - flat fee per kpr
                kprPctReward:         10                 // 0.1% chip - per kpr
            })
        );

        DssExecLib.setStairstepExponentialDecrease(MCD_CLIP_CALC_WETH_A, 90 seconds, 99_00);
//        DssExecLib.setIlkAutoLineParameters("WETH-A", 15_000_000, 3_000_000, 4 hours);  // disable WETH-A auto line

        // -------------------- Changelog Update ---------------------
        DssExecLib.setChangelogAddress("WETH",                 WETH);
        DssExecLib.setChangelogAddress("PIP_WETH",             PIP_WETH);
        DssExecLib.setChangelogAddress("MCD_JOIN_WETH_A",      MCD_JOIN_WETH_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_WETH_A",      MCD_CLIP_WETH_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_WETH_A", MCD_CLIP_CALC_WETH_A);
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
