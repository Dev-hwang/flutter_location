# fl_location

A plugin that can access the location services of each platform and collect device location data.

## Platform

- [x] Android
- [x] iOS
- [x] Web

## Features

* Can request location permission.
* Can get the current location of the device.
* Can check whether location services is enabled.
* Can subscribe to `LocationStream` to listen location in real time.
* Can subscribe to `LocationServicesStatusStream` to listen location services status changes in real time.

## Getting started

To use this plugin, add `fl_location` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  fl_location: ^5.0.0
```

After adding the `fl_location` plugin to the flutter project, we need to specify the platform-specific permissions for this plugin to work properly.

### :baby_chick: Android

Since this plugin works based on location, we need to add the following permission to the `AndroidManifest.xml` file. Open the `AndroidManifest.xml` file and specify it between the `<manifest>` and `<application>` tags.

```
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

If you want to get the location in the background, add the following permission. If your project supports Android 10, be sure to add the `ACCESS_BACKGROUND_LOCATION` permission.

```
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### :baby_chick: iOS

Like the Android platform, this plugin works based on location, we need to add the following description. Open the `ios/Runner/Info.plist` file and specify it inside the `<dict>` tag.

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>Used to collect location data.</string>
```

If you want to get the location in the background, add the following description.

```
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Used to collect location data in the background.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Used to collect location data in the background.</string>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>location</string>
</array>
```

## How to use

1. Check whether the location permission is granted or not, and if not granted, request the location permission.

```dart
Future<bool> _requestLocationPermission({bool background = false}) async {
  if (!await FlLocation.isLocationServicesEnabled) {
    // Location services is disabled.
    return false;
  }

  LocationPermission permission = await FlLocation.checkLocationPermission();
  if (permission == LocationPermission.denied) {
    // Android: ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION
    // iOS 12-: NSLocationWhenInUseUsageDescription or NSLocationAlwaysAndWhenInUseUsageDescription
    // iOS 13+: NSLocationWhenInUseUsageDescription
    permission = await FlLocation.requestLocationPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    // Location permission has been ${permission.name}.
    return false;
  }

  // Web: Only allow whileInUse permission.
  if (kIsWeb || kIsWasm) {
    return true;
  }

  // Android: You must request location permission one more time to access background location.
  // iOS 12-: You can request always permission through the above request.
  // iOS 13+: You can only request whileInUse permission. When the app enters the background,
  // a prompt will appear asking for always permission.
  if (Platform.isAndroid &&
      background &&
      permission == LocationPermission.whileInUse) {
    // You need a clear explanation of why your app's feature needs access to background location.
    // https://developer.android.com/develop/sensors-and-location/location/permissions#request-background-location

    // Android: ACCESS_BACKGROUND_LOCATION
    permission = await FlLocation.requestLocationPermission();

    if (permission != LocationPermission.always) {
      // Location permission must always be granted to collect location in the background.
      return false;
    }
  }

  return true;
}
```

2. To get the current Location, use the `getLocation` function.

```dart
Future<void> _getLocation() async {
  if (await _requestLocationPermission()) {
    final Location location = await FlLocation.getLocation();
    print('Location: ${location.toJson()}');
  }
}
```

3. To listen location in real time, use the `getLocationStream` function.

```dart
StreamSubscription<Location>? _locationSubscription;

Future<void> _subscribeLocationStream() async {
  if (await _requestLocationPermission()) {
    _locationSubscription = FlLocation.getLocationStream().listen(_onLocation);
  }
}

void _onLocation(Location location) {
  print('Location: ${location.toJson()}');
}
```

4. To listen location services status changes in real time, use the `getLocationServicesStatusStream` function.

```dart
StreamSubscription<LocationServicesStatus>? _locationServicesStatusSubscription;

Future<void> _subscribeLocationServicesStatusStream() async {
  _locationServicesStatusSubscription = FlLocation.getLocationServicesStatusStream()
      .listen(_onLocationServicesStatus);
}

void _onLocationServicesStatus(LocationServicesStatus status) {
  print('LocationServicesStatus: $status');
}
```

## Background Mode

If you want to use this plugin in the background, use the [`flutter_foreground_task`](https://pub.dev/packages/flutter_foreground_task) plugin.

demo: https://github.com/Dev-hwang/flutter_foreground_task_example/tree/main/location_service

## More Documentation

Go [here](./documentation/models_documentation.md) to learn about the `models` provided by this plugin.

Go [here](./documentation/utility_documentation.md) to learn about the `utility` provided by this plugin.

Go [here](./documentation/migration_documentation.md) to `migrate` to the new version.

## Support

If you find any bugs or issues while using the plugin, please register an issues on [GitHub](https://github.com/Dev-hwang/flutter_location/issues). You can also contact us at <hwj930513@naver.com>.
