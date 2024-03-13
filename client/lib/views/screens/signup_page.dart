import 'package:authenticheck/services/signup_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String selectedRole = 'Interviewee';
  @override
  Widget build(BuildContext context) {
    String name = '';
    String password = '';
    String email = '';
    String confirmPassword = '';
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
                child: Image.asset('assets/images/cross.png',width: 55,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color(0xFF161616),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,left: 30,right: 80,bottom: 20),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Hello \n',
                                      style: TextStyle(
                                        color: Color(0xFF29B6F6),
                                        fontSize: 60,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'There....',
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
                    onChanged: (value) => name = value,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xE5161616),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Color(0xDBE3DAC9),
                      ),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12), // Added padding
                    decoration: BoxDecoration(
                      color: Color(0xE5161616),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: DropdownButton<String>(
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('Role',style: TextStyle(color: Color(0xDBE3DAC9)),),
                      ),
                      value: selectedRole,
                      items: <String>['Interviewee','Interviewer'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Color(0xDBE3DAC9),fontSize: 15),),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Color(0xE5161616),
                      icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(), // Remove the underline
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: TextField(
                    onChanged: (value) => email = value,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xE5161616),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Color(0xDBE3DAC9))),
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
                        hintStyle: TextStyle(color: Color(0xDBE3DAC9))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: TextField(
                    onChanged: (value) => confirmPassword = value,

                    style: TextStyle(color: Colors.white),
                    obscureText:true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xE5161616),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Color(0xDBE3DAC9))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {

                      final Map<String, dynamic> responseData = await SignUpServices.signUpUser(name, email, password, selectedRole);

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
                      decoration: BoxDecoration(color: Colors.blue ,borderRadius:BorderRadius.all(Radius.circular(20)) ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                            child: Text(
                              "Sign Up",
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
                  onTap: (){
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("Already a Member? Login",
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