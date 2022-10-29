import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:useful_links_app/utils/snackbar.dart';

class StoreProvider {
  final CollectionReference<Map<String, dynamic>> db;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _dataStream  = db
    .orderBy("visitCnt", descending: true)
    .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    .where("isDeleted", isEqualTo: 0)
    .snapshots();

  StoreProvider(this.db);

  Stream<QuerySnapshot<Map<String, dynamic>>> get dataStream => _dataStream;

  void addData (BuildContext context, String name, String link) {
    db.where("link", isEqualTo: link)
    .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
          'updateTm': Timestamp.now()      
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

  void updateData (BuildContext context, String id, String name, String link) {
    db.doc(id).update({
      'name': name,
      'link': link,
    }).then((value) {
      Navigator.pop(context);
      getOkSnackbar(context, "링크가 수정되었습니다.");
    })
    .catchError((error) {
      getOkSnackbar(context, "오류: $error");
    });
  }

  void changeDeleteData (BuildContext context, String id, int isDeleted) {
    db.doc(id).update({
      'isDeleted': (isDeleted + 1) % 2,
    }).then((value) {
      Navigator.pop(context);
    })
    .catchError((error) {
      getOkSnackbar(context, "오류: $error");
    });
  }

  void updateVisited(String id, int visitCnt) {
    db.doc(id).update({
      'visitCnt': (visitCnt + 1),
      'updateTm': Timestamp.now()
    });
  }

  void changeSortData(String option) {
    Query<Map<String, dynamic>> base = db
    .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid);

    switch(option) {
      case "0":
        _dataStream = base.orderBy("visitCnt", descending: true)
        .where("isDeleted", isEqualTo: 0)
        .snapshots();
        break;
      case "1":
        _dataStream = base.orderBy("updateTm", descending: true)
        .where("isDeleted", isEqualTo: 0)
        .snapshots();
        break;        
      case "2":
        _dataStream = base.orderBy("visitCnt", descending: false)
        .where("isDeleted", isEqualTo: 0)
        .snapshots();
        break;        
      case "3":
        _dataStream = base.orderBy("updateTm", descending: false)
        .where("isDeleted", isEqualTo: 0)
        .snapshots();
        break;        
      case "4":
        _dataStream = base
        .where("isDeleted", isEqualTo: 1)
        .snapshots();
        break;
    }
  }
}