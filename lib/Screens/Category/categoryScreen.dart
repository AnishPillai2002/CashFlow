import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:money_management_app/Screens/Category/Expense/expenseScreen.dart';
import 'package:money_management_app/Screens/Category/Income/incomeScreen.dart';
import 'package:money_management_app/db/Category/categorydb.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

// Tabbar require statefull widget
class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  //Tab controller
  late TabController _tabController;

  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    //refreshing the UI on selecting Category
    Categorydb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: "Income",
              ),
              Tab(
                text: 'Expense',
              ),
            ]),

        // Expanded takes all the remaining space in the column
        Expanded(
          //TabBarView display the UI in the order of tabs,
          //the UI widgets has to be provided insided Expanded widget
          child: TabBarView(controller: _tabController, children: [
            IncomeSreen(),
            ExpenseScreen(),
          ]),
        )
      ],
    );
  }
}
