import 'package:flutter_mqtt_riverpod/modules/core/managers/MQTTManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../interfaces/IMQTTController.dart';


final mqttManagerProvider = ChangeNotifierProvider<IMQTTController>((ref) {
  return MQTTManager();
});