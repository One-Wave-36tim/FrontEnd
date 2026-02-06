import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupIdpasswordPage extends StatefulWidget {
  const SignupIdpasswordPage({
    super.key,
    this.authRepository,
  });

  final AuthRepository? authRepository;

  @override
  State<SignupIdpasswordPage> createState() => _SignupIdpasswordPageState();
}

class _SignupIdpasswordPageState extends State<SignupIdpasswordPage> {
  late final AuthRepository _authRepository;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

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
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitSignup() async {
    if (_isLoading) {
      return;
    }

    final id = _idController.text.trim();
    final password = _passwordController.text;
    final passwordConfirm = _passwordConfirmController.text;

    if (id.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      _showMessage('아이디와 비밀번호를 모두 입력해 주세요.');
      return;
    }

    if (password != passwordConfirm) {
      _showMessage('비밀번호가 일치하지 않습니다.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authRepository.signup(id: id, pw: password);
      if (!mounted) {
        return;
      }

      _showMessage(result.message);
      if (result.success) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (!mounted) {
          return;
        }
        context.go('/login');
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
              '회원가입',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '아이디와 비밀번호를 설정해 주세요.',
              style: GoogleFonts.outfit(color: Colors.grey),
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
              decoration: InputDecoration(
                labelText: '비밀번호',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordConfirmController,
              enabled: !_isLoading,
              obscureText: true,
              onSubmitted: (_) => _submitSignup(),
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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
                    : const Text('회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
