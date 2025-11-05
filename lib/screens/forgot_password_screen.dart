import 'package:flutter/material.dart';
import '../../services/password_reset_service.dart';
import '../../widgets/custom_button.dart';
import 'reset_password_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _telegramIdController = TextEditingController();
  final _passwordResetService = PasswordResetService();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _telegramIdController.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _passwordResetService.requestPasswordReset(
        username: _usernameController.text.trim(),
        telegramId: int.parse(_telegramIdController.text.trim()),
      );

      if (!mounted) return;

      // Переход на экран ввода кода
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordCodeScreen(
            username: _usernameController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Забыли пароль?'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Иконка
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                
                const SizedBox(height: 24),
                
                // Заголовок
                const Text(
                  'Сброс пароля',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Описание
                Text(
                  'Введите ваш username и Telegram ID.\nМы отправим код для сброса пароля.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Поле Username
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Введите ваш username',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите username';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Поле Telegram ID
                TextFormField(
                  controller: _telegramIdController,
                  decoration: const InputDecoration(
                    labelText: 'Telegram ID',
                    hintText: 'Ваш Telegram ID',
                    prefixIcon: Icon(Icons.telegram),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите Telegram ID';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Telegram ID должен быть числом';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Инструкция как получить Telegram ID
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[300],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Откройте @HoopConnectBot в Telegram\nи отправьте /myid для получения ID',
                          style: TextStyle(
                            color: Colors.blue[300],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Кнопка отправки
                CustomButton(
                  text: _isLoading ? 'Отправка...' : 'Получить код',
                  onPressed: _isLoading ? null : _requestReset,
                ),
                
                const SizedBox(height: 16),
                
                // Ссылка назад
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Вернуться к входу',
                    style: TextStyle(color: Colors.grey[400]),
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