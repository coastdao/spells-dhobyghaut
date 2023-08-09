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

interface OSMLike {
    function change(address src_) external;
}

contract DssSpellAction is DssAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/coastdao/community/xxx.md -q -O - 2>/dev/null)"
    string public constant override description =
    "2023-08-09 CoastDAO Executive Spell | Hash: ";

    // Turn office hours off
    function officeHours() public pure override returns (bool) {
        return false;
    }

    address internal constant PIP_ATOMOSMOLP = 0xB4f4d1c1Ce97B83897fEdF46bfaca1e0B7cD85df;
    address internal constant VAL_ATOMOSMOLP = 0x59C0C2E987835a0eCC33888DF841B27A3B981297;

    function actions() public override {
        OSMLike(PIP_ATOMOSMOLP).change(VAL_ATOMOSMOLP);
    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) {}
}
