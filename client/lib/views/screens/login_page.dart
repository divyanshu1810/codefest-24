import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/login_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/bg.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/cross.png',
                  width: 55,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color(0xFF161616),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 50, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Welcome \n',
                                      style: TextStyle(
                                        color: Color(0xFF29B6F6),
                                        fontSize: 60,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Back....',
                                      style: TextStyle(
                                        color: Color(0xFFE3DAC9),
                                        fontSize: 60,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: TextField(
                    onChanged: (value) => username = value,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xE5161616),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color(0xDBE3DAC9),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: TextField(
                    onChanged: (value) => password = value,
                    style: TextStyle(color: Colors.white),
                    obscureText:true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xE5161616),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Color(0xDBE3DAC9),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: GestureDetector(
                    onTap:() async {
                      final Map<String, dynamic> responseData = await LoginServices.loginUser(
                        username,password
                      );
                      print(responseData);
                      if (responseData['success'] == true) {
                        // Login successful
                        Navigator.pushReplacementNamed(context, '/interviews');

                      } else {
                        // Login unsuccessful
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(responseData['error']),
                          ),
                        );
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,right: 30),
                child: GestureDetector(
                  onTap:() => Navigator.pushReplacementNamed(context, '/signup'),
                  child: Container(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("Not a member? Sign Up",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ]
    );
  }
}