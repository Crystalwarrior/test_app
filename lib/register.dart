import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

// Create a Form widget.
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<RegisterFormState>.
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;
  bool _obscurePassRepeat = true;

  String password = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Email';
                }
                if (value.length < 3) {
                  return 'Email is too short (must be at least 3 characters)';
                }
                return null;
              },
              onChanged: (value) {
                email = value;
              }),
          TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
                suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePass ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePass = !_obscurePass;
                      });
                    }),
              ),
              obscureText: _obscurePass,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 4) {
                  return 'Password is too short (must be at least 4 characters)';
                }
                return null;
              },
              onChanged: (value) {
                password = value;
              }),
          TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Repeat Password',
                suffixIcon: IconButton(
                    icon: Icon(_obscurePassRepeat
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassRepeat = !_obscurePassRepeat;
                      });
                    }),
              ),
              obscureText: _obscurePassRepeat,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please repeat your password';
                }
                if (value.length < 4) {
                  return 'Password is too short (must be at least 4 characters)';
                }
                if (value != password) {
                  return 'Does not match password';
                }
                return null;
              }),
          ElevatedButton(
            onPressed: () async {
              var valid = _formKey.currentState!.validate();
              if (!valid) {
                return;
              }
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registering...')),
              );
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Success! Welcome to my app.')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeRoute()),
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('The password provided is too weak.')),
                  );
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('The account already exists for that email.')),
                  );
                } else if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('That email is invalid.')),
                  );
                }
              } catch (e) {
                return;
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
