const ICO = artifacts.require("Crowdsale.sol");

contract("ICO contract", accounts => {
  it("Contract is deployed", async () => {
    const ICOInstance = await ICO.deployed();
    assert.notEqual(ICOInstance.address, "");
  });

  it("Call transfer on contract", async () => {
    const ICOInstance = await ICO.deployed();
    const beneficiary = accounts[1];
    const owner = accounts[0];
    const amount = "100" + "0".repeat(18);
    const bonus = "20" + "0".repeat(18);

    const result = await ICOInstance.transfer(
      beneficiary,
      amount * 7,
      bonus * 7,
      { from: accounts[0] }
    );

    assert.equal(result.logs[0].args.beneficiary, beneficiary);
    assert.equal(result.logs[0].args.tokenAmount.toNumber(), amount * 7);
    assert.equal(result.logs[0].args.bonusAmount.toNumber(), bonus * 7);
  });

  it("Get all the fired evennts", async () => {
    const ICOInstance = await ICO.deployed();

    const beneficiary = accounts[2];
    const beneficiary1 = accounts[3];
    const beneficiary2 = accounts[4];
    const beneficiary3 = accounts[5];

    const owner = accounts[0];
    const amount = "100" + "0".repeat(18);
    const bonus = "20" + "0".repeat(18);

    const data = [];

    let count = 0;

    const event = ICOInstance.Tranferred({ fromBlock: 0 });
    return new Promise(async (resolve, reject) => {
      event.watch((err, event) => {
        if (err) {
          return;
        }
        // console.log("yoyo", count,event);
        data.push({
          beneficiary: event.args.beneficiary,
          tokenAmount: event.args.tokenAmount.toNumber(),
          bonusAmount: event.args.tokenAmount.toNumber()
        });
        if (count == 4) {
          console.log(data);
          resolve();
        }
        count++;
      });

      setTimeout(async () => {
        await ICOInstance.transfer(beneficiary, amount * 2, bonus * 2, {
          from: accounts[0]
        });
        await ICOInstance.transfer(beneficiary1, amount * 3, bonus * 3, {
          from: accounts[0]
        });
        await ICOInstance.transfer(beneficiary2, amount * 4, bonus * 4, {
          from: accounts[0]
        });
        await ICOInstance.transfer(beneficiary3, amount * 5, bonus * 5, {
          from: accounts[0]
        });
      }, 1000);
    });
  });
});
