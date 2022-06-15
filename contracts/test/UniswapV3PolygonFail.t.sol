pragma solidity 0.8.10;
pragma abicoder v2;

import "forge-std/Test.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/IPeripheryImmutableState.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

contract UniswapV3PolygonTest is Test {
    address constant UNISWAP_ROUTER_V3 =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    address USDC;
    address DAI;

    function setUp() public {
        deal(address(this), 10 ether);

        if (block.chainid == 1) {
            // ETHEREUM
            USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
            DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        } else if (block.chainid == 137) {
            // POLYGON
            USDC = address(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
            DAI = address(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063);
        }
    }

    function testUniswapV3() public view {
        address factory = IPeripheryImmutableState(UNISWAP_ROUTER_V3).factory();
        console2.log("FACTORY: ", factory);

        address pool = IUniswapV3Factory(factory).getPool(
            USDC,
            DAI,
            uint24(500)
        );
        console2.log("POOL: ", pool);
    }
}
