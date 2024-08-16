import 'package:flutter/material.dart';
import 'QuizApp.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quiz App",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 44, 54, 72),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Color.fromARGB(255, 39, 61, 108),
              child: const QuizApp(),
            );
          },
        ),
      ),
    );
  }
}
