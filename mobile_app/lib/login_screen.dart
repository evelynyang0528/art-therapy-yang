import 'package:flutter/material.dart';
import 'package:test2/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String passwordError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 28),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(label: Text("Email")),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(label: Text("Password")),
              ),
              if (passwordError != "")
                Text(
                  passwordError,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {

                  if (_passwordController.text.length < 8) {
                    setState(() {
                      passwordError =
                          "Your password must be more than 8 characters.";
                    });
                  } else {
                    setState(() {
                      passwordError = "";
                    });

                  }
                },
                child: Text("Login"),
              ),
              SizedBox(
                height: 50,
              ),
              Text("You don't have an account?"),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Text(
                    "Create account",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
