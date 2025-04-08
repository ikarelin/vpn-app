// lib/screens/connection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/vpn_provider.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5FA), // Светлый фон
      appBar: AppBar(
        title: Text('VPN Connection'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
          ),
        ],
      ),
      body: Consumer<VpnProvider>(
        builder:
            (context, vpnProvider, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Статус сервера
                  FutureBuilder<String>(
                    future: vpnProvider.getVpnStatus(),
                    builder: (context, snapshot) {
                      return AnimatedOpacity(
                        opacity: snapshot.hasData ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          snapshot.data ?? 'Checking status...',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  // Статус подключения с анимацией
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      vpnProvider.isConnected ? 'Connected' : 'Disconnected',
                      key: ValueKey<bool>(vpnProvider.isConnected),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // Большая круглая кнопка
                  _buildConnectionButton(vpnProvider, context),
                  SizedBox(height: 5.h),
                  // Таймер с анимацией появления/исчезновения
                  AnimatedOpacity(
                    opacity:
                        vpnProvider.isConnected && !vpnProvider.isConnecting
                            ? 1.0
                            : 0.0,
                    duration: Duration(milliseconds: 500),
                    child:
                        vpnProvider.isConnected && !vpnProvider.isConnecting
                            ? _buildTimer(vpnProvider)
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildConnectionButton(VpnProvider vpnProvider, BuildContext context) {
    return GestureDetector(
      onTap:
          vpnProvider.isConnecting
              ? null
              : () async {
                final success = await vpnProvider.toggleConnection();
                if (!success) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Connection failed')));
                }
              },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              vpnProvider.isConnected ? Colors.redAccent : Colors.greenAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child:
              vpnProvider.isConnecting
                  ? SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                  : Text(
                    vpnProvider.isConnected ? 'Disconnect' : 'Connect',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildTimer(VpnProvider vpnProvider) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1)),
      builder: (context, snapshot) {
        final duration = vpnProvider.connectionDuration;
        final minutes = duration.inMinutes.toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
        return Text(
          '$minutes:$seconds',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
