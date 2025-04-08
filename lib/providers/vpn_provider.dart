// lib/providers/vpn_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/connection.dart';
import '../services/vpn_service.dart';
import 'dart:convert';

class VpnProvider with ChangeNotifier {
  bool _isConnected = false;
  bool _isConnecting = false;
  DateTime? _connectionStartTime;
  List<Connection> _connectionHistory = [];
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final VPNService _vpnService = VPNService();

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  Duration get connectionDuration =>
      _connectionStartTime != null
          ? DateTime.now().difference(_connectionStartTime!)
          : Duration.zero;
  List<Connection> get connectionHistory => _connectionHistory;

  VpnProvider() {
    _loadHistory();
  }

  Future<bool> toggleConnection() async {
    _isConnecting = true; // Устанавливаем флаг "в процессе"
    notifyListeners();

    if (_isConnected) {
      final success = await _vpnService.disconnect();
      if (!success) {
        _isConnecting = false;
        notifyListeners();
        return false;
      }

      final duration = DateTime.now().difference(_connectionStartTime!);
      final connection = Connection(_connectionStartTime!, duration);
      _connectionHistory.insert(0, connection);
      if (_connectionHistory.length > 5) _connectionHistory.removeLast();
      _connectionStartTime = null;
      await _analytics.logEvent(
        name: 'vpn_disconnected',
        parameters: {'duration': duration.inSeconds},
      );
      await _saveHistory();
    } else {
      final success = await _vpnService.connect();
      if (!success) {
        _isConnecting = false;
        notifyListeners();
        return false;
      }

      _connectionStartTime = DateTime.now();
      await _analytics.logEvent(name: 'vpn_connected');
    }

    _isConnected = !_isConnected;
    _isConnecting = false; // Сбрасываем флаг после завершения
    notifyListeners();
    return true;
  }

  Future<String> getVpnStatus() async {
    return await _vpnService.getServerStatus();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('connection_history') ?? [];
    _connectionHistory =
        historyJson
            .map((json) => Connection.fromJson(jsonDecode(json)))
            .toList();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> historyJson =
        _connectionHistory.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList('connection_history', historyJson);
  }
}
