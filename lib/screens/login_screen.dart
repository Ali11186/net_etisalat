import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final ApiService _api = ApiService();

  bool otpSent = false;
  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _message('أدخل رقم الهاتف أولاً');
      return;
    }

    setState(() => loading = true);

    try {
      await _api.sendOtp(phone);

      if (!mounted) return;

      setState(() {
        otpSent = true;
      });

      _message('تم إرسال رمز التحقق');
    } catch (e) {
      if (!mounted) return;
      _message(_cleanError(e));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final code = otpController.text.trim();

    if (phone.isEmpty) {
      _message('أدخل رقم الهاتف');
      return;
    }

    if (code.isEmpty) {
      _message('أدخل رمز التحقق');
      return;
    }

    setState(() => loading = true);

    try {
      final result = await _api.verifyOtp(
        phone: phone,
        code: code,
      );

      if (!mounted) return;

      final provider = context.read<UserProvider>();

      await provider.login(phone);

      debugPrint('Login response: $result');

      _message('تم تسجيل الدخول بنجاح');

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _message(_cleanError(e));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  String _cleanError(Object error) {
    final text = error.toString();

    if (text.startsWith('Exception: ')) {
      return text.substring(11);
    }

    return text;
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  size: 42,
                  color: Color(0xFF00E676),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'أدخل رقم الهاتف للمتابعة',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '01XXXXXXXXX',
                  prefixIcon: const Icon(
                    Icons.phone_android_rounded,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: loading ? null : sendOtp,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('إرسال رمز التحقق'),
                ),
              ),

              if (otpSent) ...[
                const SizedBox(height: 30),

                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: 'رمز التحقق',
                    hintText: 'OTP',
                    prefixIcon: const Icon(
                      Icons.password_rounded,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: loading ? null : verifyOtp,
                    icon: const Icon(
                      Icons.verified_user_rounded,
                    ),
                    label: const Text(
                      'تحقق وتسجيل الدخول',
                    ),
                  ),
                ),
              ],

              if (loading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
