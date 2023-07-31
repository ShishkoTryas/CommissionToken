const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("MyERC20", function () {
  let MyERC20, myERC20, owner, addr1, addr2, addr3, addrs;

  beforeEach(async function () {
    MyERC20 = await ethers.getContractFactory("myERC20");
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();
    myERC20 = await MyERC20.deploy("MyToken", "MTK", 18, owner.address);
    await myERC20.deployed();
  });

  it("Should return the right name", async function () {
    expect(await myERC20.name()).to.equal("MyToken");
  });

  it("Should transfer the right amount", async function () {
    await myERC20.transfer(addr1.address, 1000);
    expect(await myERC20.balanceOf(addr1.address)).to.equal(960); // 1000 - 4% commission = 960
  });

  it("Should transfer the right amount from another account", async function () {
    await myERC20.approve(owner.address, 1000);
    await myERC20.transferFrom(owner.address, addr1.address, 1000);
    expect(await myERC20.balanceOf(addr1.address)).to.equal(960); // 1000 - 4% commission = 960
  });

});
