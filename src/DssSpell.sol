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

interface DsTokenLike {
    function setName(string memory name_) external;
}

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/coastdao/community/xxx.md -q -O - 2>/dev/null)"
    string public constant override description =
    "2023-09-07 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    address internal constant tATOMtOSMOLP = 0x4ad26064831ECE180B179a4C02Dc97940AA77B17;
    address internal constant PIP_tATOMtOSMOLP = 0x717FcD32f67DaB85C66245183Cf46d7773C91bbF;
    address internal constant MCD_JOIN_tATOMtOSMOLP_A = 0xc78Fee2130c0C1Ad55326B54AFF6ee6689D53Fca;
    address internal constant MCD_CLIP_tATOMtOSMOLP_A = 0xC2FfEe128dA8DcC7940a438dD3AF90EFA7C9028D;
    address internal constant MCD_CLIP_CALC_tATOMtOSMOLP_A = 0x411096fe499CedA2539cFE5e6f3ee45F8C25057E;

    address internal constant USDCtOSMOLP = 0x616E00909730f7dE9Afd97Dc71981f6d28e2B0ca;
    address internal constant PIP_USDCtOSMOLP = 0xc0Be0Fe229C12094e644d8c0c0e19A09426C1bD8;
    address internal constant MCD_JOIN_USDCtOSMOLP_A = 0x0A048340FE4fd0aedBDA9F48Ea7702AE9Ff56cE4;
    address internal constant MCD_CLIP_USDCtOSMOLP_A = 0x2F4a19937236fD4077838B5C4065F7B76bf14dEE;
    address internal constant MCD_CLIP_CALC_USDCtOSMOLP_A = 0x390c758Ba681937e0Eca21eFC3EDb98B125f2d65;

    address internal constant WETHtOSMOLP = 0x3181798DE239164e6FDBD22aC474Eedc61bf821e;
    address internal constant PIP_WETHtOSMOLP = 0xfA7336E6366C2fbB43B3C1bdDEf283EAf2426c85;
    address internal constant MCD_JOIN_WETHtOSMOLP_A = 0x8561732e3381514194e990afc4A0Eff8507b134b;
    address internal constant MCD_CLIP_WETHtOSMOLP_A = 0xF3693DFbCfeC531C9fEe8484698939abEbDD6E84;
    address internal constant MCD_CLIP_CALC_WETHtOSMOLP_A = 0x7DDd1138e2c44f2c51f82AA619Ca365664AFDeAe;

    address internal constant WBTCtOSMOLP = 0x94c23eE865E3c963A56263d0ce2CBF5C6cE7ce2d;
    address internal constant PIP_WBTCtOSMOLP = 0x5F70af514faD5E1B3F49a44BAae8EeFb4f1bfFDB;
    address internal constant MCD_JOIN_WBTCtOSMOLP_A = 0x179Ef750202615091E73748113eD825b15Bd2957;
    address internal constant MCD_CLIP_WBTCtOSMOLP_A = 0xEdd23Fb833c711456A861E42e91Fb5F78B88A43c;
    address internal constant MCD_CLIP_CALC_WBTCtOSMOLP_A = 0xD1Cbd0c64f604434b337197F25B42D404f7B4e31;

    address internal constant stOSMOtOSMOLP = 0x628A41754edfAFB491FEe6a1F397590B9013E01B;
    address internal constant PIP_stOSMOtOSMOLP = 0x42F6FAF077D5Ffe4A5E08EEf7739Fd405e91829b;
    address internal constant MCD_JOIN_stOSMOtOSMOLP_A = 0x17f24dF094DB967091985Ea373518D0292853F16;
    address internal constant MCD_CLIP_stOSMOtOSMOLP_A = 0xAD906794A588eA5a00E92ffe27DfCa3BeA57E58D;
    address internal constant MCD_CLIP_CALC_stOSMOtOSMOLP_A = 0x5064ccdB8dcB922c8a3735A602De2972cD67a64f;

    function actions() public override {
        // ----------------------------- Collateral onboarding -----------------------------
        //  Add tATOMtOSMOLP-A as a new Vault Type
        addCollateral("tATOMtOSMOLP-A", tATOMtOSMOLP, MCD_JOIN_tATOMtOSMOLP_A, MCD_CLIP_tATOMtOSMOLP_A, MCD_CLIP_CALC_tATOMtOSMOLP_A, PIP_tATOMtOSMOLP, 2_000_000);
        //  Add USDCtOSMOLP-A as a new Vault Type
        addCollateral("USDCtOSMOLP-A", USDCtOSMOLP, MCD_JOIN_USDCtOSMOLP_A, MCD_CLIP_USDCtOSMOLP_A, MCD_CLIP_CALC_USDCtOSMOLP_A, PIP_USDCtOSMOLP, 800_000);
        //  Add WETHtOSMOLP-A as a new Vault Type
        addCollateral("WETHtOSMOLP-A", WETHtOSMOLP, MCD_JOIN_WETHtOSMOLP_A, MCD_CLIP_WETHtOSMOLP_A, MCD_CLIP_CALC_WETHtOSMOLP_A, PIP_WETHtOSMOLP, 600_000);
        //  Add WBTCtOSMOLP-A as a new Vault Type
        addCollateral("WBTCtOSMOLP-A", WBTCtOSMOLP, MCD_JOIN_WBTCtOSMOLP_A, MCD_CLIP_WBTCtOSMOLP_A, MCD_CLIP_CALC_WBTCtOSMOLP_A, PIP_WBTCtOSMOLP, 500_000);
        //  Add stOSMOtOSMOLP-A as a new Vault Type
        addCollateral("stOSMOtOSMOLP-A", stOSMOtOSMOLP, MCD_JOIN_stOSMOtOSMOLP_A, MCD_CLIP_stOSMOtOSMOLP_A, MCD_CLIP_CALC_stOSMOtOSMOLP_A, PIP_stOSMOtOSMOLP, 300_000);

        // -------------------- Changelog Update ---------------------
        DssExecLib.setChangelogAddress("tATOMtOSMOLP", tATOMtOSMOLP);
        DssExecLib.setChangelogAddress("PIP_tATOMtOSMOLP", PIP_tATOMtOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_tATOMtOSMOLP_A", MCD_JOIN_tATOMtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_tATOMtOSMOLP_A", MCD_CLIP_tATOMtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_tATOMtOSMOLP_A", MCD_CLIP_CALC_tATOMtOSMOLP_A);

        DssExecLib.setChangelogAddress("USDCtOSMOLP", USDCtOSMOLP);
        DssExecLib.setChangelogAddress("PIP_USDCtOSMOLP", PIP_USDCtOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_USDCtOSMOLP_A", MCD_JOIN_USDCtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_USDCtOSMOLP_A", MCD_CLIP_USDCtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_USDCtOSMOLP_A", MCD_CLIP_CALC_USDCtOSMOLP_A);

        DssExecLib.setChangelogAddress("WETHtOSMOLP", WETHtOSMOLP);
        DssExecLib.setChangelogAddress("PIP_WETHtOSMOLP", PIP_WETHtOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_WETHtOSMOLP_A", MCD_JOIN_WETHtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_WETHtOSMOLP_A", MCD_CLIP_WETHtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_WETHtOSMOLP_A", MCD_CLIP_CALC_WETHtOSMOLP_A);

        DssExecLib.setChangelogAddress("WBTCtOSMOLP", WBTCtOSMOLP);
        DssExecLib.setChangelogAddress("PIP_WBTCtOSMOLP", PIP_WBTCtOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_WBTCtOSMOLP_A", MCD_JOIN_WBTCtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_WBTCtOSMOLP_A", MCD_CLIP_WBTCtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_WBTCtOSMOLP_A", MCD_CLIP_CALC_WBTCtOSMOLP_A);

        DssExecLib.setChangelogAddress("stOSMOtOSMOLP", stOSMOtOSMOLP);
        DssExecLib.setChangelogAddress("PIP_stOSMOtOSMOLP", PIP_stOSMOtOSMOLP);
        DssExecLib.setChangelogAddress("MCD_JOIN_stOSMOtOSMOLP_A", MCD_JOIN_stOSMOtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_stOSMOtOSMOLP_A", MCD_CLIP_stOSMOtOSMOLP_A);
        DssExecLib.setChangelogAddress("MCD_CLIP_CALC_stOSMOtOSMOLP_A", MCD_CLIP_CALC_stOSMOtOSMOLP_A);

        DssExecLib.setChangelogVersion("0.0.4");
    }

    function addCollateral(
        bytes32 ilk,
        address gem,
        address gem_join,
        address clip,
        address calc,
        address pip,
        uint256 line
    ) internal {
        DssExecLib.addNewCollateral(
            CollateralOpts({
                ilk: ilk,
                gem: gem,
                join: gem_join,
                clip: clip,
                calc: calc,
                pip: pip,
                isLiquidatable: true,
                isOSM: true,
                whitelistOSM: true,
                ilkDebtCeiling: line,         // line starts at IAM gap value
                minVaultAmount: 1_0,           // debt floor - dust in DAI
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
        DssExecLib.setStairstepExponentialDecrease(calc, 90 seconds, 99_00);
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
