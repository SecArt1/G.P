import 'package:flutter/material.dart';
import 'package:gp/StartTest.dart';
import 'package:gp/edit_profile.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0383c2),
/////////////////////////// Part 1 /////////////////////////////////
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: double.infinity,
                color: const Color(0xFF0383C2),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 170,
                          width: 25,
                        ),

                        /////////////////Avatar////////////
                        SizedBox(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Color(0xFF0078D4)),
                          ),
                        ),

                        SizedBox(
                          width: 15,
                        ),

                        /////////////////Data////////////
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                "Dr. Amira",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Age",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: 120,
                        ),

                        /////////////////Logo & Icons////////////
                        SizedBox(
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage(
                                  'assets/Logo.png',
                                ),
                                height: 40,
                                width: 90,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.notifications_active,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.question_mark_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

//////////////////////////////////// Part 2 ///////////////////////////////
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              ////////////////// Curve ////////////////
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80.0),
                ),
              ),

              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  ///////////////// Welcome Message ////////////////
                  const Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        child: Text(
                          "Hello, Dr. Amira!",
                          style: TextStyle(
                            color: Color(0xFF0383c2),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  ////////////////// Attributes (Icons) /////////////////
                  SizedBox(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle profile button tap
                            Navigator.push( context, MaterialPageRoute(builder: (context) => EditProfilePage()), );
                          },
                          child: Image.asset(
                            'assets/profile2.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle achievements button tap
                            print('Achievements button tapped');
                          },
                          child: Image.asset(
                            'assets/achieve.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle goals button tap
                            print('Goals button tapped');
                          },
                          child: Image.asset(
                            'assets/goals.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle help button tap
                            print('Help button tapped');
                          },
                          child: Image.asset(
                            'assets/help.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),

                  ////////////////// Attributes (Icons - Titles) /////////////////
                  const SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 41,
                        ),
                        Text('Profile',
                            style: TextStyle(
                              color: Color(0xff0383c2),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 52,
                        ),
                        Text('Goals',
                            style: TextStyle(
                              color: Color(0xff0383c2),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 33,
                        ),
                        Text('Achievement',
                            style: TextStyle(
                              color: Color(0xff0383c2),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 31,
                        ),
                        Text('Help',
                            style: TextStyle(
                              color: Color(0xff0383c2),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),

                  //////////////////////// Button (Start Test) /////////////////////////
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        side: const BorderSide(
                            color: Color.fromRGBO(180, 180, 181, 0.3),
                            width: 2),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SummaryPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Start Test",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff065f89),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            "assets/start_test.png",
                            width: 50,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  //////////////////////// Button (Previous Results) /////////////////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color.fromRGBO(180, 180, 181, 0.3),
                            width: 2),
                      ),
                      onPressed: () {
                        print("Previous Result Pressed");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Previous Result",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff065f89),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            "assets/prev_result.png",
                            width: 50,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}