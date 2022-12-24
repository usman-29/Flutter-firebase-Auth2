import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_project/auth.dart';
import 'package:chat_app_project/components/my_textfield.dart';
import 'package:chat_app_project/components/my_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //error message
  String? errorMsg = '';
  String? errorMessage = '';

  //to check if user in login or not
  bool isLogin = true;

  // loading circle
  void loadingCircle() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

//email controller
  final TextEditingController _emailController = TextEditingController();
  //password controller
  final TextEditingController _passwordController = TextEditingController();

  //sign in with email & password
  Future<void> signInWithEmailPassword() async {
    // loading circle
    loadingCircle();

    try {
      await Auth().signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // wrong email
      if (e.code == 'user-not-found') {
        errorMsg = 'User not found!';
      }
      // wrong password
      else if (e.code == 'wrong-password') {
        errorMsg = 'Wrong password!';
      }
      // user already exists
      else if (e.code == 'email-already-exists') {
        errorMsg = 'Email already exists!';
      }
      // other issues
      else {
        errorMsg = 'Something went wrong';
      }
      setState(() {
        errorMessage = errorMsg;
      });
    }
  }

  //create user with email & password
  Future<void> createUserWithEmailPassword() async {
    // loading circle
    loadingCircle();

    try {
      await Auth().createUserWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 30),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Visibility(
                  visible: isLogin ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: isLogin
                      ? signInWithEmailPassword
                      : createUserWithEmailPassword,
                  isLogin: isLogin,
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? 'Not a member?' : 'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? 'Register' : 'Login',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    errorMessage == '' ? '' : '$errorMessage',
                    style: const TextStyle(color: Colors.red),
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
