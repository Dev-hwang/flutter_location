## 5.0.0

* [**CHORE**] Upgrade web dependencies
  - Bump minimum supported SDK version to `Flutter 3.22.0` / `Dart 3.4.0`
  - Support `WebAssembly(WASM)` builds

## 4.4.2

* [**FIX**] Fix an issue related to `requestLocationPermission` on iOS [#23](https://github.com/Dev-hwang/flutter_location/issues/23)

## 4.4.1

* [**FIX**] Fix an issue where an error occurs when parsing the location JSON in release mode

## 4.4.0

* [**CHANGE**] Change the behavior of requestLocationPermission [#21](https://github.com/Dev-hwang/flutter_location/issues/21)
  - Allow incremental location permission requests
  - Check [How to use-1](https://pub.dev/packages/fl_location#how-to-use) for more details

## 4.3.0

* [**FEAT**] Allow use of checkLocationPermission in the background
* [**FEAT**] Allow ACCESS_COARSE_LOCATION permission

## 4.1.0+1

* [**DOCS**] Update example
* [**DOCS**] Update readme

## 4.1.0

* [**CHORE**] Upgrade dependencies

## 4.0.0

* [**CHORE**] Updates minimum supported SDK version to `Flutter 3.10` / `Dart 3.0`
* [**CHORE**] Updates dependencies
* [**FIX**] Fixed an issue where Location.toJson could not be encoded with jsonEncode

## 3.1.0

* [**FEAT**] Support AGP 8

## 3.0.0

* [**CHORE**] Update dependency constraints to `sdk: '>=2.18.0 <4.0.0'` `flutter: '>=3.3.0'`

## 2.1.1

* [**FIX**] Fix IllegalStateException [#12](https://github.com/Dev-hwang/flutter_location/issues/12)

## 2.1.0

* [**FEAT**] Add ability to get location in the background [#10](https://github.com/Dev-hwang/flutter_location/issues/10)
* [**FIX**] Fix ConcurrentModificationException [#13](https://github.com/Dev-hwang/flutter_location/issues/13)
* [**FIX**] Fix location update channel close issue [#14](https://github.com/Dev-hwang/flutter_location/issues/14)

## 2.0.0

* [**CHORE**] Upgrade minimum Flutter version to 3.0.0
* [**CHORE**] Upgrade dependencies

## 1.2.2

* [[#4](https://github.com/Dev-hwang/flutter_location/issues/4)] Fix onRequestPermissionsResult implement issue.

## 1.2.1

* Upgrade dependencies.
* Downgrade Android minSdkVersion to 21.

## 1.2.0

* Upgrade dependencies.
* Added LocationUtils class which implements `distanceBetween` and `bearingBetween` functions.
* Bump Android minSdkVersion to 23.
* Bump Android compileSdkVersion to 31.

## 1.1.0

* Now this plugin is also available on the web.

## 1.0.1

* Upgrade `fl_location_platform_interface: ^1.0.1`
* Fixed invalid homepage URL.
* Fixed an issue where `getLocation` and `getLocationStream` functions could not be called at the same time.

## 1.0.0

* Initial release.
