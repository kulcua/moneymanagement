import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:moneymangement/models/transaction_model.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/utilities/constants.dart';

class DatabaseService {

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static void updateUser(User user) {
    print('user idddd ${user.id}');
    usersRef.document(user.id).updateData({
      'name': user.name,
      'money': user.money,
      'pin': user.pin,
    });
  }

  static void createTransactionSender(TransactionModel trans) {
    // Add user to current user's following collection
    transactionsRef.document(trans.idSender).collection('userTrans').add({
      'idSender': trans.idSender,
      'idReceiver': trans.idReceiver,
      'state': trans.state,
      'money': trans.money,
      'time': trans.time,
      'typeTransaction': trans.typeTransaction,
    });
  }

  static void createTransactionReceiver(TransactionModel trans) {
    // Add user to current user's following collection
    transactionsRef.document(trans.idReceiver).collection('userTrans').add({
      'idSender': trans.idSender,
      'idReceiver': trans.idReceiver,
      'state': trans.state,
      'money': trans.money,
      'time': trans.time,
      'typeTransaction': trans.typeTransaction,
    });
  }

  //get user transaction
  static Future<List<TransactionModel>> getUserTrans(String userId) async {
    QuerySnapshot userTransSnapshot = await transactionsRef
        .document(userId)
        .collection('userTrans')
        .orderBy('time', descending: true).getDocuments();

    List<TransactionModel> trans =
    userTransSnapshot.documents.map((doc) => TransactionModel.fromDoc(doc)).toList();
    return trans;
  }

  static Stream<TransactionModel> getTranStream(String tranId, User user) {
    return transactionsRef
        .document(user.id)
        .collection('userTrans')
        .document(tranId)
        .snapshots()
        .map((snapshot) => TransactionModel.fromDoc(snapshot));
  }
}




