import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/utils/function.dart';
import 'package:useful_links_app/utils/snackbar.dart';
import 'package:useful_links_app/widgets/atoms/confirm_dialog.dart';
import 'package:useful_links_app/widgets/atoms/upload_dialog.dart';

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
    
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.28,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 1,
            onPressed: ((context) async {
              return showDialog<void>(
                context: context,
                builder: ((context) => ConfirmDialog(
                  confirmMsg: "정말 ${widget.data["isDeleted"] == 0 ? "삭제" : "복원"}하시겠어요?", 
                  confirmFunc: () {
                    Provider.of<StoreProvider>(context, listen: false).changeDeleteData(
                      context, 
                      widget.data["id"], 
                      widget.data["isDeleted"]
                    );
                  })
                )
              );
            }),
            backgroundColor: widget.data["isDeleted"] == 0 ? const Color(0xFFFF3D00) : const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon:  widget.data["isDeleted"] == 0 ? Icons.delete : Icons.refresh,
            label: widget.data["isDeleted"] == 0 ? "삭제" : "복원",
          )
        ],
      ),
      child: Center(
        child: GestureDetector(
          onLongPress:() async {
            if (widget.data["isDeleted"] == 1) return;
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
            if (widget.data["isDeleted"] == 1) return;
            Uri uri = Uri.parse(myURL);
            if (await canLaunchUrl(uri)){
              Provider.of<StoreProvider>(context, listen: false).updateVisited(
                widget.data["id"],
                widget.data["visitCnt"]
              );
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
                      Text("${widget.data["visitCnt"]}번 방문"),
                      const SizedBox(height: 3),
                      Text("최근 업데이트 : ${
                        DateFormat.yMd("ko_KR").format((widget.data["updateTm"] as Timestamp).toDate())
                      }"),                 
                    ]
                  ),
                ),
              ],
            ) 
          )
        )
      )
    );
  }
}