import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:useful_links_app/utils/snackbar.dart';

class StoreProvider {
  final CollectionReference<Map<String, dynamic>> db;

  StoreProvider(this.db);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAll(String? uid) {
    return db
    .where("user", isEqualTo: uid)
    .where("isDeleted", isEqualTo: 0)
    .snapshots();
  }

  void addData (BuildContext context, String name, String link) {
    db.where("link", isEqualTo: link)
    .get().then((value) {
      if(value.docs.isNotEmpty) {
        Navigator.pop(context);
        getOkSnackbar(context, "같은 링크가 존재합니다.");
        return;
      } else {
        db.add({
          "user": FirebaseAuth.instance.currentUser?.uid,
          'name': name,
          'link': link,
          'isDeleted': 0,
          'visitCnt': 0,          
        })
        .then((value) {
          String id = value.id;
          db.doc(id).update({
            'id': id
          });
          Navigator.pop(context);
          getOkSnackbar(context, "링크가 추가되었습니다.");
        })
        .catchError((error) {
          getOkSnackbar(context, "오류: $error");
        });
      }
    });
  }
}