import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String email;
  const Home({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Text('Welcome $email', style: const TextStyle(fontSize: 30),),
      ),
    );
  }
}
