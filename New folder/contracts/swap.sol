pragma solidity 0.6.6;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-periphery/contracts/libraries/SafeMath.sol';

// fixed window oracle that recomputes the average price for the entire period once every period
// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
contract PriceOracle {
    using FixedPoint for *;
    
    using SafeMath for uint;

    uint public constant PERIOD = 24 hours;

    address factory;

   // IUniswapV2Pair[] immutable pair;
   // address public immutable token0;
   // address public immutable token1;

    //uint    public price0CumulativeLast;
    //uint    public price1CumulativeLast;
    //uint32  public blockTimestampLast;
    //FixedPoint.uq112x112 public price0Average;
    //FixedPoint.uq112x112 public price1Average;
    mapping (address => FixedPoint.uq112x112) price0Average;

    mapping (address => FixedPoint.uq112x112) price1Average;

    mapping(string => address) AddrToken;

    mapping(address => uint) price0CumulativeLast;
    
    mapping(address => uint) price1CumulativeLast;

    mapping(address => uint32) blockTimestampLast;

    constructor(address _factory) public {
        factory = _factory;
    }
    function sortTokens(address tokenA, address tokenB) internal pure returns (address _token0, address _token1) {
    require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
    (_token0, _token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    require(_token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    function Swap(address _token0, address _token1) public {

        (address tokenA,address tokenB) = sortTokens(_token0,_token1);

        IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));

        if(price0CumulativeLast[address(_pair)] == 0)
        price0CumulativeLast[address(_pair)] = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
        if(price1CumulativeLast[address(_pair)] == 0) 
        price1CumulativeLast[address(_pair)] = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
        uint112 reserve0;
        uint112 reserve1;
        (reserve0, reserve1, blockTimestampLast[address(_pair)]) = _pair.getReserves();
        require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair
    }

    function update(address _token0, address _token1) external {
        (address tokenA,address tokenB) = sortTokens(_token0,_token1);
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
            UniswapV2OracleLibrary.currentCumulativePrices(pair);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast[pair]; // overflow is desired

        // ensure that at least one full period has passed since the last update
        require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        price0Average[pair] = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast[pair]) / timeElapsed));
        price1Average[pair] = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast[pair]) / timeElapsed));

        price0CumulativeLast[pair] = price0Cumulative;
        price1CumulativeLast[pair] = price1Cumulative;
        blockTimestampLast[pair] = blockTimestamp;
    }

    // note this will always return 0 before update has been called successfully for the first time.
    function consult(address tokenIn, uint amountIn,address tokenOut) external view returns (uint amountOut) {
        (address tokenA,address tokenB) = sortTokens(tokenIn,tokenOut);
        address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);
        if (tokenIn == tokenA) {
            amountOut = price0Average[pair].mul(amountIn).decode144();
        } 
        else {
            require(tokenIn == tokenB, 'ExampleOracleSimple: INVALID_TOKEN');
            amountOut = price1Average[pair].mul(amountIn).decode144();
        }
    }
}