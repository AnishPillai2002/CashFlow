import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:money_management_app/db/Category/categorydb.dart';
import 'package:money_management_app/db/Transaction/transactiondb.dart';
import 'package:money_management_app/Models/TransactionModel/transactionModel.dart';
//international
import 'package:intl/intl.dart';
//slidable
import 'package:flutter_slidable/flutter_slidable.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    Categorydb.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListner,
        builder: (BuildContext ctx, List<TranscationModel> newList, Widget? _) {
          return ListView.separated(
              padding: EdgeInsets.all(10.0),

              // itemBuilder builds widget on demand
              itemBuilder: (ctx, index) {
                final transaction = newList[index];

                return Slidable(
                  key: ValueKey(transaction.id),
                  startActionPane:
                      ActionPane(motion: ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance
                            .deleteTransaction(transaction.id!);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ]),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: (Text(
                          parseDate(transaction.date),
                          textAlign: TextAlign.center,
                        )),
                        backgroundColor: transaction.type == CategoryType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(transaction.purpose),
                      subtitle: Text("Rs ${transaction.amount}"),
                    ),
                  ),
                );
              },
              //separatorBuilder builds seperation widget
              separatorBuilder: (ctx, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }

  //function to parse date
  String parseDate(DateTime date) {
    final month = DateFormat.MMM().format(date);
    final day = DateFormat.d().format(date);

    return day + "\n" + month;
  }
}

/*
The ListView.separated constructor takes two IndexedWidgetBuilders: 
itemBuilder builds child items on demand, 
and separatorBuilder similarly builds separator children
which appear in between the child items. 

This constructor is appropriate for list views with a fixed number of children.

 */
