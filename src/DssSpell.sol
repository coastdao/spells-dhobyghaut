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

interface OsmLike {
    function step(uint16 ts) external;
}

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/coastdao/community/xxx.md -q -O - 2>/dev/null)"
    string public constant override description =
    "2023-07-21 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    // --- DEPLOYED COLLATERAL ADDRESSES ---
    address internal constant PIP_WETH = 0x3bfB1D2F51a6c569dA24B90EdD5285B2FfCb1276;
    address internal constant PIP_STFX = 0x1EFf47a1Ad1821a095B56A8613B4e76471cAA744;

    function actions() public override {
        OsmLike pip_weth = OsmLike(PIP_WETH);
        // WETH delay from 1 hour to 10 minutes
        pip_weth.step(600);
        OsmLike pip_stfx = OsmLike(PIP_STFX);
        // STFX delay from 1 hour to 10 minutes
        pip_stfx.step(600);
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
