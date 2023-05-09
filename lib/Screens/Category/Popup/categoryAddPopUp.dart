import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:money_management_app/db/Category/categorydb.dart';

//creating a valuenotifier for the RadioButton
ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

// creating a textEditing controller for textField
TextEditingController _textEditingController = TextEditingController();

Future<void> ShowCategoryAddPopUp(BuildContext context) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text("Add Category"),
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: "Add Category Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                )),
            //RadioButton
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: const [
                  RadioButton(title: "Income", type: CategoryType.income),
                  RadioButton(title: "Expense", type: CategoryType.expense),
                ],
              ),
            ),

            //Category Add button
            Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      //creating variables to store the category name and type
                      final _name = _textEditingController.text;
                      final _type = selectedCategory.value;
                      final _id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      //checking if the name of category is null or not
                      if (_name.isEmpty) {
                        return;
                      }
                      // creating a CategoryModel object
                      CategoryModel _category =
                          CategoryModel(id: _id, name: _name, type: _type);

                      //Creating a CategoryDB object and calling the function insertCategory()
                      Categorydb.instance.insertCategory(_category);

                      // closing the popup ofter clicking add button
                      //ctx is the context of the popup SimpleDialog
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Add")))
          ],
        );
      });
}

// creating a widget for RadioButton with text
class RadioButton extends StatefulWidget {
  final String title;
  final CategoryType type;

  const RadioButton({required this.title, required this.type});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedCategory,
        builder: (BuildContext context, CategoryType newCategory, child) {
          return Row(
            children: [
              // radio holds two values (income/expense)
              Radio<CategoryType>(
                  value: widget.type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    selectedCategory.value = value;
                    selectedCategory.notifyListeners();
                  }),
              Text(widget.title),
            ],
          );
        });
  }
}
