import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/widgets/my_button.dart';
import 'package:chatting_app/widgets/my_textfield_login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController confpassController = TextEditingController();

    void register(BuildContext context) {
      final auth = AuthService();
      if (confpassController.text == passController.text) {
        try {
          auth.signUpWithEmailPassword(
              emailController.text, passController.text);
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Password tidak sesuai'),
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
            "Mari kita buatkan akun untuk anda",
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
          const SizedBox(height: 10),
          MyTextFieldLogin(
            hintText: 'Confirm Password',
            obscureText: true,
            controller: confpassController,
          ),
          const SizedBox(height: 20),
          MyButton(
            text: 'Register',
            onTap: () => register(context),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sudah bergabung? ',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  'Masuk sekarang',
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
