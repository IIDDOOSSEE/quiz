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
            style: TextStyle(
                fontSize: 40, letterSpacing: 5, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: const QuizApp(),
        backgroundColor: Color.fromARGB(255, 39, 61, 108),
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
  // กำหนดตัวแปร ลำดับคำถามและ คะแนน
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, Object>> _questions = [];
  @override
  // สร้างฟังก์ชันเริ่มต้น
  void initState() {
    super.initState();
    _loadQuestions();
  }

// ดึงข้อมูลจากไฟล์ question.txt และทำการแสดงผล UI ใหม่ผ่าน setState
  Future<void> _loadQuestions() async {
    try {
      final data = await rootBundle.loadString('assets/question.txt');
      setState(() {
        //เก็บค่าคำถาม ตัวเลือก และ คำตอบที่ถูกต้องไว้ในตัวแปร _questions
        _questions = _parseQuestions(data);
      });
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

// สร้างฟังก์ชันการแยกประเภทคำถาม ตัวเลือก และคำตอบ โดยจะเข้าถึงข้อมูลผ่าน key
  List<Map<String, Object>> _parseQuestions(String data) {
    final questions = <Map<String, Object>>[];
    final lines = data.split('\n').map((line) => line.trim()).toList();
    int i = 0;

    while (i < lines.length) {
      if (lines[i].isEmpty) {
        i++;
        continue;
      }

      String questionText = '';
      while (i < lines.length &&
          !lines[i].startsWith('a.') &&
          !lines[i].startsWith('b.') &&
          !lines[i].startsWith('c.') &&
          !lines[i].startsWith('d.') &&
          !lines[i].startsWith('answer:')) {
        questionText += lines[i] + '\n';
        i++;
      }
      questionText = questionText.trim();

      final options = <String>[];
      while (i < lines.length &&
          (lines[i].startsWith('a.') ||
              lines[i].startsWith('b.') ||
              lines[i].startsWith('c.') ||
              lines[i].startsWith('d.'))) {
        options.add(lines[i].substring(3).trim());
        i++;
      }
      var keyAnswer = {'a': 0, 'b': 1, 'c': 2, 'd': 3};
      String checkAnswer = '';
      String correctAnswer = '';
      if (i < lines.length && lines[i].startsWith('ans')) {
        checkAnswer = lines[i].substring(5).trim();
        for (int j = 0; j < 4; j++) {
          if (keyAnswer[checkAnswer] == j) {
            correctAnswer = options[j];
          }
        }
        i++;
      }

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

//ฟังก์ชันการนับคะแนนและเริ่มข้อต่อไป
  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }
    setState(() {
      _currentQuestionIndex++;
    });
  }

//ฟังก์ชันการเริ่มต้นทำ Quiz ใหม่
  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  // แสดงผลและตกแต่ง UI
  Widget build(BuildContext context) {
    if (_currentQuestionIndex < _questions.length) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 60),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 67, 81, 110),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _questions[_currentQuestionIndex]['question'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  (_questions[_currentQuestionIndex]['options'] as List<String>)
                      .map((option) {
                return Container(
                  height: 80, // Set a fixed height for each option button
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity, // Set a fixed width for the button
                    child: ElevatedButton(
                      onPressed: () => _answerQuestion(option),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 240, 180, 0)),
                      child: Text(option,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz Completed your score is :$_score",
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _restartQuiz(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 133, 226, 244)),
                child: const Text(
                  "Restart",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      );
    }
  }
}
