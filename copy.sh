#!/bin/bash
set -e

DIR="$2"
if ! [ -d $DIR/node_modules/react-native-mo-paypal ]; then
  echo "$DIR/node_modules/react-native-mo-paypal not there" 1>&2
  exit 1
fi

if [ "$1" == "from" ]; then
  cp -r $DIR/node_modules/react-native-mo-paypal/ios/ReactNativeMoPayPal ./ios/
  cp -r $DIR/node_modules/react-native-mo-paypal/{readme.md,src} .
  cp -r $DIR/node_modules/react-native-mo-paypal/android/{src,build.gradle} ./android/
fi

if [ "$1" == "to" ]; then
  rsync -a --exclude node_modules --exclude .git --exclude example . $DIR/node_modules/react-native-mo-paypal/
fi
