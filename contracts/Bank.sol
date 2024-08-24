// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Bank {
    struct Account {
        address owner;
        uint balance;
    }

    mapping(address => Account) public accounts;

    // Create a new account
    function createAccount() public {
        require(accounts[msg.sender].owner == address(0), "Account already exists");
        accounts[msg.sender] = Account({owner: msg.sender, balance: 0});
    }

    // Deposit funds into an account
    function deposit() public payable {
        require(accounts[msg.sender].owner != address(0), "Account does not exist");
        accounts[msg.sender].balance += msg.value;
    }

    // Transfer funds to another account
    function transfer(address to, uint amount) public {
        require(accounts[msg.sender].balance >= amount, "Insufficient funds");
        require(accounts[to].owner != address(0), "Recipient account does not exist");
        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;
    }

    // Withdraw funds from an account
    function withdraw(uint amount) public {
        require(accounts[msg.sender].balance >= amount, "Insufficient funds");
        accounts[msg.sender].balance -= amount;
        msg.sender.transfer(amount);
    }

    // Check the balance of an account
    function getBalance() public view returns (uint) {
        return accounts[msg.sender].balance;
    }
}
