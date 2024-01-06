pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Smart contract that allows users to mint non-fungible tokens (NFTs) with metadata stored on IPFS and keep track of the ownership of these tokens.

contract MyNFT is ERC721 {
    using SafeMath for uint256;

    mapping(uint256 => address) private _tokenOwner;
    mapping(uint256 => string) private _tokenIPFSHash;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    function mint(address to, uint256 tokenId, string memory ipfsHash) public {
        require(msg.sender != address(0));
        _mint(to, tokenId);
        _setTokenIPFSHash(tokenId, ipfsHash);
    }

    function ownerOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        return _tokenOwner[tokenId];
    }

    function tokenIPFSHash(
        uint256 tokenId
    ) public view returns (string memory) {
        return _tokenIPFSHash[tokenId];
    }

    function _setTokenIPFSHash(
        uint256 tokenId,
        string memory ipfsHash
    ) internal {
        _tokenIPFSHash[tokenId] = ipfsHash;
    }
}

