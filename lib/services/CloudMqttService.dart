import 'package:mqtt_client/mqtt_client.dart' as Mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as MqttServer;

class CloudMqttService {
  final Function _onMessage;
  final Function _onDisconnect;
  CloudMqttService(this._onMessage, this._onDisconnect);
  // Mqtt.MqttClient client;

  String broker = 'driver.cloudmqtt.com';
  int port = 18918;
  String username = 'enter your user name';
  String passwd = 'enetr your password';
  String clientIdentifier = 'android';

  // StreamSubscription subscription;
  String testMessage;

  Future<MqttServer.MqttServerClient> connectToMqttBroker() async {
    MqttServer.MqttServerClient client;

    client = MqttServer.MqttServerClient(broker, '');
    client.port = port;
    client.onDisconnected = _onDisconnect;
    final connMessage = Mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .keepAliveFor(60)
        .withWillQos(Mqtt.MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      print('[MQTT client] MQTT client connecting....');
      await client.connect(username, passwd);
    } catch (err) {
      print(
          'error connecting mqtt: username: $username passwd: $passwd \n$err');
      _disconnect(client);
      return null;
    }

    if (client.connectionStatus.state == Mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionStatus.state.toString()}');
      _disconnect(client);

      return null;
    }
    const topic = 'akash/#'; // Not a wildcard topic
    client.subscribe(topic, Mqtt.MqttQos.atMostOnce);
    client.updates.listen(_onMessage);
    return client;
  }

  Future<bool> publishMessage(String payload, String myTopic,
      MqttServer.MqttServerClient client) async {
    var topic = 'akash/$myTopic';
    final builder = Mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);

    if (client != null) {
      client.publishMessage(topic, Mqtt.MqttQos.atMostOnce, builder.payload);
      print('message published !  \n');
      return true;
    } else
      print('client is null !');
    return false;
  }

  //------------------------------------------ disconnected

  _onDisconnected() {
    print('[MQTT client] MQTT client disconnected');
  }

  _disconnect(MqttServer.MqttServerClient client) {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }
}
