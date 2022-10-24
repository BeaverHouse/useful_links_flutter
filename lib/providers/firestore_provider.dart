import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreProvider {
  final CollectionReference<Map<String, dynamic>> db;

  StoreProvider(this.db);

  getAll(String uid) {
    db.where("user", isEqualTo: uid)
    .where("isDeleted", isEqualTo: 0)
    .get().then((value) {
      log(value.toString());  
    });
  }

  Future<void> addData (String name, String link) {
    return db.add({
          'name': name,
          'link': link,
          'isDeleted': 0,
          'visitCnt': 0,          
        })
        .then((value) {
          String id = value.id;
          db.doc(id).set({
            'id': id
          });
        })
        .catchError((error) {log("Failed: $error");});
  }
}