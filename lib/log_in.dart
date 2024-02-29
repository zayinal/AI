import 'package:cotton_prediction/my_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_up.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const id = 'login';

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final FirebaseAuth auth = FirebaseAuth.instance;

    void signInWithEmailAndPassword(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        try {
          await auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // Navigate to home page or do whatever you want after successful login
          Navigator.pushNamed(context, MyHomePage.id);
        } on FirebaseAuthException catch (e) {
          // Handle FirebaseAuthException errors here
          print(e.code); // You can access the error code
        } catch (e) {
          // Handle other errors here
          print(e.toString());
        }
      }
    }

    void goToSignUpPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => signInWithEmailAndPassword(context),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: goToSignUpPage,
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
