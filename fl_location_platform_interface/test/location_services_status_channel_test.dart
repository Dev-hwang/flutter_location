import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelFlLocation platform = MethodChannelFlLocation();

  final LocationServicesStatus dummyStatus = LocationServicesStatus.enabled;

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      platform.locationServicesStatusEventChannel,
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink events) {
          events.success(dummyStatus.index);
        },
        onCancel: (Object? arguments) {
          // not use
        },
      ),
    );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
            platform.locationServicesStatusEventChannel, null);
  });

  test('getLocationServicesStatusStream test', () async {
    final LocationServicesStatus status =
        await platform.getLocationServicesStatusStream().first;
    expect(status, dummyStatus);
  });
}
