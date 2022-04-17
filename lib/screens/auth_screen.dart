import 'package:befinsavvy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: provider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () =>
                        Provider.of<AuthProvider>(context, listen: false)
                            .signIn(),
                    child: const Text('Sign-in'),
                  ),
          ),
          // ElevatedButton(
          //   onPressed: () => provider.logout(),
          //   child: const Text('logout'),
          // ),
        ],
      ),
    );
  }
}
