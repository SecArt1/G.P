import 'package:flutter/material.dart';
import 'package:gp/logInPage.dart';
import 'package:gp/register.dart';
import 'package:gp/stillStart.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  DraggableScrollableController _controller = DraggableScrollableController();
  var activeScreen = 'Home Page';

  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSwipe);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSwipe);
    _controller.dispose();
    super.dispose();
  }

  void _onSwipe() {
    final size = _controller.size;
    // Perform your action based on the size of the sheet
    if (size > 0.1) {
      Navigator.push( context, MaterialPageRoute(builder: (context) => HomePage()), );
      print("Sheet swiped up, size: $size");
    } else {
      print("Sheet swiped down, size: $size");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0383c2),
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/Logo.png'),
          ),
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: const Color(0xff0383c2),
                child: ListView(
                  controller: scrollController,
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                            SizedBox(height: 10),
                            
                            // Additional content can be added here
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
