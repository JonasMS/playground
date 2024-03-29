require('@nomicfoundation/hardhat-toolbox');

const {subtask} = require("hardhat/config");
const {TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS} = require("hardhat/builtin-tasks/task-names")

subtask(TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS)
  .setAction(async (_, __, runSuper) => {
    const paths = await runSuper();

    return paths.filter(p => !p.endsWith(".t.sol"));
  });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        version: '0.8.15',
        settings: {
            optimizer: {
                enabled: true,
                runs: 1000000,
            },
        },
    },
    paths: {
    tests: "./contracts/test",
  },
    mocha: {
        timeout: 40000,
    },
};