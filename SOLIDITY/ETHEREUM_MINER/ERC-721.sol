//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


event Transfer(address from, address to, uint256 tokenId);
event Approval(address owner, address spender, uint256 tokenId);
event ApprovalForAll(address owner, address operator, bool approved);

contract Ethereum_EIP721 {

     struct Token {
          address owner;
          uint256 id;
          string uri;
     }


     uint256 private _totalSupply;
     mapping(address => uint256) private _balances;
     mapping(uint256 => Token) private _tokens;
     mapping(uint256 => address) private _tokenApprovals;
     mapping(address => mapping(address => bool)) private _operatorApprovals;

     function balanceOf(address account) public view returns (uint256) {
          return _balances[account];
     }

     function ownerOf(uint256 tokenId) public view returns (address) {
          return _tokens[tokenId].owner;
     }

     function safeTransferFrom(address from, address to, uint256 tokenId) public {
          require(_tokens[tokenId].owner == from, "ERC721: transfer of token that is not own");
          require(from == msg.sender || getApproved(tokenId) == msg.sender || isApprovedForAll(from, msg.sender), "ERC721: transfer caller is not owner nor approved");
          _tokens[tokenId].owner = to;
          emit Transfer(from, to, tokenId);
     }    

     function transferFrom(address from, address to, uint256 tokenId) public {
          require(_tokens[tokenId].owner == from, "ERC721: transfer of token that is not own");
          require(from == msg.sender || getApproved(tokenId) == msg.sender || isApprovedForAll(from, msg.sender), "ERC721: transfer caller is not owner nor approved");
          _tokens[tokenId].owner = to;
          emit Transfer(from, to, tokenId);
     }

     function approve(address spender, uint256 tokenId) public {
          address owner = ownerOf(tokenId);
          require(spender != owner, "ERC721: approval to current owner");
          require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");
          _approve(spender, tokenId);
     }

     function getApproved(uint256 tokenId) public view returns (address) {
          return _tokens[tokenId].owner;
     }

     function setApprovalForAll(address operator, bool approved) public {
          require(operator != msg.sender, "ERC721: approve to caller");
          _approveForAll(operator, approved);
     }

     function isApprovedForAll(address owner, address operator) public view returns (bool) {
          return _operatorApprovals[owner][operator];
     }

     function _approve(address to, uint256 tokenId) internal {
          _tokens[tokenId].owner = to;
          emit Approval(ownerOf(tokenId), to, tokenId);
     }

     function _approveForAll(address operator, bool approved) internal {
          _operatorApprovals[msg.sender][operator] = approved;
          emit ApprovalForAll(msg.sender, operator, approved);
     }
}