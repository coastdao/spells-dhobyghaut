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
    "2023-08-02 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(2.0)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmVp4mhhbwWGTfbh2BzwQB9eiBrQBKiqcPRZCaAxNUaar6
    //
    // uint256 internal constant X_PCT_RATE      = ;

    // --- DEPLOYED COLLATERAL ADDRESSES ---
    address internal constant ATOMOSMOLP = 0xc76A204AEA61a68a3B1f97B8E70286CD42B020D2;
    address internal constant PIP_ATOMOSMOLP = 0xB4f4d1c1Ce97B83897fEdF46bfaca1e0B7cD85df;
    address internal constant MCD_JOIN_ATOMOSMOLP_A = 0xe7F8596cD939fC2f330D96fCAa58a94BdA067200;
    address internal constant MCD_CLIP_ATOMOSMOLP_A = 0xBA1C651C585c55A1Dc8d4D1CeBBB2487bD73846F;
    address internal constant MCD_CLIP_CALC_ATOMOSMOLP_A = 0xE385198f178d7D63BeFcb72956cd932723B2b436;

    function actions() public override {
        // ----------------------------- Max Liquidation Amount -----------------------------
        // Set the ilk max liquidation amount (hole value)
        DssExecLib.setIlkMaxLiquidationAmount("WETH-A", 10_000_000);
        DssExecLib.setIlkMaxLiquidationAmount("STFX-A", 10_000_000);

        // ----------------------------- Collateral onboarding -----------------------------
        //  Add ATOMOSMOLP-A as a new Vault Type

        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk: "ATOMOSMOLP-A",
                gem: ATOMOSMOLP,
                join: MCD_JOIN_ATOMOSMOLP_A,
                clip: MCD_CLIP_ATOMOSMOLP_A,
                calc: MCD_CLIP_CALC_ATOMOSMOLP_A,
                pip: PIP_ATOMOSMOLP,
                isLiquidatable: true,
                isOSM: true,
                whitelistOSM: true,
                ilkDebtCeiling: 10_000_000,         // line starts at IAM gap value
                minVaultAmount: 1_00,           // debt floor - dust in DAI
                maxLiquidationAmount: 10_000_000,
                liquidationPenalty: 13_00,             // 13% penalty on liquidation
                ilkStabilityFee: DssExecLib.RATES_ONE_HUNDRED_PCT, // 100% stability fee
                startingPriceFactor: 110_00,            // Auction price begins at 110% of oracle price
                breakerTolerance: 40_00,             // Allows for a 40% hourly price drop before disabling liquidation
                auctionDuration: 7200,
                permittedDrop: 45_00,             // 45% price drop before reset
                liquidationRatio: 200_00,            // 200% collateralization
                kprFlatReward: 50,               // 50 DAI tip - flat fee per kpr
                kprPctReward: 10                 // 0.1% chip - per kpr
            })
        );

        DssExecLib.setStairstepExponentialDecrease(MCD_CLIP_CALC_ATOMOSMOLP_A, 90 seconds, 99_00);
//        DssExecLib.setIlkAutoLineParameters("ATOMOSMOLP-A", 15_000_000, 3_000_000, 4 hours);  // disable ATOMOSMOLP-A auto line

        // -------------------- Changelog Update ---------------------
        DssExecLib.setChangelogAddress("ATOMOSMOLP", ATOMOSMOLP);
        DssExecLib.setChangelogAddress("PIP_ATOMOSMOLP", PIP_ATOMOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_ATOMOSMOLP_A", MCD_JOIN_ATOMOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_ATOMOSMOLP_A", MCD_CLIP_ATOMOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_ATOMOSMOLP_A", MCD_CLIP_CALC_ATOMOSMOLP_A);

        DssExecLib.setChangelogVersion("0.0.3");
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
