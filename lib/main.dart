import 'package:flutter/material.dart';
import 'package:hive_db/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("ShoppingBag");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}
