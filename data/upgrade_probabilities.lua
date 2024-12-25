local upgrades = require "data.upgrades"

local upgrade_probabilities = {
    {upgrades.UpgradeTea, 1},
    {upgrades.UpgradeEspresso, 1},
    {upgrades.UpgradeMilk, 1},
    {upgrades.UpgradeBoba, 1},
    {upgrades.UpgradeSoda, 1},
    {upgrades.UpgradeFizzyLemonade, 1},
}

return upgrade_probabilities