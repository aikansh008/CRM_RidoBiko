import 'dart:convert';
import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:crm_app/Widgets/global%20_state.dart';
import 'package:crm_app/all_leads.dart';
import 'package:crm_app/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Import provider package
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse("https://ridobiko.in/crm/mobile_app_apis/login.php"), // Replace with your server URL
      body: {
        'username': username,
        'password': password,
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    setState(() {
      _message = responseData['message'];
    });

    if (responseData['status'] == 'success') {
      var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setBool(MyApp.KEYLOGIN, true);

      // Update username in global state using Provider
      Provider.of<GlobalState>(context, listen: false).setUsername(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllLeads()),
      );
    } else {
      _showErrorDialog(_message);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool dark = HelperFunctions.isDarkMode(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          backgroundColor:
              dark ? const Color.fromARGB(255, 41, 40, 40) : ColorsApp.white2,
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Container(
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: ColorsApp.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.9; // 90% of screen width
    final double containerHeight = size.height * 0.75; // 75% of screen height
    bool dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          color:
              dark ? const Color.fromARGB(255, 42, 41, 41) : ColorsApp.white2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: Image.asset(
                      "assets/images/WhatsApp Image 2024-07-13 at 18.48.03_967f53ed.jpg"),
                ),
                const SizedBox(height: Sizes.spaceBtwtextfileds),
                Text(
                  "Hello! let's get started",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwtextfileds),
                Text(
                  "Sign in to continue.",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeMd,
                    fontWeight: FontWeight.w100,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: containerHeight * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsApp.white,
                      width: 0.1,
                    ),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      contentPadding:
                          EdgeInsets.only(left: containerWidth * 0.1),
                    ),
                  ),
                ),
                SizedBox(
                  height: containerHeight * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsApp.white,
                      width: 0.1,
                    ),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: containerWidth * 0.1),
                    ),
                    obscureText: true, // Hide password input
                  ),
                ),
                SizedBox(
                  height: containerHeight * 0.05,
                ),
                InkWell(
                  onTap: _login,
                  child: Container(
                    height: containerHeight * 0.10,
                    width: containerWidth * 0.40,
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
