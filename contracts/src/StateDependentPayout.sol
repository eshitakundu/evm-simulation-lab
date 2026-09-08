// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @notice Educational fake-credit ledger. No ETH, tokens, or external calls.
/// @dev A preview reads current state; it does not reserve a future recipient.
contract StateDependentPayout {
    error Unauthorized();
    error ZeroAddress();
    error InvalidAmount();

    address public immutable controller;
    address public immutable operator;
    address public recipient;
    uint256 public remainingCredits;
    mapping(address => uint256) public credits;

    event RecipientChanged(address indexed previousRecipient, address indexed nextRecipient);
    event PayoutRecorded(address indexed caller, address indexed recipient, uint256 amount);

    constructor(address controller_, address operator_, address recipient_, uint256 initialCredits) {
        if (controller_ == address(0) || operator_ == address(0) || recipient_ == address(0)) {
            revert ZeroAddress();
        }
        controller = controller_;
        operator = operator_;
        recipient = recipient_;
        remainingCredits = initialCredits;
    }

    function previewRecipient() external view returns (address) {
        return recipient;
    }

    function setRecipient(address nextRecipient) external {
        if (msg.sender != controller) revert Unauthorized();
        if (nextRecipient == address(0)) revert ZeroAddress();
        emit RecipientChanged(recipient, nextRecipient);
        recipient = nextRecipient;
    }

    function payout(uint256 amount) external returns (address actualRecipient) {
        if (msg.sender != operator) revert Unauthorized();
        if (amount == 0 || amount > remainingCredits) revert InvalidAmount();
        actualRecipient = recipient;
        remainingCredits -= amount;
        credits[actualRecipient] += amount;
        emit PayoutRecorded(msg.sender, actualRecipient, amount);
    }
}
