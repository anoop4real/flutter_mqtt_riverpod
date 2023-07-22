import 'package:flutter/cupertino.dart';

import '../models/MQTTAppState.dart';

abstract class IMQTTController extends ChangeNotifier {

  MQTTAppState get currentState;
  String? get host;
  void initializeMQTTClient({
    required String host,
    required String identifier,
  });

  void connect();
  void disconnect();
  void publish(String message);
  void subScribeTo(String topic);
  void unSubscribe(String topic);
  void unSubscribeFromCurrentTopic();
}