import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'register_screen.dart';
import '../../main.dart'; // Для перехода на MainAppShell

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: Добавить вызов auth_service.dart
    // if (_formKey.currentState!.validate()) {
    //   // Показываем индикатор загрузки
    //   // ... вызов API
    // }

    // --- Заглушка для перехода ---
    // После успешного входа переходим на главный экран
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainAppShell()),
    );
    // --- Конец заглушки ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.sports_basketball,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'HoopConnect',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || !value.contains('@')
                            ? 'Введите корректный email'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Пароль'),
                    obscureText: true,
                    validator: (value) => value == null || value.length < 6
                        ? 'Пароль должен быть > 6 символов'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Войти',
                    onPressed: _login,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Нет аккаунта? Зарегистрироваться',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
