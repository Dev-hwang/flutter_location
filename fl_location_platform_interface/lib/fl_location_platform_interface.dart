library fl_location_platform_interface;

import 'dart:convert';

import 'package:fl_location_platform_interface/src/models/location.dart';
import 'package:fl_location_platform_interface/src/models/location_accuracy.dart';
import 'package:fl_location_platform_interface/src/models/location_permission.dart';
import 'package:fl_location_platform_interface/src/models/location_services_status.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'package:fl_location_platform_interface/src/models/location.dart';
export 'package:fl_location_platform_interface/src/models/location_accuracy.dart';
export 'package:fl_location_platform_interface/src/models/location_permission.dart';
export 'package:fl_location_platform_interface/src/models/location_services_status.dart';
export 'package:fl_location_platform_interface/src/utils/location_utils.dart';

part 'src/method_channel_fl_location.dart';
part 'src/platform_interface_fl_location.dart';
