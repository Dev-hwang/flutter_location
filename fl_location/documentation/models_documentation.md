## Models

### :chicken: Location

A data class that represents a location model.

| Field                    | Description                                                       |
|--------------------------|-------------------------------------------------------------------|
| `latitude`               | The latitude of the location.                                     |
| `longitude`              | The longitude of the location.                                    |
| `accuracy`               | The accuracy of the location.                                     |
| `altitude`               | The altitude of the location.                                     |
| `heading`                | The angle in the direction the device is moving.                  |
| `speed`                  | The movement speed of the device.                                 |
| `speedAccuracy`          | The accuracy of `speed`.                                          |
| `millisecondsSinceEpoch` | The millisecondsSinceEpoch at which the location update occurred. |
| `timestamp`              | The device time at which the location update occurred.            |
| `isMock`                 | Whether the mock location.                                        |

### :chicken: LocationAccuracy

An enumeration of location accuracy.

| Value        | Description                                                                           |
|--------------|---------------------------------------------------------------------------------------|
| `powerSave`  | The location has an accuracy of 10km on Android and 3km on iOS.                       |
| `low`        | The location has an accuracy of 10km on Android and 1km on iOS.                       |
| `balanced`   | The location has an accuracy of 100m for both Android and iOS.                        |
| `high`       | The location has an accuracy of ~100m on Android and 10m on iOS.                      |
| `best`       | The location has an accuracy of ~100m on Android and ~10m on iOS.                     |
| `navigation` | The location has an accuracy of ~100m on Android and optimized for navigation on iOS. |

### :chicken: LocationPermission

An enumeration of location permission.

| Value           | Description                                                                                                                                      |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| `always`        | The app can read location at any time. The app need this permission to read location in the background.                                          |
| `whileInUse`    | The location can only be read while using the app.                                                                                               |
| `denied`        | The location cannot be read because permission is denied. The app can request runtime permissions again.                                         |
| `deniedForever` | The location cannot be read because permission is denied. The app can no longer request runtime permissions and must grant permissions manually. |

### :chicken: LocationServicesStatus

An enumeration of location services status.

| Value      | Description                     |
|------------|---------------------------------|
| `enabled`  | Location services are enabled.  |
| `disabled` | Location services are disabled. |
