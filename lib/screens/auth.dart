import 'package:acadix/widgets/authscreenWelcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _islogin = true;
  var _enteredemail = '';
  var _enteredpassword = '';
  var _enteredusername = '';
  
  void _submit() async {
  final _isValid = _form.currentState!.validate();
      _form.currentState!.save();
  if (!_isValid) {
    print("Form validation failed");
    return;
  }

  try {
    if (_islogin) {
      print("Attempting login with email $_enteredemail");
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: _enteredemail,
        password: _enteredpassword,
      );
      print("Login successful: ${userCredential.user!.uid}");
    } else {
      print("Attempting registration with email $_enteredemail");
      final userCredential = await _firebase.createUserWithEmailAndPassword(
        email: _enteredemail,
        password: _enteredpassword,
      );
      print("Registration successful: ${userCredential.user!.uid}");

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _enteredusername,
        'email': _enteredemail,
      });
      print("User added to Firestore.");
    }
  } on FirebaseAuthException catch (e) {
    print("FirebaseAuthException: ${e.code}, ${e.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'An error occurred')),
    );
  } catch (e) {
    print("General error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred: $e')),
    );
  }
}



  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Welcome(),
            Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                !value.contains('@') ||
                                value.trim().isEmpty) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredemail = value!;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 7) {
                              return 'Please enter a valid password.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredpassword = value!;
                          },
                        ),
                        const SizedBox(height: 14),
                        if (!_islogin)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid username.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredusername = value!;
                            },
                          ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  255, 255, 255, 1), // Button background color

                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 80.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),

                              elevation: 0,
                            ),
                            child: Text(
                              _islogin ? 'Login' : 'Signup',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 20),
                            ),
                          
                            // N
                          ),
                        ),
                        const SizedBox(height: 17),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 36, 35, 35),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _islogin
                                  ? 'Create a new account'
                                  : 'I already have a account',
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
