import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:arames_project/colors/colors.dart';
import 'package:arames_project/dashbord/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _formKey = GlobalKey<FormState>();
  TextEditingController matriculecontroller = TextEditingController();
  TextEditingController motDePassecontroller = TextEditingController();
  bool _isPasswordVisible = false;

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

  Future<void> _login1() async {
    if (matriculecontroller.text.isEmpty || motDePassecontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.105:3000/api/v1/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'matricule': matriculecontroller.text,
          'motDePasse': motDePassecontroller.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        final responseData = json.decode(response.body);

        if (responseData['user'] != null &&
            responseData['user']['matricule'] == matriculecontroller.text) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Identifiants incorrects')),
          );
        }
      } else {
        print('Error: ${response.statusCode}, Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur serveur (${response.statusCode}) : ${response.body}')),
        );
      }
    } catch (e) {
      print('Network error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: ${e.toString()}')),
      );
    }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                          'Bienvenu dans l\'ère digitale 4.0 avec ARAMES'),
                      const SizedBox(height: 20),
                      TextField(
                        controller: matriculecontroller,
                        focusNode: _usernameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Identifiant *',
                          labelStyle: TextStyle(color: _usernameLabelColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.yellow, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: motDePassecontroller,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe *',
                          labelStyle: TextStyle(color: _passwordLabelColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.yellow, width: 2),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              )),
                        ),
                        obscureText: !_isPasswordVisible, // Hide password
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: green1,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            String matricule = matriculecontroller.text.trim();
                            String motDePasse =
                                motDePassecontroller.text.trim();

                            // Vérification si les champs sont vides
                            if (matricule.isEmpty || motDePasse.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Veuillez remplir tous les champs.')),
                              );
                              return;
                            }

                            // Conversion des champs en nombres
                            int? matriculeInt = int.tryParse(matricule);
                            int? motDePasseInt = int.tryParse(motDePasse);

                            if (matriculeInt == 9898 && motDePasseInt == 1234) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Identifiant ou mot de passe incorrect.')),
                              );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
