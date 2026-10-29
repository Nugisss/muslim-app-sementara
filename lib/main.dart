import 'package:flutter/material.dart';
import 'package:muslim_app/presentation/screens/dashboard_screen.dart';
import 'package:muslim_app/presentation/screens/doa_screen.dart';
import 'package:muslim_app/presentation/screens/jadwal_sholat_screen.dart';
import 'package:muslim_app/presentation/screens/video_kajian_screen.dart';
import 'package:muslim_app/presentation/screens/zakat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const DashboardScreen(),
        '/doa': (context) => const DoaScreen(),
        '/zakat': (context) => const ZakatScreen(),
        '/jadwal-sholat': (context) => const JadwalSholatScreen(),
        '/video-kajian': (context) => const VideoKajianScreen(),
      },
    );
  }
}

