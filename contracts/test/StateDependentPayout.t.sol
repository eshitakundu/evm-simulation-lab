// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {StateDependentPayout} from "../src/StateDependentPayout.sol";

// Minimal Foundry cheatcode interface; no external test dependency is needed.
interface Vm {
    function prank(address caller) external;
    function expectRevert(bytes4 selector) external;
    function expectEmit(bool topic1, bool topic2, bool topic3, bool data, address emitter) external;
}

contract StateDependentPayoutTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONTROLLER = address(0xA11CE);
    address private constant OPERATOR = address(0xB0B);
    address private constant FIRST = address(0x1001);
    address private constant SECOND = address(0x1002);
    StateDependentPayout private ledger;

    event RecipientChanged(address indexed previousRecipient, address indexed nextRecipient);
    event PayoutRecorded(address indexed caller, address indexed recipient, uint256 amount);
    event ExpectationCompared(address indexed expectedRecipient, address indexed actualRecipient, uint256 amount);

    function setUp() public {
        ledger = new StateDependentPayout(CONTROLLER, OPERATOR, FIRST, 100);
    }

    function test_DeploymentRecordsRolesRecipientAndFakeBudget() public view {
        require(ledger.controller() == CONTROLLER, "controller");
        require(ledger.operator() == OPERATOR, "operator");
        require(ledger.previewRecipient() == FIRST, "recipient");
        require(ledger.remainingCredits() == 100, "budget");
    }

    function test_StateChangeMakesSameIntendedActionCreditDifferentRecipient() public {
        bytes memory intendedAction = abi.encodeCall(StateDependentPayout.payout, (25));
        address expected = ledger.previewRecipient();
        require(expected == FIRST, "initial expectation");

        vm.expectEmit(true, true, false, true, address(ledger));
        emit RecipientChanged(FIRST, SECOND);
        vm.prank(CONTROLLER);
        ledger.setRecipient(SECOND);

        vm.expectEmit(true, true, false, true, address(ledger));
        emit PayoutRecorded(OPERATOR, SECOND, 25);
        vm.prank(OPERATOR);
        (bool success, bytes memory result) = address(ledger).call(intendedAction);
        require(success, "intended action failed");
        address actual = abi.decode(result, (address));
        require(actual == SECOND && actual != expected, "recipient must differ");
        require(ledger.credits(expected) == 0, "expected recipient uncredited");
        require(ledger.credits(actual) == 25, "actual recipient credited");
        require(ledger.remainingCredits() == 75, "budget conserved");
        emit ExpectationCompared(expected, actual, 25);
    }

    function test_UnchangedStateMatchesEarlierExpectation() public {
        address expected = ledger.previewRecipient();
        vm.prank(OPERATOR);
        require(ledger.payout(25) == expected, "stable recipient");
        require(ledger.credits(expected) == 25, "stable credit");
    }

    function testFuzz_OnlyControllerCanChangeRecipient(address caller) public {
        if (caller == CONTROLLER) return;
        vm.expectRevert(StateDependentPayout.Unauthorized.selector);
        vm.prank(caller);
        ledger.setRecipient(SECOND);
        require(ledger.recipient() == FIRST, "unauthorized mutation");
    }

    function testFuzz_OnlyOperatorCanRecordPayout(address caller) public {
        if (caller == OPERATOR) return;
        vm.expectRevert(StateDependentPayout.Unauthorized.selector);
        vm.prank(caller);
        ledger.payout(25);
        require(ledger.remainingCredits() == 100 && ledger.credits(FIRST) == 0, "unauthorized credit");
    }

    function test_ControllerCannotPayoutAndOperatorCannotChangeRecipient() public {
        vm.expectRevert(StateDependentPayout.Unauthorized.selector);
        vm.prank(CONTROLLER);
        ledger.payout(25);
        vm.expectRevert(StateDependentPayout.Unauthorized.selector);
        vm.prank(OPERATOR);
        ledger.setRecipient(SECOND);
    }

    function test_ControllerCannotSetZeroRecipient() public {
        vm.expectRevert(StateDependentPayout.ZeroAddress.selector);
        vm.prank(CONTROLLER);
        ledger.setRecipient(address(0));
        require(ledger.recipient() == FIRST, "recipient unchanged");
    }

    function test_ConstructorRejectsEachZeroAddress() public {
        vm.expectRevert(StateDependentPayout.ZeroAddress.selector);
        new StateDependentPayout(address(0), OPERATOR, FIRST, 100);
        vm.expectRevert(StateDependentPayout.ZeroAddress.selector);
        new StateDependentPayout(CONTROLLER, address(0), FIRST, 100);
        vm.expectRevert(StateDependentPayout.ZeroAddress.selector);
        new StateDependentPayout(CONTROLLER, OPERATOR, address(0), 100);
    }

    function test_ZeroAndOverBudgetAmountsRevertWithoutChangingCredits() public {
        vm.expectRevert(StateDependentPayout.InvalidAmount.selector);
        vm.prank(OPERATOR);
        ledger.payout(0);
        vm.expectRevert(StateDependentPayout.InvalidAmount.selector);
        vm.prank(OPERATOR);
        ledger.payout(101);
        require(ledger.remainingCredits() == 100 && ledger.credits(FIRST) == 0, "budget unchanged");
    }

    function test_ExactBudgetCanBeConsumedOnlyOnce() public {
        vm.prank(OPERATOR);
        ledger.payout(100);
        require(ledger.remainingCredits() == 0 && ledger.credits(FIRST) == 100, "exact budget");
        vm.expectRevert(StateDependentPayout.InvalidAmount.selector);
        vm.prank(OPERATOR);
        ledger.payout(1);
    }
}
