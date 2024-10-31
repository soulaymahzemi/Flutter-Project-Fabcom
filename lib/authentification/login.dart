import 'package:arames_project/dashbord/homepage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Color _usernameLabelColor = Colors.grey;
  Color _passwordLabelColor = Colors.grey;
  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {
        _usernameLabelColor =
            _usernameFocusNode.hasFocus ? Colors.yellow : Colors.grey;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _passwordLabelColor =
            _passwordFocusNode.hasFocus ? Colors.yellow : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text('Bienvenu dans l\'ère digitale 4.0 avec ARAMES'),
                    SizedBox(height: 20),
                    TextField(
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Identifiant *',
                        labelStyle: TextStyle(color: _usernameLabelColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe *',
                        labelStyle: TextStyle(color: _passwordLabelColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2),
                        ),
                      ),
                      obscureText: true, // Hide password input
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        },
                        child: Text(
                          'LOG IN',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
