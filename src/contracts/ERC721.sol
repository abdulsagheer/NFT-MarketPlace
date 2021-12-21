// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256; 
    using Counters for Counters.Counter;

    
    // mapping from token id to the onwer
    mapping(uint256 => address) private _tokenOwner;
    
    // mapping from owner to number of owned tokens
    mapping(address => Counters.Counter) private _OwnedTokensCount;
    
    // Mapping from token id to approved addresses.
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)') ^ keccak256('ownerOf(bytes4)') ^ keccak256('transferFrom(bytes4)')));
    }
    
    function balanceOf(address _owner) public override view returns(uint256) {
            require(_owner != address(0), 'owner query for non-existent token');
            return _OwnedTokensCount[_owner].current();
    }    
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        // setting the address of nft owner to check the mapping of the addreess from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return truthiness tha address is not zero
        return owner != address(0);
    }


    function _mint(address to, uint tokenId) internal virtual {
        // requires that the address i9snt zero.
        require(to != address(0), "ERC721 minting to the zero address.");
        // requires that the token does not already exist.
        require(!_exists(tokenId), "token already minted!");
        // we are adding a new addresss with a token id for minting
        _tokenOwner[tokenId] = to; 
        // keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to].increment(); 

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), "Error - REC721 Transfer to the zero address");
        require(ownerOf(_tokenId) == _from, "Trying to transfer a token the address does");

        _OwnedTokensCount[_from].decrement();
        _OwnedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to,uint256 _tokenId) override  public {
        require(isApproveOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    // require that the person approving is the owner.
    // we are approving an address to a token (tokenId).
    // require that we cant approve sending tokens of the owner to the owner (current caller).
    // update the map of the approval addresses.
    function approve(address _to, uint256 tokenId) public { 
        address owner = ownerOf(tokenId);
        require(_to != owner, "Error - approval to the current owner");
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function isApproveOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token doesnt exist');
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
 }