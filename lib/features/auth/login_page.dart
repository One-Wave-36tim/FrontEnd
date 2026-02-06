import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/auth_repository.dart';
import 'package:flutter_application_1/features/auth/data/auth_session.dart';
import 'package:flutter_application_1/features/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.authRepository,
  });

  final AuthRepository? authRepository;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthRepository _authRepository;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AuthRepository();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitLogin() async {
    if (_isLoading) {
      return;
    }

    final id = _idController.text.trim();
    final password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      _showMessage('아이디와 비밀번호를 입력해 주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authRepository.login(id: id, pw: password);
      if (!mounted) {
        return;
      }

      _showMessage(result.message);
      if (result.success) {
        final token = result.accessToken ?? '';
        final userId = result.userId ?? '';
        if (token.isNotEmpty && userId.isNotEmpty) {
          AuthSession.setSession(accessToken: token, userId: userId);
          await Get.find<HomeController>().loadHomeData();
        }

        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (!mounted) {
          return;
        }
        context.go('/');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '로그인',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _idController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: '아이디',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              enabled: !_isLoading,
              obscureText: true,
              onSubmitted: (_) => _submitLogin(),
              decoration: InputDecoration(
                labelText: '비밀번호',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('로그인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
