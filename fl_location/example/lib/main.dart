import 'dart:async';

import 'package:fl_location/fl_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExampleApp());

enum ButtonState { LOADING, DONE, DISABLED }

class ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  StreamSubscription<Location>? _locationSubscription;

  final _resultText = ValueNotifier('');
  final _getLocationButtonState = ValueNotifier(ButtonState.DONE);
  final _subscribeLocationStreamButtonState = ValueNotifier(ButtonState.DONE);
  final _isSubscribeLocationStream = ValueNotifier(false);

  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      _resultText.value = 'Location services is disabled.';
      return false;
    }

    LocationPermission permission = await FlLocation.checkLocationPermission();
    if (permission == LocationPermission.deniedForever) {
      _resultText.value = 'Location permission has been permanently denied.';
      return false;
    } else if (permission == LocationPermission.denied) {
      // Ask the user for location permission.
      permission = await FlLocation.requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _resultText.value = 'Location permission has been denied.';
        return false;
      }
    }

    // Location permission must always be granted (LocationPermission.always)
    // to collect location data in the background.
    if (background == true && permission == LocationPermission.whileInUse) {
      _resultText.value =
          'Location permission must always be granted to collect location in the background.';
      return false;
    }

    return true;
  }

  Future<void> _getLocation() async {
    if (await _checkAndRequestPermission()) {
      _getLocationButtonState.value = ButtonState.LOADING;
      _subscribeLocationStreamButtonState.value = ButtonState.DISABLED;

      final Duration timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
        _onLocation(location);
      }).onError((error, stackTrace) {
        _onError(error);
      }).whenComplete(() {
        _getLocationButtonState.value = ButtonState.DONE;
        _subscribeLocationStreamButtonState.value = ButtonState.DONE;
      });
    }
  }

  Future<void> _subscribeLocationStream() async {
    if (await _checkAndRequestPermission()) {
      if (_locationSubscription != null) {
        await _unsubscribeLocationStream();
      }

      _locationSubscription = FlLocation.getLocationStream()
          .handleError(_onError)
          .listen(_onLocation);

      _getLocationButtonState.value = ButtonState.DISABLED;
      _isSubscribeLocationStream.value = true;
    }
  }

  Future<void> _unsubscribeLocationStream() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    _getLocationButtonState.value = ButtonState.DONE;
    _isSubscribeLocationStream.value = false;
  }

  void _onLocation(Location location) {
    _resultText.value = location.toJson().toString();
  }

  void _onLocationServicesStatus(LocationServicesStatus status) {
    print('LocationServicesStatus: $status');
  }

  void _onError(dynamic error) {
    _resultText.value = error.toString();
  }

  @override
  void initState() {
    super.initState();
    // The getLocationServicesStatusStream function is not available on Web.
    if (!kIsWeb) {
      FlLocation.getLocationServicesStatusStream()
          .listen(_onLocationServicesStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Location'),
          centerTitle: true,
        ),
        body: _buildContentView(),
      ),
    );
  }

  Widget _buildContentView() {
    final Widget buttonWidget = Column(
      children: [
        const SizedBox(height: 8.0),
        ValueListenableBuilder(
          valueListenable: _getLocationButtonState,
          builder: (context, state, _) {
            return _buildTestButton(
              text: 'GET Location',
              state: state,
              onPressed: _getLocation,
            );
          },
        ),
        const SizedBox(height: 8.0),
        ValueListenableBuilder(
          valueListenable: _subscribeLocationStreamButtonState,
          builder: (context, state, _) {
            return ValueListenableBuilder(
              valueListenable: _isSubscribeLocationStream,
              builder: (context, isSubscribe, __) {
                final String text;
                final VoidCallback? onPressed;
                if (isSubscribe) {
                  text = 'Unsubscribe LocationStream';
                  onPressed = _unsubscribeLocationStream;
                } else {
                  text = 'Subscribe LocationStream';
                  onPressed = _subscribeLocationStream;
                }

                return _buildTestButton(
                  text: text,
                  state: state,
                  onPressed: onPressed,
                );
              },
            );
          },
        ),
      ],
    );

    final Widget resultWidget = ValueListenableBuilder(
      valueListenable: _resultText,
      builder: (context, resultText, _) {
        return Text(resultText);
      },
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      children: [
        buttonWidget,
        const SizedBox(height: 10.0),
        resultWidget,
      ],
    );
  }

  Widget _buildTestButton({
    required String text,
    required ButtonState state,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      child: (state == ButtonState.LOADING)
          ? SizedBox.fromSize(
              size: const Size.square(20.0),
              child: const CircularProgressIndicator(strokeWidth: 2.0))
          : Text(text),
      onPressed: (state == ButtonState.DONE) ? onPressed : null,
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _resultText.dispose();
    _getLocationButtonState.dispose();
    _subscribeLocationStreamButtonState.dispose();
    _isSubscribeLocationStream.dispose();
    super.dispose();
  }
}
