import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.all(32),
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signOut(context);
          },
          child: const Text('Sign out'),
        )
      ],
    ));
  }
}