import 'dart:async';

import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  static HubConnection? _hubConnection;
  static bool _isAuthenticated = false;
  static Completer<void>? _connectionCompleter;

  static bool get isAuthenticated => _isAuthenticated;

  static Future<void> ensureConnected() async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      return;
    }

    if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
      return _connectionCompleter!.future;
    }

    _connectionCompleter = Completer<void>();
    try {
      await _hubConnection?.start();
      _connectionCompleter?.complete();
    } catch (e) {
      _connectionCompleter?.completeError(e);
      rethrow;
    }
  }

  static Future<void> initialize() async {
    try {
      _hubConnection = HubConnectionBuilder().withUrl(
        'https://uat.marwadionline.com/mchat/apichatHub/',
        HttpConnectionOptions(
          transport: HttpTransportType.longPolling,
          logging: (level, message) => print(message),
        ),
      ).withAutomaticReconnect().build();

      _hubConnection?.onclose((error) {
        print('Connection closed: $error');
        _isAuthenticated = false;
      });

      _hubConnection?.onreconnecting((error) => print('Reconnecting: $error'));

      _hubConnection?.onreconnected((connectionId) {
        print('Reconnected with connectionId: $connectionId');
        _connectionCompleter?.complete();
      });

      await ensureConnected();
    } catch (e) {
      print('SignalR initialization error: $e');
      rethrow;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await ensureConnected();

      if (_hubConnection?.state != HubConnectionState.connected) {
        throw Exception('Failed to establish connection');
      }

      final result = await _hubConnection?.invoke('Login', args: [email, password]);
      _isAuthenticated = true;
      return true;
    } catch (e) {
      _isAuthenticated = false;
      print('Login error: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      _isAuthenticated = false;
      await _hubConnection?.stop();
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

// Add other SignalR methods as needed
}