import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/widgets/atoms/text.dart';
import 'package:useful_links_app/widgets/molecules/link_widget.dart';

class LinkView extends StatefulWidget {
  const LinkView({super.key});

  @override
  State<LinkView> createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {

  late Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;

  @override
  void initState() {
    _stream = Provider.of<StoreProvider>(context, listen: false).getAll(FirebaseAuth.instance.currentUser?.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _stream,
        builder: ((context, snapshot) {
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const InfoText(title: "환영합니다."),
                  ...?snapshot.data?.docs.map((e) => 
                    LinkWidget(data: e)
                  )
                ],
              )
            )
          );
        })
      ),
    );
  }
}