// Here we have defined functions to insert, delete and get Categories in the app
import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Creating a global variable
const CATEGORY_DB_NAME = 'category-database';

// creating abstract class with functions without implementation
abstract class CategorydbFunctions {
  // Function returns the list of CategoryModel objects
  Future<List<CategoryModel>> getCategories();

  // Function inserts a CategoryModel object into the database
  // since inserting require time to access the storage we use Future Keyword
  Future<void> insertCategory(CategoryModel value);

  // Function to delete a CategoryModel object
  Future<void> deleteCategory(String Categoryid);
}

// creating a class to implement the Functions
class Categorydb extends CategorydbFunctions {
  //creating singleton object
  Categorydb._internal();
  static Categorydb instance = Categorydb._internal();

  factory Categorydb() {
    return instance;
  }

  // creating listners for the Categorydb objects
  ValueNotifier<List<CategoryModel>> categoryIncomeListner = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> categoryExpenseListner = ValueNotifier([]);
//Note
// All the widgets listneing to the above two listners will get refreshed by refreshUI

  @override
  // This Function insert a CategoryModel into Hivedatabase
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.put(value.id, value);

    //refreshing the UI after adding data
    refreshUI();
  }

  @override
  // This Function returns a list of CategoryModel
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  //Function to refresh the UI after adding data into the database
  // all the widgets listning to the _categoryIncomeListner and _categoryExpenseListner
  // will get updated
  Future<void> refreshUI() async {
    final _allCategories = await getCategories();

    //clearing the values of listner list to avoid duplication
    categoryIncomeListner.value.clear();
    categoryExpenseListner.value.clear();

    //iterating over each CategoryModel in the List of CategoryModel
    await Future.forEach(_allCategories, (CategoryModel category) {
      // category type ==income
      if (category.type == CategoryType.income) {
        categoryIncomeListner.value.add(category);
      } else {
        categoryExpenseListner.value.add(category);
      }
    });
    // Notifying
    categoryIncomeListner.notifyListeners();
    categoryExpenseListner.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String Categoryid) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);

    _categoryDB.delete(Categoryid);
    refreshUI();
  }
}
