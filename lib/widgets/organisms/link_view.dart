import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:useful_links_app/widgets/atoms/text.dart';
import 'package:useful_links_app/widgets/molecules/link_widget.dart';

class LinkView extends StatefulWidget {
  
  final Future<QuerySnapshot<Map<String, dynamic>>>? stream;

  const LinkView({super.key, required this.stream});
  

  @override
  State<LinkView> createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.stream,
        builder: ((context, snapshot) {
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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