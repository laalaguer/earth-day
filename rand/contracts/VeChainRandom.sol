pragma solidity >=0.5.3 <=0.6.4;

contract Extension {
    function blake2b256(bytes memory data) public view returns(bytes32);
    function blockID(uint num) public view returns(bytes32);
    function blockTotalScore(uint num) public  view returns(uint64);
    function blockTime(uint num) public view returns(uint);
    function blockSigner(uint num) public view returns(address);
    function totalSupply() public view returns(uint256);
    function txProvedWork() public view returns(uint256);
    function txID() public  view returns(bytes32);
    function txBlockRef() public view returns(bytes8);
    function txExpiration() public view returns(uint);
}

// bytes 32 = uint 256
// address = bytes 20 = uint 160
contract VeChainRandom {
    event RandomNumber(uint number);

    Extension en;

    // Get a random number
    // from a give block number
    function _getRandomNumber(uint top, uint _blockNumber) public returns (uint) { // get a number from [1, top]
        require(top > 1, "top > 1 required");

        address extension_native = 0x0000000000000000000000457874656E73696F6e;
        en = Extension(extension_native);

        uint counter = 5; // How many previous blocks to take into consideration?
        uint256 s;
        for (uint i = 1; i < counter; i++) {
            uint256 s1 = uint256(en.blockSigner( (_blockNumber - i) ));
            s = s ^ (s1);
            uint256 s2 = uint256(en.blockID( (_blockNumber - i) ));
            s = s ^ (s2);
        }

        uint result = (s % top) + 1;
        emit RandomNumber(result);
        
        return result;
    }

    // Quickly get a random number
    // based on current block
    function quickRandomNumber(uint top) public returns (uint) {
        uint _blockNumber = block.number;
        return _getRandomNumber(top, _blockNumber);
    }
}
