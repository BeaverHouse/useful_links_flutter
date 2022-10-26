import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: context.watch<StoreProvider>().dataStream,
        builder: ((context, snapshot) {
          if(snapshot.hasData) {
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
      ),
    );
  }
}