import 'package:flutter/material.dart';
import 'package:money_management_app/Models/TransactionModel/transactionModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

// Creating a global variable
const TRANSACTION_DB_NAME = 'transaction-database';

// creating abstract class with functions without implementation
abstract class TransactiondbFunctions {
  // Function returns the list of TranscationModel objects
  //Future<List<TranscationModel>> getCategories();

  // Function inserts a TranscationModel object into the database
  // since inserting require time to access the storage we use Future Keyword
  Future<void> addTransactions(TranscationModel value);

  // Function returns the list of TransactionModel objects
  Future<List<TranscationModel>> getTransactions();

  //Function to Delete a TransactionModel
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactiondbFunctions {
  //creating single ton
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  //Value notifier
  ValueNotifier<List<TranscationModel>> transactionListner = ValueNotifier([]);

  @override
  // This Function insert a Transaction Model into Hivedatabase
  Future<void> addTransactions(TranscationModel value) async {
    final _transactionDB =
        await Hive.openBox<TranscationModel>(TRANSACTION_DB_NAME);
    await _transactionDB.put(value.id, value);
  }

  @override
  // This Function returns a list of TransactionModels
  Future<List<TranscationModel>> getTransactions() async {
    final _transactionDB =
        await Hive.openBox<TranscationModel>(TRANSACTION_DB_NAME);
    return _transactionDB.values.toList();
  }

  //Function to refresh the UI after adding data into the database
  Future<void> refreshUI() async {
    final _allTransactions = await getTransactions();

    _allTransactions.sort((first, second) => second.date.compareTo(first.date));

    transactionListner.value.clear();

    transactionListner.value.addAll(_allTransactions);

    transactionListner.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _transactionDB =
        await Hive.openBox<TranscationModel>(TRANSACTION_DB_NAME);

    await _transactionDB.delete(id);
    refreshUI();
  }
}
