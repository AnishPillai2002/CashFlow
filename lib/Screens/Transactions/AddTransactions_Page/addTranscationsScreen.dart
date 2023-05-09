import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:money_management_app/Models/TransactionModel/transactionModel.dart';
import 'package:money_management_app/db/Category/categorydb.dart';
import 'package:money_management_app/db/Transaction/transactiondb.dart';

class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({super.key});

  static const String routName = "add-transactions";

  @override
  State<AddTransactionsScreen> createState() => _AddTransactionsScreenState();
}

class _AddTransactionsScreenState extends State<AddTransactionsScreen> {
  //null variables
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _selectedCategory;

  //textediting controllers
  final _purposeEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();

  //initState gets executed only once
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Purpose
            TextFormField(
              controller: _purposeEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: "Purpose",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
            //Amount
            TextFormField(
              controller: _amountEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
            //Date
            TextButton.icon(
              onPressed: () async {
                final selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now());

                //Rebuilding the Date UI based on _selectedDateTemp
                if (selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              //changing label widget based on the __selectedDate variable
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toString()),
            ),
            //Income/Expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (value) {
                          //using setstate to rebuid the UI using the value of _selectedCategoryType
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _selectedCategory = null; //to prvent error
                          });
                        }),
                    const Text("Income"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            _selectedCategory = null;
                          });
                        }),
                    const Text("Expense"),
                  ],
                ),
              ],
            ),
            //Category Type Dropdown button
            DropdownButton(
                hint: const Text("Select Category"),
                //initial value
                value: _selectedCategory,
                // showing dropdown menu based on the value of _selectedCategoryType
                items: (_selectedCategoryType == CategoryType.income
                        ? Categorydb().categoryIncomeListner
                        : Categorydb().categoryExpenseListner)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  //rebuilding UI based on value in _selectedCategory
                  setState(() {
                    _selectedCategory = selectedValue;
                  });
                }),

            //Submit button
            ElevatedButton.icon(
              onPressed: () {
                addTransaction();
                Navigator.of(context).pop();

                //refreshing the UI after adding data
                TransactionDB.instance.refreshUI();
              },
              icon: const Icon(Icons.check),
              label: const Text("Add Transaction"),
            )
          ],
        ),
      )),
    );
  }

  //function to add transaction on clicking submit
  Future<void> addTransaction() async {
    final _purpose = _purposeEditingController.text;
    final _amount = _amountEditingController.text;

    //purpose
    if (_purpose.isEmpty) {
      return;
    }
    //amount
    if (_amount.isEmpty) {
      return;
    }
    //date
    if (_selectedDate == null) {
      return;
    }

    //category Type
    if (_selectedCategoryType == null) {
      return;
    }

    //category
    if (_selectedCategory == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amount);
    if (_parsedAmount == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }

    final _model = TranscationModel(
        purpose: _purpose,
        amount: _parsedAmount,
        date: _selectedDate!,
        type: _selectedCategoryType!,
        category: _selectedCategoryModel!);

    TransactionDB.instance.addTransactions(_model);
  }
}
