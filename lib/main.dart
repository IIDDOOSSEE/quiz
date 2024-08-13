import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quiz App",
            style: TextStyle(fontSize: 40, letterSpacing: 5),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: const QuizApp(),
      ),
    );
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await rootBundle.loadString('assets/question.txt');
      setState(() {
        _questions = _parseQuestions(data);
      });
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

  List<Map<String, Object>> _parseQuestions(String data) {
    final questions = <Map<String, Object>>[];
    final lines = data.split('\n').map((line) => line.trim()).toList();
    int i = 0;

    final correctAnswers = [
      'a',
      'c',
      'b',
      'b',
      'd',
      'c',
    ];

    while (i < lines.length) {
      if (lines[i].isEmpty) {
        i++;
        continue;
      }

      StringBuffer questionBuffer = StringBuffer();
      while (i < lines.length &&
          !lines[i].startsWith('a.') &&
          !lines[i].startsWith('b.') &&
          !lines[i].startsWith('c.') &&
          !lines[i].startsWith('d.')) {
        questionBuffer.writeln(lines[i]);
        i++;
      }
      final questionText = questionBuffer.toString().trim();

      final options = <String>[];
      while (i < lines.length &&
          (lines[i].startsWith('a.') ||
              lines[i].startsWith('b.') ||
              lines[i].startsWith('c.') ||
              lines[i].startsWith('d.'))) {
        options.add(lines[i].substring(3).trim());
        i++;
      }

      final correctAnswerIndex =
          ['a', 'b', 'c', 'd'].indexOf(correctAnswers[questions.length]);
      final correctAnswer =
          options.isNotEmpty ? options[correctAnswerIndex] : '';

      questions.add({
        'question': questionText,
        'options': options,
        'answer': correctAnswer,
      });

      while (i < lines.length && lines[i].isEmpty) {
        i++;
      }
    }

    return questions;
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
