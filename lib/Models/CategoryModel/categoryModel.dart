import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'categoryModel.g.dart';

//Enum
//Enums, or enumerated types, are a data type consisting of a set of named
//values called elements, members, numerals, or enumerators of the type.
//In essence, an enum allows a programmer to use a custom type with a restricted
//set of values instead of using an integer to represent a set of values.

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id; // for more control
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isDeleted;
  @HiveField(3)
  final CategoryType type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.isDeleted = false, // by default category is not deleted
  });

  @override
  String toString() {
    return '{$name $type}';
  }
}

//Notes
//models are just classes which help us to determine the structure of the data,
//// for eg - API responses. We all know the concept of classes
//in Object Oriented Programming, similar to that ,
// we can declare the variables, their data types and
//can write some methods to add some functionality, for eg - return sume of two numbers.



// Generating HiveAdapter
//If you want to store other objects, you have to register a 
//TypeAdapter which converts the object from and to binary form.

//1.To generate a TypeAdapter for a class, annotate it with @HiveType and provide a typeId (between 0 and 223)
//2.Annotate all fields which should be stored with @HiveField
//3.Run build task flutter packages pub run build_runner build
//4.Register the generated adapter