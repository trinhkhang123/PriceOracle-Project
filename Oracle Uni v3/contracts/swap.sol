// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

contract UniswapV3Twap {
    address public token1;

    mapping (uint => address) pool;

    address _factory;

    uint24 public _fee ;

    mapping (uint => address)  addrToken;

    mapping (address => uint)  id;

    uint256 public CountToken;

    address Owner;
  
    constructor(uint24 fee, address factory) {
        _fee = fee;
        _factory = factory;
        //_factory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
        token1 = 0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C;
                 
       // ID[0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984] = 1;// UNI
        //ID[0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6] = 2;// WETH
       // ID[0x07865c6E87B9F70255377e024ace6630C1Eaa37F] = 3;// USD//C
        //ID[0xdc31Ee1784292379Fbb2964b3B9C4124D8F89C60] = 4;// DAI

        Owner = msg.sender;
        
    }

    function addToken(address _addrToken) public {
        require(msg.sender == Owner, "You are not Admin");
        require(id[_addrToken] == 0 , "Token already exist");
        CountToken ++;
        addrToken[CountToken] = _addrToken;
        id[_addrToken] = CountToken;
        address _pool = IUniswapV3Factory(_factory).getPool(
                _addrToken,
                token1,
                _fee
            );
        require(_pool != address(0),"Pool doesn't exist" );
        pool[CountToken]=address(_pool);
    }


    function price(
        address tokenIn,
        uint128 amountIn,
        uint32 secondsAgo
    ) external view returns (uint amountOut) {
        uint verify=id[tokenIn];

        require(verify > 0 , "Token Address Wrong ");

        address tokenOut = token1;

        // (int24 tick, ) = OracleLibrary.consult(pool, secondsAgo);

        // Code copied from OracleLibrary.sol, consult()
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;

        // int56 since tick * time = int24 * uint32
        // 56 = 24 + 32
        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool[verify]).observe(
            secondsAgos
        );

        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

        // int56 / uint32 = int24
        int24 tick = int24(tickCumulativesDelta / secondsAgo);
        // Always round to negative infinity
        /*
        int doesn't round down when it is negative
        int56 a = -3
        -3 / 10 = -3.3333... so round down to -4
        but we get
        a / 10 = -3
        so if tickCumulativeDelta < 0 and division has remainder, then round
        down
        */
        if (
            tickCumulativesDelta < 0 && (tickCumulativesDelta % secondsAgo != 0)
        ) {
            tick--;
        }

        amountOut = OracleLibrary.getQuoteAtTick(
            tick,
            amountIn*(10**12),
            tokenIn,
            tokenOut
        );
    }
}