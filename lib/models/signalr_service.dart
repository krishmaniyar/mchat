import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  static HubConnection? _hubConnection;

  static Future<void> startConnection() async {
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
        'https://uat.marwadionline.com/mchat/apichatHub',
        HttpConnectionOptions(
          transport: HttpTransportType.longPolling,
          logging: (level, message) => print(message),
        ),
      ).build();

      await _hubConnection?.start();
      print('SignalR Connection Established');
    } catch (e) {
      print('SignalR Connection Error: $e');
      rethrow;
    }
  }

  void receiveMessages(Function(String) onMessageReceived) {
    _hubConnection?.on('ReceiveMessage', (message) {
      if (message != null && message.isNotEmpty) {
        onMessageReceived(message[1].toString()); // Pass the message to the callback
      }
    });
  }

  void sendMessage(String user, String message) {
    _hubConnection?.invoke('SendMessage', args: [user, message]);
  }

  Future<void> stopConnection() async {
    await _hubConnection?.stop();
  }

  static Future<void> initialize() async {
    await startConnection();
  }
}