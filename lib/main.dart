import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

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
            style: TextStyle(
                fontSize: 40, letterSpacing: 5, fontWeight: FontWeight.bold),
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
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, Object>> _questions = [];
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

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentQuestionIndex < _questions.length
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      _questions[_currentQuestionIndex]['question'] as String,
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: (_questions[_currentQuestionIndex]['options']
                            as List<String>)
                        .map((option) {
                      return Container(
                        color: Color.fromARGB(255, 229, 238, 243),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(option),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 221, 252, 252)),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Quiz Completed your score is :$_score",
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () => _restartQuiz(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 133, 226, 244)),
                    child: const Text(
                      "Restart",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
  }
}
