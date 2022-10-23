import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/widgets/atoms/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  late bool? isVerified;
  late String? name;

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
        title: const Text("홈"),
      ),
      body: ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(name != null ? "$name님 환영합니다." : "이메일을 읽어오지 못했습니다...")
        ),        
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(isVerified! ? "이메일이 인증되었습니다." : "이메일이 인증되지 않았습니다...")
        ),
        NormalButton(
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signOut(context);
          },
          label: "로그아웃",
        )
      ],
    ));
  }
}