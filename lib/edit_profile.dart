import 'package:flutter/material.dart';



class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

/////////////////////// PART 1 ///////////////////////

      //AppBar with Title 
      appBar: AppBar(
        title: const Text('Edit Profile',
        style: TextStyle(
          color: Color(0xff0383c2), 
          fontSize: 22,
          fontWeight: FontWeight.bold
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

/////////////////////// PART 2 ///////////////////////
      body:
       SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [  
/////////////////////////////// Profile Avatar ///////////////////////////////
              const Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/Dr. Amira.jpg'),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Color(0XFF0383c2),
                        radius: 18,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

///////////////////////////////// Filed ////////////////////////////////           
             const SizedBox(height: 50),
             SizedBox(
                      width: 400,
                      height: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 95, 127, 154),
                          ),
                          prefixIcon: const Icon(Icons.person_rounded,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 131, 194),
                            ),
                          ),
                        ),
                      ),
                    ),

            SizedBox(
                      width: 400,
                      height: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 95, 127, 154),
                          ),
                          prefixIcon: const Icon(Icons.phone_rounded,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 131, 194),
                            ),
                          ),
                          ),
                          ),
                        ),

                    SizedBox(
                      width: 400,
                      height: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 95, 127, 154),
                          ),
                          prefixIcon: const Icon(Icons.mail_rounded,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 131, 194),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 400,
                      height: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 95, 127, 154),
                          ),
                          prefixIcon: const Icon(Icons.lock,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 131, 194),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
////////////////////////////////// Buttons ///////////////////////////////
            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                SizedBox( 
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(3, 131, 194, 1),
                          minimumSize: const Size(100, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(180, 180, 181, 0.3),
                            ),
                           ),
                         ),
                                child: const Text('Save', 
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),),
                          ),
                         ),

                SizedBox(
                  width: 150,
                    child: ElevatedButton(
                     onPressed: () {},
                     style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(3, 131, 194, 1),
                      minimumSize: const Size(100, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(180, 180, 181, 0.3),
                        ),
                       ),
                     ),
                            child: const Text('Clear', 
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            ),
                      ),
                     ), 
              ],
            ), 
            
            ],
          ),
        ),
      ),
    );
  }
}
