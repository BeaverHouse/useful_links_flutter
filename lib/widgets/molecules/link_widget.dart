import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:useful_links_app/utils/function.dart';
import 'package:useful_links_app/utils/snackbar.dart';
import 'package:useful_links_app/widgets/organisms/upload_dialog.dart';

class LinkWidget extends StatefulWidget {

  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const LinkWidget({super.key, required this.data});

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {

  Future<String?> setMeta() async {
    String? myURL = parseUrl(widget.data["link"]);
    
    var data = await MetadataFetch.extract(myURL);
    if( data != null) {
      if (data.image == null) return null;
      return data.image!.startsWith("http") ? data.image : null;
    } 
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String? myURL = parseUrl(widget.data["link"]);
    
    return Center(
        child: GestureDetector(
        onLongPress:() async {
          return showDialog<void>(
            context: context,
            builder: ((context) => UpdateDialog(
              id: widget.data["id"],
              link: widget.data["link"],
              name: widget.data["name"],
            ))
          );
        },
        onTap: () async {
          log("tapped");
          Uri uri = Uri.parse(myURL);
          if (await canLaunchUrl(uri)){
              await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
          } else {
              getOkSnackbar(context, "링크를 열지 못했습니다.");
          }
        },
        child: Container(
          width: width-30,
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: FutureBuilder(
                  future: setMeta(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData == false) {
                      return Image.asset("assets/images/empty.png");
                    }
                    return FadeInImage.assetNetwork(
                      placeholder: 'assets/images/empty.png',
                      image: snapshot.data ?? ""
                    );
                  }),
                ), 
              ),              
              const SizedBox(width: 15,),
              SizedBox(
                  width: width - 140,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      widget.data["name"], 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.data["link"],
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 3),              
                    Text("${widget.data["visitCnt"]}번 방문")     
                  ]
                ),
              ),
            ],
          ) 
        )
      )
    );
  }
}