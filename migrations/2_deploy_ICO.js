const ICO = artifacts.require("Crowdsale");


module.exports = (deployer) => {
    deployer.deploy(ICO);
}