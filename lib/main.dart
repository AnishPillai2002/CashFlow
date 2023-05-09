import 'package:flutter/material.dart';
import 'package:money_management_app/Models/CategoryModel/categoryModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_app/Models/TransactionModel/transactionModel.dart';

import 'package:money_management_app/Screens/HomeScreen/homescreen.dart';
import 'package:money_management_app/Screens/Transactions/AddTransactions_Page/addTranscationsScreen.dart';

Future<void> main() async {
  // checking whether all the plugins are connected to the platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // this function takes time so we make Future main()
  // await means the app do not proceed until the execution of the Hive.initFlutter()
  await Hive.initFlutter();

  // Registering the Adapters
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TranscationModelAdapter().typeId)) {
    Hive.registerAdapter(TranscationModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),

      //Named Routing
      routes: {
        // addTransaction Page
        AddTransactionsScreen.routName: (ctx) => const AddTransactionsScreen(),
      },
    );
  }
}
