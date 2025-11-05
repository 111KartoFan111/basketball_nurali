import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сброс пароля')),
      body: const Center(
        child: Text(
          'Здесь будет форма сброса пароля',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
