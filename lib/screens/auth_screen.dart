import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// "Pastel Defter" Login and Registration Screen
/// Exactly matching the reference image provided by the user:
/// - Circular pink badge with cute book icon
/// - "Pastel Defter" title & sweet subtitle
/// - White rounded card with soft shadows:
///   - "Giriş yap" / "Kayıt ol" segmented toggle pill
///   - "E-posta" input with hint "ornek@mail.com"
///   - "Şifre" input with hint "En az 6 karakter"
///   - Soft rose-pink submit button
///   - Quick Google (Gmail) sign-in button
/// - Footer: "Aynı e-posta ile tekrar giriş yaptığında bütün notların geri gelir."
class AuthScreen extends StatefulWidget {
  final UserModel? currentUser;
  final Function(UserModel) onLoginSuccess;
  final VoidCallback onLogout;

  const AuthScreen({
    super.key,
    this.currentUser,
    required this.onLoginSuccess,
    required this.onLogout,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // 0: Giriş yap, 1: Kayıt ol
  int _activeTab = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentUser != null) {
      _emailController.text = widget.currentUser!.email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleFormSubmit() async {
    setState(() {
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen e-posta adresinizi girin.';
      });
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage =
            'Geçerli bir e-posta adresi yazın (örn: isim@gmail.com)';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Şifre en az 6 karakter olmalıdır.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel user;
      if (_activeTab == 0) {
        // Giriş yap
        user = await AuthService().signInWithEmail(email, password);
      } else {
        // Kayıt ol
        user = await AuthService().signUpWithEmail(email, password);
      }

      if (!mounted) return;
      widget.onLoginSuccess(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _activeTab == 0
                    ? 'Giriş başarılı! Hoş geldin ♡'
                    : 'Hesabın oluşturuldu ve giriş yapıldı ♡',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppTheme.deepLavender,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AuthService.getReadableErrorMessage(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final user = await AuthService().signInWithGoogle();

      if (!mounted) return;
      widget.onLoginSuccess(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${user.email} ile giriş yapıldı ♡'),
            ],
          ),
          backgroundColor: AppTheme.deepLavender,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AuthService.getReadableErrorMessage(e);
      });
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
    final isLoggedIn =
        widget.currentUser != null && widget.currentUser!.isLoggedIn;

    return Scaffold(
      backgroundColor: const Color(
        0xFFFDF7F8,
      ), // Very soft creamy-pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              color: AppTheme.textDark,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: isLoggedIn ? _buildLoggedInView() : _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  /// View shown when user is already logged in
  Widget _buildLoggedInView() {
    final user = widget.currentUser!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top Icon Badge matching Photo 1
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFFF7CCD3), // Soft pastel rose
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: 38,
              color: Color(0xFF4A344E), // Soft deep plum book
            ),
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'Ahbe Notes',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3F2B32),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),

        const Text(
          'Notların ve defterlerin hesabında saklanıyor ♡',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF8A7980),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),

        // Active Account Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF907284).withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: const Color(0xFFF6E8EA), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: AppTheme.deepLavender,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F2B32),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_done_rounded,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hesap Aktif & Senkronize',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFF4B8C1),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () async {
                    await AuthService().signOut();
                    widget.onLogout();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Hesaptan çıkış yapıldı'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: Color(0xFFC04B67),
                  ),
                  label: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      color: Color(0xFFC04B67),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Main Login & Registration form matching Photo 1 exactly
  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. Top Icon Badge: circular soft pink badge with purple notebook icon
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFFF7CCD3), // Soft pink badge
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: 38,
              color: Color(0xFF4A344E), // Dark purple book
            ),
          ),
        ),
        const SizedBox(height: 18),

        // 2. Title: "Pastel Defter"
        const Text(
          'Ahbe Notes',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3F2B32),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),

        // 3. Subtitle: "Notların ve defterlerin hesabında saklanır, hiçbir şey kaybolmaz."
        const Text(
          'Notların ve defterlerin hesabında saklanır, hiçbir şey kaybolmaz.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF8A7980),
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 24),

        // 4. White Card Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF907284).withValues(alpha: 0.08),
                blurRadius: 26,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: const Color(0xFFF6E8EA), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented toggle pill: "Giriş yap" vs "Kayıt ol"
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFDECEF,
                  ), // Light pinkish pill background
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeTab = 0;
                            _errorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            color: _activeTab == 0
                                ? const Color(
                                    0xFFF4B8C1,
                                  ) // Active solid soft pink
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Giriş yap',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: _activeTab == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _activeTab == 0
                                  ? const Color(0xFF3F2B32)
                                  : const Color(0xFF8A7980),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeTab = 1;
                            _errorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            color: _activeTab == 1
                                ? const Color(
                                    0xFFF4B8C1,
                                  ) // Active solid soft pink
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Kayıt ol',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: _activeTab == 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _activeTab == 1
                                  ? const Color(0xFF3F2B32)
                                  : const Color(0xFF8A7980),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Error banner if any
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Label: "E-posta"
              const Text(
                'E-posta',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F2B32),
                ),
              ),
              const SizedBox(height: 8),

              // Input: "ornek@mail.com"
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFEADADC),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F2B32),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ornek@mail.com',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0A2A7),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Label: "Şifre"
              const Text(
                'Şifre',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F2B32),
                ),
              ),
              const SizedBox(height: 8),

              // Input: "En az 6 karakter"
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFEADADC),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F2B32),
                  ),
                  decoration: InputDecoration(
                    hintText: 'En az 6 karakter',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0A2A7),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: const Color(0xFF9E8E94),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action button: "Giriş yap" / "Kayıt ol"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFF4B8C1,
                    ), // Soft rose pink pill
                    foregroundColor: const Color(0xFF3F2B32),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleFormSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF3F2B32),
                            ),
                          ),
                        )
                      : Text(
                          _activeTab == 0 ? 'Giriş yap' : 'Kayıt ol',
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Google (Gmail) Sign-in button
              Center(
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mail_lock_rounded,
                      size: 18,
                      color: Color(0xFFEA4335), // Google Red
                    ),
                  ),
                  label: const Text(
                    'Google (Gmail) ile Devam Et',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A444C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 5. Footer text: "Aynı e-posta ile tekrar giriş yaptığında bütün notların geri gelir."
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Aynı e-posta ile tekrar giriş yaptığında bütün notların geri gelir.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF918288),
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
