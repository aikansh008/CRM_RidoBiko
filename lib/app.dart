import 'package:crm_app/Login.dart';
import 'package:crm_app/all_leads.dart';
import 'package:crm_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String KEYLOGIN = "login"; 

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.darktheme,
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data == true) {
            return const AllLeads();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    var sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(MyApp.KEYLOGIN) ?? false;
  }
}
