import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/widgets/organisms/email_verify.dart';
import 'package:useful_links_app/widgets/organisms/link_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  late bool? isVerified;
  late String? name = "???";

  @override
  void initState() {
    name = FirebaseAuth.instance.currentUser?.displayName;
    isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name님"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser?.reload();
              setState(() {
                isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
              });
              log(isVerified.toString());
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut(context);
            },
            icon: const Icon(Icons.power_settings_new),
          )
        ],
      ),
      body: isVerified! ? const LinkView() : const EmailVerifyForm(),
      // body: const LinkView(),
      // body: const EmailVerifyForm(),
      floatingActionButton: isVerified! ? FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ) : null,  
    );
  }
}