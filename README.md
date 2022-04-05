# react-native-mo-paypal


## Installation

Install just like your ordinary react-native module.

## Notes

The paypal libraries are a bit of a mess.

For android we need to replace android:allowBackup as it is specified in the paypal lib.

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
  package="com.myapp"
  xmlns:tools="http://schemas.android.com/tools">

  <application
    tools:replace="android:allowBackup"
  >
```

in the main gradle file we need to add (not kidding):

```
allprojects {
    repositories {
        maven {
            url "https://cardinalcommerceprod.jfrog.io/artifactory/android"
            credentials {
                username 'braintree_team_sdk'
                password 'AKCp8jQcoDy2hxSWhDAUQKXLDPDx6NYRkqrgFLRc3qDrayg6rrCbJpsKKyMwaykVL8FWusJpp'
            }
            content {
                includeGroup "org.jfrog.cardinalcommerce.gradle"
            }
        }
    }
}
```
