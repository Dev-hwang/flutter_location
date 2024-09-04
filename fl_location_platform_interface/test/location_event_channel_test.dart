import 'dart:convert';

import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dummy/location_dummy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelFlLocation platform = MethodChannelFlLocation();

  final Location dummyLocation = Location.fromJson(dummyLocationJsonA);

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      platform.locationEventChannel,
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink events) {
          if (arguments is! Map) {
            events.error(
                code: "E001",
                message: "invalid arguments type: ${arguments.runtimeType}");
            return;
          }

          final int? accuracy = arguments['accuracy'];
          final int? interval = arguments['interval'];
          final double? distanceFilter = arguments['distanceFilter'];
          if (accuracy != LocationAccuracy.best.index ||
              interval != 1000 ||
              distanceFilter != 10.0) {
            events.error(
                code: "E002",
                message: "mismatch settings value: ${arguments.toString()}");
            return;
          }

          final String locationJsonString = jsonEncode(dummyLocation.toJson());
          events.success(locationJsonString);
        },
        onCancel: (Object? arguments) {
          // not use
        },
      ),
    );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(platform.locationEventChannel, null);
  });

  test('getLocationStream test', () async {
    final Location location = await platform
        .getLocationStream(
          accuracy: LocationAccuracy.best,
          interval: 1000,
          distanceFilter: 10.0,
        )
        .first;
    expect(location, dummyLocation);
  });
}
