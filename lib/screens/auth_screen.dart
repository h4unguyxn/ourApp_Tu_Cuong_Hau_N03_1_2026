import 'package:app_do_an/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoginMode = true;
  bool _obscurePass = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool isValidPhone(String phone) {
    final regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(phone);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 14)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: const Color(0xff1a1a2e),
      ),
    );
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();

    if (phone.isEmpty || pass.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ số điện thoại và mật khẩu");
      return;
    }

    if (!isValidPhone(phone)) {
      _showMessage("Số điện thoại không hợp lệ");
      return;
    }

    final hashedPass = hashPassword(pass);

    try {
      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .where('password', isEqualTo: hashedPass)
          .get();

      if (query.docs.isNotEmpty) {
        _showMessage("Đăng nhập thành công!");

        // Chuyển sang HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(userPhone: phone),
          ),
        );
      } else {
        _showMessage("Số điện thoại hoặc mật khẩu không đúng");
      }
    } catch (e) {
      _showMessage("Lỗi đăng nhập: $e");
    }
  }

  Future<void> _register() async {
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();

    if (phone.isEmpty || pass.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ số điện thoại và mật khẩu");
      return;
    }

    if (!isValidPhone(phone)) {
      _showMessage("Số điện thoại không hợp lệ");
      return;
    }

    final hashedPass = hashPassword(pass);

    try {
      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (query.docs.isNotEmpty) {
        _showMessage("Số điện thoại này đã đăng ký");
        return;
      }

      await _firestore.collection('users').add({
        'phone': phone,
        'password': hashedPass,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showMessage("Đăng ký thành công! Đang tự động đăng nhập...");
      await _login();

      setState(() {
        _isLoginMode = true;
      });
    } catch (e) {
      _showMessage("Lỗi đăng ký: $e");
    }
  }

  void _switchMode() {
    _animController.reset();
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7f5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Logo
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff00b14f).withOpacity(0.18),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/hctfood.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title
                  Center(
                    child: Text(
                      _isLoginMode ? "Chào mừng trở lại" : "Tạo tài khoản",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1a1a2e),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      _isLoginMode
                          ? "Đăng nhập để tiếp tục đặt món"
                          : "Nhập thông tin để bắt đầu",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff8a8f9e),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Card form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Phone field
                        _buildLabel("Số điện thoại"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff1a1a2e),
                          ),
                          decoration: _inputDecoration(
                            hint: "0xxxxxxxxx",
                            icon: Icons.phone_outlined,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        _buildLabel("Mật khẩu"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passController,
                          obscureText: _obscurePass,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff1a1a2e),
                          ),
                          decoration: _inputDecoration(
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            suffix: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              child: Icon(
                                _obscurePass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: const Color(0xff8a8f9e),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Submit button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoginMode ? _login : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00b14f),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              _isLoginMode ? "Đăng nhập" : "Đăng ký",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Switch mode
                  Center(
                    child: GestureDetector(
                      onTap: _switchMode,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff8a8f9e),
                          ),
                          children: [
                            TextSpan(
                              text: _isLoginMode
                                  ? "Chưa có tài khoản? "
                                  : "Đã có tài khoản? ",
                            ),
                            TextSpan(
                              text: _isLoginMode ? "Đăng ký" : "Đăng nhập",
                              style: const TextStyle(
                                color: Color(0xff00b14f),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xff4a4f5e),
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xffbfc4ce), fontSize: 15),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xffbfc4ce)),
      suffixIcon: suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffix,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: const Color(0xfff5f7f5),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffe8eaed), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff00b14f), width: 1.8),
      ),
    );
  }
}