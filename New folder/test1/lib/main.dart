import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 26, 2, 80),
                Color.fromARGB(255, 83, 49, 132),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/quiz-logo.png',
                  width: 300,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Learn Flutter the fun way",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 28),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: null,
                  style: TextButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Color.fromARGB(255, 12, 5, 57)),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 28),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
