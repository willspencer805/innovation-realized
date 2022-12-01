module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId
  log("Deploying Voteable")

  await deploy("Voteable", {
    from: deployer,
    log: true,
  })
  log("Voteable contract deployed!")
  log("---------------------------------------------------------")
}

module.exports.tags = ["all"]
