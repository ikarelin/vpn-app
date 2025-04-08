// lib/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../providers/vpn_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connection History')),
      body: Consumer<VpnProvider>(
        builder: (context, vpnProvider, _) {
          if (vpnProvider.connectionHistory.isEmpty) {
            return Center(child: Text('No connection history yet'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(5.w),
            itemCount: vpnProvider.connectionHistory.length,
            itemBuilder: (context, index) {
              final connection = vpnProvider.connectionHistory[index];
              return Card(
                child: ListTile(
                  title: Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(connection.startTime),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    'Duration: ${connection.duration.inMinutes}m ${connection.duration.inSeconds % 60}s',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
