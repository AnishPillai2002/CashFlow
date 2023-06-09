import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
part 'transactionModel.g.dart';

@HiveType(typeId: 3)
class TranscationModel {
  @HiveField(0)
  final String purpose;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final CategoryModel category;

  @HiveField(5)
  String? id;

  TranscationModel(
      {required this.purpose,
      required this.amount,
      required this.date,
      required this.type,
      required this.category}) {
    //not prefered in large projects
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
