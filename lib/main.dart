import 'package:crm_app/Widgets/global%20_state.dart';
import 'package:crm_app/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState()..loadUsernameFromPrefs(),
      child: MyApp(),
    ),
  );
}