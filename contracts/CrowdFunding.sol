// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Crowdfunding {
    // Define the structure of a campaign
    struct Campaign {
        string title; // Title of the campaign
        string description; // Description of the campaign
        address payable benefactor; // Address of the campaign's benefactor
        uint goal; // Fundraising goal (in wei)
        uint deadline; // Deadline for the campaign (Unix timestamp)
        uint amountRaised; // Total amount raised so far
        bool ended; // Indicates if the campaign has ended
        mapping(address => uint) donations; // Track donations from each address
    }

    address public owner; // Address of the contract owner
    uint public campaignCount; // Total number of campaigns
    mapping(uint => Campaign) public campaigns; // Mapping of campaign ID to Campaign

    // Events to log important actions
    event CampaignCreated(uint campaignId, string title, string description, address benefactor, uint goal, uint deadline);
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId, uint amountRaised, address benefactor);
    event RefundIssued(uint campaignId, address donor, uint amount);

    // Modifier to restrict function access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Modifier to check if the campaign exists
    modifier campaignExists(uint campaignId) {
        require(campaignId < campaignCount, "Campaign does not exist");
        _;
    }

    // Modifier to check if the campaign is still active (hasn't ended yet)
    modifier campaignActive(uint campaignId) {
        require(now < campaigns[campaignId].deadline, "Campaign has ended");
        _;
    }

    // Modifier to check if the campaign has ended
    modifier campaignEnded(uint campaignId) {
        require(now >= campaigns[campaignId].deadline, "Campaign has not ended yet");
        require(!campaigns[campaignId].ended, "Campaign already ended");
        _;
    }

    // Constructor to set the initial owner of the contract
    constructor() public {
        owner = msg.sender;
    }

    // Function to create a new campaign
    function createCampaign(
        string memory _title,
        string memory _description,
        address payable _benefactor,
        uint _goal,
        uint _duration
    ) public {
        require(_goal > 0, "Goal must be greater than zero"); // Ensure goal is greater than zero
        require(_benefactor != address(0), "Benefactor address cannot be zero"); // Ensure benefactor address is valid

        uint campaignId = campaignCount++; // Increment campaign count and use as campaign ID
        Campaign storage campaign = campaigns[campaignId];
        campaign.title = _title;
        campaign.description = _description;
        campaign.benefactor = _benefactor;
        campaign.goal = _goal;
        campaign.deadline = now + _duration; // Set deadline based on duration
        campaign.amountRaised = 0;
        campaign.ended = false;

        emit CampaignCreated(campaignId, _title, _description, _benefactor, _goal, campaign.deadline); // Emit event
    }

    // Function to donate to a campaign
    function donateToCampaign(uint campaignId) public payable campaignExists(campaignId) campaignActive(campaignId) {
        require(msg.value > 0, "Donation must be greater than zero"); // Ensure donation is positive

        Campaign storage campaign = campaigns[campaignId];
        campaign.donations[msg.sender] += msg.value; // Track donation from sender
        campaign.amountRaised += msg.value; // Update total amount raised

        emit DonationReceived(campaignId, msg.sender, msg.value); // Emit event
    }

    // Function to end a campaign and transfer funds to the benefactor
    function endCampaign(uint campaignId) public campaignExists(campaignId) campaignEnded(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        campaign.ended = true;

        uint amountToTransfer = campaign.amountRaised; // Amount to transfer to the benefactor
        if (amountToTransfer > 0) {
            campaign.benefactor.transfer(amountToTransfer); // Transfer funds to the benefactor
        }

        emit CampaignEnded(campaignId, amountToTransfer, campaign.benefactor); // Emit event
    }

    // Function for users to claim refunds if the campaign did not meet its goal
    function claimRefund(uint campaignId) public campaignExists(campaignId) campaignEnded(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(campaign.amountRaised < campaign.goal, "Campaign goal met, no refunds"); // Check if the goal was met

        uint donationAmount = campaign.donations[msg.sender]; // Get the amount donated by the sender
        require(donationAmount > 0, "No donations to refund"); // Ensure the sender has made a donation

        campaign.donations[msg.sender] = 0; // Reset donation amount
        msg.sender.transfer(donationAmount); // Refund the donation

        emit RefundIssued(campaignId, msg.sender, donationAmount); // Emit event
    }

    // Function for the owner to withdraw leftover funds from the contract
    function withdrawLeftoverFunds() public onlyOwner {
        uint balance = address(this).balance; // Get the contract's balance
        require(balance > 0, "No funds available for withdrawal"); // Ensure there are funds to withdraw
        msg.sender.transfer(balance); // Transfer funds to the owner
    }

    // Fallback function to prevent accidental ETH transfers
    function() external payable {
        revert("Direct ether transfers are not allowed");
    }
}
