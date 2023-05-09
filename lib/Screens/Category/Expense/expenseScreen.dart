import 'package:flutter/material.dart';
import 'package:money_management_app/db/Category/categorydb.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //it listen to categoryExpenseListner
    return ValueListenableBuilder(
        valueListenable: Categorydb().categoryExpenseListner,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              padding: EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final category = newList[index];

                return Card(
                  elevation: 0,
                  child: ListTile(
                    //leading: Text(),
                    title: Text(category.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Categorydb().deleteCategory(category.id);
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }
}
