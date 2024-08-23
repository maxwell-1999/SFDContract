pragma solidity ^0.8.25;
interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IOptionsConfig is IAccessControl {
    struct Window {
        uint8 startHour;
        uint8 startMinute;
        uint8 endHour;
        uint8 endMinute;
    }

    event UpdateMarketTime();
    event UpdateMaxPeriod(uint32 value);
    event UpdateMinPeriod(uint32 value);

    event UpdateOptionFeePerTxnLimitPercent(uint16 value);
    event UpdateOverallPoolUtilizationLimit(uint16 value);
    event UpdateSettlementFeeDisbursalContract(address value);
    event UpdatetraderNFTContract(address value);
    event UpdateAssetUtilizationLimit(uint16 value);
    event UpdateMinFee(uint256 value);

    function traderNFTContract() external view returns (address);

    function settlementFeeDisbursalContract() external view returns (address);

    function marketTimes(
        uint8
    ) external view returns (uint8, uint8, uint8, uint8);

    function assetUtilizationLimit() external view returns (uint16);

    function overallPoolUtilizationLimit() external view returns (uint16);

    function maxPeriod() external view returns (uint32);

    function minPeriod() external view returns (uint32);

    function minFee() external view returns (uint256);

    function optionFeePerTxnLimitPercent() external view returns (uint16);

    function setSettlementFeeDisbursalContract(address) external;

    function setMarketTime(Window[] memory) external;

    function setOptionFeePerTxnLimitPercent(uint16) external;

    function setOverallPoolUtilizationLimit(uint16) external;

    function setAssetUtilizationLimit(uint16) external;

    function settraderNFTContract(address) external;

    function setMinFee(uint256) external;

    function setMaxPeriod(uint32) external;

    function setMinPeriod(uint32) external;
}