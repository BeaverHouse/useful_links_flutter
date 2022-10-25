import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinkWidget extends StatefulWidget {

  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const LinkWidget({super.key, required this.data});

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {

  // late MetaData? metadata;

  @override
  void initState() {
    // metadata = (await AnyLinkPreview.getMetadata(
    //   link: "https://google.com/",
    //   cache: const Duration(days: 7),
    //   proxyUrl: "https://cors-anywhere.herokuapp.com/", // Need for web
    // )) as MetaData?;
    // log(metadata.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
      padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              // child: Image.network(
              //   metadata.toString(),
              //   fit: BoxFit.fill,
              // ),
            ),
            const SizedBox(width: 16,),
            Column(children:[
             Text(widget.data["name"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
             const SizedBox(height: 5,),
             Text(widget.data["link"]),
             Text("${widget.data["visitCnt"]}번 방문"),
            ])
          ],
        ) 
      ),
    );
  }
}