// SPDX-License-Identifier: MIT
pragma solidity 0.5.17;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol";

/**
 * @title RariGovernanceToken
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 * @notice RariGovernanceToken is the contract behind the Rari Governance Token (RGT), an ERC20 token accounting for the ownership of Rari Stable Pool, Yield Pool, and Ethereum Pool.
 */
contract RariGovernanceToken is Initializable, ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
    /**
     * @dev Initializer that reserves 8.75 million RGT for liquidity mining and 1.25 million RGT to the team/advisors/etc.
     */
    function initialize(address distributor, address vesting) public initializer {
        ERC20Detailed.initialize("Rari Governance Token", "RGT", 18);
        ERC20Pausable.initialize(msg.sender);
        _mint(distributor, 8750000 * (10 ** uint256(decimals())));
        _mint(vesting, 1250000 * (10 ** uint256(decimals())));
    }

    /**
     * @dev Boolean indicating if this RariFundToken contract has been deployed at least `v1.4.0` or upgraded to at least `v1.4.0`.
     */
    bool private upgraded1;

    /**
     * @dev Boolean indicating if this RariFundToken contract has been deployed at least `v1.4.0` or upgraded to at least `v1.4.0`.
     */
    bool private upgraded2;

    /**
     * @dev Upgrades RariGovernanceToken from `v1.3.0` to `v1.4.0`.
     */
    function upgrade1(address uniswapDistributor, address loopringDistributor) external onlyPauser {
        require(!upgraded1, "Already upgraded.");
        uint256 exchangeLiquidityRewards = 568717819057309757517546;
        uint256 uniswapRewards = exchangeLiquidityRewards.mul(80).div(100);
        _mint(uniswapDistributor, uniswapRewards);
        _mint(loopringDistributor, exchangeLiquidityRewards.sub(uniswapRewards));
        upgraded1 = true;
    }

    /**
     * @dev Upgrades RariGovernanceToken from `v1.3.0` to `v1.4.0`.
     */
    function upgrade2(address distributorV2, address vestingV2) external onlyPauser {
        require(!upgraded2, "Already upgraded.");
        _mint(distributorV2, 3000000 * (10 ** uint256(decimals())));
        _mint(vestingV2, 7000000 * (10 ** uint256(decimals())));
        upgraded2 = true;
    }
}
