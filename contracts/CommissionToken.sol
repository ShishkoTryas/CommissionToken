// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract myERC20 is ReentrancyGuard {

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    string public name;
    string public symbol;
    uint8 public immutable decimals;
    address public owner;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address payable private projectWallet;
    mapping(address => uint256) public rewards;
    mapping(address => bool) public isHolder;
    mapping(address => uint256) private holderIndex;
    address[] private holdersList;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, address payable projectWalletAddress) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _mint(msg.sender, 10000000 * 10 * _decimals);
        projectWallet = projectWalletAddress;
        _addHolder(msg.sender);
    }

    function approve(address spender, uint256 amount) public returns(bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount) public returns(bool) {
        _beforeTokenTransfer(msg.sender, to, amount);

        uint commission = amount * 4 / 100;
        uint projectShare = (commission * 75) / 100;

        balanceOf[msg.sender] -= amount;

    unchecked {
        balanceOf[projectWallet] += projectShare;
        balanceOf[to] += (amount - commission);
    }

        _afterTokenTransfer(msg.sender, to, amount);

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool) {
        _beforeTokenTransfer(msg.sender, to, amount);
        uint256 allowed = allowance[from][msg.sender];

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        uint commission = amount * 4 / 100;
        uint projectShare = (commission * 75) / 100;

        balanceOf[msg.sender] -= amount;

    unchecked {
        balanceOf[projectWallet] += projectShare;
        balanceOf[to] += (amount - commission);
    }

        _afterTokenTransfer(msg.sender, to, amount);

        emit Transfer(from, to, amount);

        return true;
    }

    function _mint(address to, uint256 amount) internal {
        totalSupply += amount;

    unchecked {
        balanceOf[to] += amount;
    }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;

    unchecked {
        totalSupply -= amount;
    }

        emit Transfer(from, address(0), amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        if(from != address(0)) {
            uint256 balance = balanceOf[from];
            if(balance == amount) {
                _removeHolder(from);
            }
        }

        if(to != address(0)) {
            _addHolder(to);
        }
    }

    function _addHolder(address holder) private {
        if(!isHolder[holder]) {
            holdersList.push(holder);
            isHolder[holder] = true;
            holderIndex[holder] = holdersList.length - 1;
        }
    }

    function _removeHolder(address holder) private {
        if(isHolder[holder] && holderIndex[holder] < holdersList.length) {
            isHolder[holder] = false;
            uint256 holderInd = holderIndex[holder];
            if(holderInd < holdersList.length - 1){
                address lastHolder = holdersList[holdersList.length - 1];
                holdersList[holderInd] = lastHolder;
                holderIndex[lastHolder] = holderInd;
            }
            holdersList.pop();
        }
    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal {
        if(from == address(0) || to == address(0)) return;

        uint commission = amount * 4 / 100;
        uint projectShare = (commission * 75) / 100;
        uint holdersShare = commission - projectShare;

        for(uint i=0; i < holdersList.length; i++){
            address holder = holdersList[i];
            uint256 holderBalance = balanceOf[holder];
            uint256 reward = (holderBalance * holdersShare) / totalSupply;
            rewards[holder] = rewards[holder] + reward;
        }
    }

    function withdrawReward() public nonReentrant {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
}