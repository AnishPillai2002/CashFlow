import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:money_management_app/Screens/Category/Popup/categoryAddPopUp.dart';
import 'package:money_management_app/Screens/Transactions/AddTransactions_Page/addTranscationsScreen.dart';
import 'package:money_management_app/db/Category/categorydb.dart';
import 'Widgets/bottomNavigator.dart';
import 'package:money_management_app/Screens/Category/categoryScreen.dart';
import 'package:money_management_app/Screens/Transactions/transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Setting the value Notifier
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  // List of widgets to be displayed based on the value of selectedIndexNotifier
  final _pages = const [
    Transactions(),
    CategoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 209, 223),
      appBar: AppBar(
        title: Text("MONEY MANAGER"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigator(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext cxt, int UpdatedIndex, Widget? _) {
                return _pages[UpdatedIndex];
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(AddTransactionsScreen.routName);
            print("Transaction");
          } else {
            ShowCategoryAddPopUp(context);

            // final _sample = CategoryModel(
            //     id: "1234", name: "Travel", type: CategoryType.expense);
            // Categorydb().insertCategory(_sample);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

//Note

// All the Screenpages coming in HomeScreen should not return Scaffold, since its
//not a good practice.
//ValueListenableBuilder returns the UI from the List _pages based on the value
//in the selectedIndexNotifier.
//
//FloatingActionButton will be present in the homescreen for all the widgets in _pages
//So we use if-else to check the value in the selectedIndexNotifier 
