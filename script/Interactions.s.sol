import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract Fund is Script {
    uint256 private constant FUND_AMOUNT = 0.001 ether;

    function fund(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: FUND_AMOUNT}();
        vm.stopBroadcast();
        console.log("Funded");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fund(mostRecentlyDeployed);
    }
}

contract Withdraw is Script {
    function withdraw(address mostRecentlyDeployed) public {
        FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
        vm.startPrank(fundMe.owner());
        vm.startBroadcast();
        fundMe.withdraw();
        vm.stopBroadcast();
        console.log("Withdrew");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdraw(mostRecentlyDeployed);
    }
}
