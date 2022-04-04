import { NativeModules, Platform } from "react-native";

// console.log('react-native-mo-versioning', NativeModules.ReactNativeMoVersioning);

export function getAppVersion(): string {
  if (Platform.OS === "ios") {
    return NativeModules.ReactNativeMoVersioning.infoDictionary.CFBundleShortVersionString ?? '';
  } else if (Platform.OS === "android") {
    return NativeModules.ReactNativeMoVersioning.buildConfig.VERSION_NAME ?? '';
  } else {
    return '';
  }
}

export function getAppBuild(): number {
  if (Platform.OS === "ios") {
    return parseInt(NativeModules.ReactNativeMoVersioning.infoDictionary.CFBundleVersion ?? '0');
  } else if (Platform.OS === "android") {
    return parseInt(NativeModules.ReactNativeMoVersioning.buildConfig.VERSION_CODE ?? '0');
  } else {
    return 0;
  }
}

export function getAppGitRev(): string | null {
  if (Platform.OS === "ios") {
    return NativeModules.ReactNativeMoVersioning.infoDictionary.GitRev ?? null;
  } else if (Platform.OS === "android") {
    return NativeModules.ReactNativeMoVersioning.buildConfig.GIT_REV ?? null;
  } else {
    return '';
  }
}
