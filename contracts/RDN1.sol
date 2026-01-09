// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing standard OpenZeppelin contracts
// In Remix, these imports work automatically
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RandomNameToken is ERC20 {
    // Arrays of words for name generation (can be customized)
    string[] private adjectives = ["Super", "Mega", "Hyper", "Cyber", "Ultra", "Quantum", "Rapid", "Golden"];
    string[] private nouns = ["Token", "Coin", "Moon", "Chain", "Base", "Node", "Gem", "Protocol"];

    // Constructor calls generation function BEFORE ERC20 initialization
    constructor() ERC20(_generateRandomName(), _generateRandomSymbol()) {
        // Mints 1 million tokens to the deployer
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    // Internal function to generate a random name
    function _generateRandomName() private view returns (string memory) {
        uint256 rand = _getPsuedoRandomNumber();
        
        // Pick a random adjective and noun
        string memory adj = adjectives[rand % adjectives.length];
        string memory noun = nouns[(rand / 10) % nouns.length]; // Shift to ensure words are independent
        
        // Concatenate strings (works in Solidity 0.8.12+)
        return string.concat(adj, " ", noun);
    }

    // Internal function to generate a random symbol (ticker)
    function _generateRandomSymbol() private view returns (string memory) {
        uint256 rand = _getPsuedoRandomNumber();
        
        // Generate ticker from a prefix and random numbers
        // Example: RND + 3 random digits
        return string.concat("RND", Strings.toString(rand % 999));
    }

    // Pseudo-random number generator
    function _getPsuedoRandomNumber() private view returns (uint256) {
        // Uses timestamp, prevrandao, and msg.sender for randomness
        return uint256(keccak256(abi.encodePacked(
            block.timestamp, 
            block.prevrandao, 
            msg.sender
        )));
    }
}
