import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page2.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/sign_up/ui/w1_page.dart';
import 'hive/hive_service.dart'; // Import your Hive service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  HiveService hiveService = HiveService();
  try {
    await hiveService.initHive();

    // Check if the API URL already exists in Hive
    final existingApiUrl = await hiveService.getApiUrl();
    if (existingApiUrl == null) {
      // Store the API URL in Hive for signup
      await hiveService.saveApiData('http://52.66.24.172:7001/frontend/Guests/login', ''); // Replace with your actual signup URL
    }

    // Check if the OTP API URL already exists in Hive
    final existingOtpApiUrl = await hiveService.getOtpApiUrl();
    if (existingOtpApiUrl == null) {
      // Store the OTP API URL in Hive
      await hiveService.saveOtpApiUrl('http://52.66.24.172:7001/frontend/Guests/ValidateOTP'); // Replace with your actual OTP validation URL
    }
  } catch (e) {
    print('Error initializing Hive: $e');
    // Handle error - e.g., show an error screen
    runApp(ErrorApp()); // Example error screen
    return;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astrology App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: W1Page(), // Set W1Page as the home page
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/horoscope': (context) => HoroscopePage(),
        '/compatibility': (context) => CompatibilityPage(),
        '/auspiciousTime': (context) => AuspiciousTimePage(),
        '/w1': (context) => W1Page(),
        '/mainlogo': (context) => MainLogoPage(),
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      home: Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Failed to initialize the app.')),
      ),
    );
  }
}
