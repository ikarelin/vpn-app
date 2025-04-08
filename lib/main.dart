// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vpn_app/screens/anlytics_screen.dart';
import 'firebase_options.dart';
import 'providers/vpn_provider.dart';
import 'screens/connection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VpnProvider(),
      child: Sizer(
        builder:
            (context, orientation, deviceType) => MaterialApp(
              title: 'VPN App',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: '/',
              routes: {
                '/': (context) => ConnectionScreen(),
                '/analytics': (context) => AnalyticsScreen(),
              },
            ),
      ),
    );
  }
}
