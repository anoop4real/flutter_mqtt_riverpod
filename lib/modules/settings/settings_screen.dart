import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/interfaces/IMQTTController.dart';
import '../core/models/MQTTAppState.dart';
import '../core/providers/Providers.dart';
import '../core/widgets/statusbar.dart';
import '../helpers/status_info_message_utils.dart';

class SettingsScreen extends ConsumerStatefulWidget {

  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  final TextEditingController _hostTextController = TextEditingController();
  late IMQTTController _manager;

  @override
  void dispose() {
    _hostTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _manager = ref.watch(mqttManagerProvider);

    return Scaffold(
        appBar: _buildAppBar(context) as PreferredSizeWidget?,
        body: _manager.currentState == null
            ? const CircularProgressIndicator()
            : _buildColumn(_manager));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: Colors.greenAccent,
    );
  }

  Widget _buildColumn(IMQTTController manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        _buildEditableColumn(manager.currentState),
      ],
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    } else if (controller == _hostTextController && _manager.host != null) {
      _hostTextController.text = _manager.host!;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null,
            child: const Text('Connect'), //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: state != MQTTAppConnectionState.disconnected
                ? _disconnect
                : null,
            child: const Text('Disconnect'), //
          ),
        ),
      ],
    );
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    _manager.initializeMQTTClient(
        host: _hostTextController.text, identifier: osPrefix);
    _manager.connect();
  }

  void _disconnect() {
    _manager.disconnect();
  }
}
