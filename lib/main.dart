import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: 'First App',
    home: AuthorizationRoute(),
  ));
}

class AuthorizationRoute extends StatelessWidget {
  const AuthorizationRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginRoute()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterRoute()),
                );
              },
            ),
          ]),
    );
  }
}

class LoginRoute extends StatelessWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(child: LoginForm()),
    );
  }
}

class RegisterRoute extends StatelessWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const Center(child: RegisterForm()),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<LoginFormState>.
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;

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
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                if (value.length < 3) {
                  return 'Username is too short (must be at least 3 characters)';
                }
                return null;
              }),
          TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      icon: Icon(_obscurePass
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      })),
              obscureText: _obscurePass,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 4) {
                  return 'Password is too short (must be at least 4 characters)';
                }
                return null;
              }),
          ElevatedButton(
            onPressed: () {
              var valid = _formKey.currentState!.validate();
              if (!valid) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging in...')),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    String? password;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                if (value.length < 3) {
                  return 'Username is too short (must be at least 3 characters)';
                }
                return null;
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
            onPressed: () {
              var valid = _formKey.currentState!.validate();
              if (!valid) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registering...')),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
