// ignore_for_file: use_build_context_synchronously

import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/widgets/my_button.dart';
import 'package:chatting_app/widgets/my_textfield_login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    void login(BuildContext context) async {
      final authService = AuthService();

      try {
        await authService.signInWithEmailPassword(
            emailController.text, passController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            "Selamat datang, kami merindukanmu",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 30),
          MyTextFieldLogin(
            hintText: 'Email',
            obscureText: false,
            controller: emailController,
          ),
          const SizedBox(height: 10),
          MyTextFieldLogin(
            hintText: 'Password',
            obscureText: true,
            controller: passController,
          ),
          const SizedBox(height: 20),
          MyButton(text: 'Login', onTap: () => login(context)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum bergabung? ',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  'Bergabung sekarang',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
