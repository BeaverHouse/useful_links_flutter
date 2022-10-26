import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/utils/snackbar.dart';
import 'package:useful_links_app/widgets/organisms/add_dialog.dart';
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
  late Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;

  @override
  void initState() {
    name = FirebaseAuth.instance.currentUser?.displayName;
    isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    _stream = Provider.of<StoreProvider>(context, listen: false).getAll(FirebaseAuth.instance.currentUser?.uid);
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
                _stream = Provider.of<StoreProvider>(context, listen: false).getAll(FirebaseAuth.instance.currentUser?.uid);
                getOkSnackbar(context, "새로고침 되었습니다.");
              });
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
      body: isVerified! ? LinkView(stream: _stream) : const EmailVerifyForm(),
      // body: const LinkView(),
      // body: const EmailVerifyForm(),
      floatingActionButton: isVerified! ? FloatingActionButton(
        onPressed: () async {
          return showDialog<void>(
            context: context,
            builder: ((context) => const AddDialog())
          );
        },
        child: const Icon(Icons.add),
      ) : null,  
    );
  }
}