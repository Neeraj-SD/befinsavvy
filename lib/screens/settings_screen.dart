import 'package:befinsavvy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () =>
            Provider.of<AuthProvider>(context, listen: false).logout(),
        child: Text('logout'),
      )),
    );
  }
}
