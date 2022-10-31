import 'package:fireflutter/Screens/login_screen.dart';
import 'package:fireflutter/Screens/registration_screen.dart';
import 'package:fireflutter/Widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
       //   padding: const EdgeInsets.symmetric(horizontal: 20),
       padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(  
                children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                ),
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
                 ),
              Text(
            'See what’s happening in the world right now',
              style: TextStyle(
                 fontSize: 25,
                  fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  
                  RoundedButton(
                    btnText: 'Sign In',
                    onBtnPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                    }
                  ),
                  SizedBox(height: 30,),
                  RoundedButton(
                    btnText: 'Create Account',
                    onBtnPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
                    }
                  ),

                ],
              )
            ],
          ), 
        ),
      ),
    );
  }
}