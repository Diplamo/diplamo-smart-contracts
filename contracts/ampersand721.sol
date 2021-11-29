// contracts/ampersand721.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ampersand721 is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    AccessControl
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) private ampersandURI;
    // Create a new role identifiers
    bytes32 public constant CREATORS_MANAGER_ROLE =
        keccak256("CREATORS_MANAGER_ROLE");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");

    constructor() ERC721("Ampersand NFT", "ANFT") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(CREATORS_MANAGER_ROLE, _msgSender());
        _setupRole(CREATOR_ROLE, _msgSender());
        // All accounts with "CREATORS_MANAGER_ROLE" will be able to manage "CREATOR_ROLE"
        // "DEFAULT_ADMIN_ROLE" is no more RoleAdmin for "CREATOR_ROLE"
        _setRoleAdmin(CREATOR_ROLE, CREATORS_MANAGER_ROLE);
        // To erase ContractOwner from "CREATOR_ROLE" and "CREATORS_MANAGER_ROLE"
    }

    // ampersandURI will contain:
    // _tokenURIs
    // metadata related to the digital content (course)
    // = name of the creator, title of the course or its product reference,IP of the creator, date when the creator created it on diplamo

    // Only creator can mint ampersand tokens
    function createAmpersand(address reciever, string memory _ampersandURI)
        public
        onlyRole(CREATOR_ROLE)
        returns (uint256)
    {
        uint256 newTokenId = _tokenIds.current();
        _tokenIds.increment();
        _safeMint(reciever, newTokenId);
        _setTokenURI(newTokenId, _ampersandURI);
        return newTokenId;
    }

    // Only creator can transfer ampersand tokens
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override onlyRole(CREATOR_ROLE) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override onlyRole(CREATOR_ROLE) {
        super.safeTransferFrom(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
        if (bytes(ampersandURI[tokenId]).length != 0) {
            delete ampersandURI[tokenId];
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
