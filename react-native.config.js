module.exports = {
  dependency: {
    platforms: {
      // https://github.com/react-native-community/cli/blob/master/docs/dependencies.md
      ios: {
        scriptPhases: [
          {
            name: '[react-native-mo-versioning] Set Version',
            path: './ios-set-version.sh',
            execution_position: 'before_compile',
          },
        ],
      },
    },
  },
};
