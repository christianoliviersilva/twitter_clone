import 'package:fireflutter/Constants/constants.dart';
import 'package:fireflutter/Services/auth_service.dart';
import 'package:fireflutter/Widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email;
  String _password;
  String _name;
  FocusNode _focusNode = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  FocusNode _focusNode3 = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTweeterColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Create Account',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/logo.png',
                  width: 70,
                  height: 70,
                ),
                Text(
                  'Create your account',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: _focusNode3,
                  //autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter your name",
                    labelStyle: TextStyle(
                        color: _focusNode3.hasFocus ? KTweeterColor : Colors.grey,
                        fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: KTweeterColor, width: 1.3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 1.1),
                    ),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  textAlign: TextAlign.start,
                  onTap: _requestFocus3,
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: _focusNode,
                  //autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter your e-mail",
                    labelStyle: TextStyle(
                        color: _focusNode.hasFocus ? KTweeterColor : Colors.grey,
                        fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: KTweeterColor, width: 1.3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 1.1),
                    ),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  textAlign: TextAlign.start,
                  onTap: _requestFocus,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: _focusNode2,
                  decoration: InputDecoration(
                    labelText: "Enter your password",
                    labelStyle: TextStyle(
                        color: _focusNode2.hasFocus ? KTweeterColor : Colors.grey,
                        fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: KTweeterColor,
                        width: 1.3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 1.1),
                    ),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  obscureText: true,
                  textAlign: TextAlign.start,
                  onTap: _requestFocus2,
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  btnText: 'Create Account',
                  onBtnPressed: () async {
                    bool isValid =
                        await AuthService.signUp(_name, _email, _password);
                    if (isValid) {
                      Navigator.pop(context);
                    } else {
                      print('algo deu errado');
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _requestFocus2() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode2);
    });
  }

  void _requestFocus3() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode3);
    });
  }
}
