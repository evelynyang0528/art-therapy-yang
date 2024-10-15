import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String userFeedbackError = "";

  bool validatePassword() {
    bool isSuccessful = false;
    if (_passwordController.text.length < 8) {
      setState(() {
        userFeedbackError = "Your password must be more than 8 characters.";
      });
    } else {
      setState(() {
        userFeedbackError = "";
      });
      isSuccessful = true;
    }

    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        userFeedbackError = "";
      });
      isSuccessful = true;
    } else {
      setState(() {
        userFeedbackError = "Your passwords are not the same.";
      });
    }

    return isSuccessful;
  }

  signup(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        print("User register ");
      }
    } on FirebaseAuthException catch (e) {
      if(e.code=="weak-password") {
        setState(() {
          userFeedbackError = "password provided is too weak";
        });
      } else if(e.code=="email-already-in-use"){
         setState(() {
           userFeedbackError = "an account already exists for this email";

         });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Signup",
              style: TextStyle(fontSize: 28),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text("Email"),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(label: Text("Password")),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(label: Text("Confirm Password")),
            ),
            if (userFeedbackError != "")
              Text(
                userFeedbackError,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                print(_emailController.text);
                print(_passwordController.text);
                print(_confirmPasswordController.text);

                bool isSuccessful = validatePassword();
                if (isSuccessful) {}
              },
              child: const Text("Sign Up"),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text("If you already have an account"),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                )),
          ],
        ),
      ),
    );
  }
}
