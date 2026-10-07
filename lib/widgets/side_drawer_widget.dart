import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

/// Side drawer matching Sketch 2:
/// - Opens from left when tapping the 3-line hamburger menu
/// - Curved right border (BorderRadius.horizontal(right: Radius.circular(32)))
/// - Top header with avatar & app logo
/// - "👤 Hesap" menu item to open Pastel Defter login/account screen
class SideDrawerWidget extends StatelessWidget {
  final UserModel? currentUser;
  final int noteCount;
  final int notebookCount;
  final int deletedNotesCount;
  final VoidCallback onOpenAccount;
  final VoidCallback onOpenTrash;
  final VoidCallback onLogout;

  const SideDrawerWidget({
    super.key,
    this.currentUser,
    required this.noteCount,
    required this.notebookCount,
    this.deletedNotesCount = 0,
    required this.onOpenAccount,
    required this.onOpenTrash,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = currentUser != null && currentUser!.isLoggedIn;

    return Drawer(
      width: 290,
      // Curved right boundary matching hand-drawn sketch 2
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      backgroundColor: const Color(0xFFFDF8F9), // Soft creamy-pink drawer bg
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drawer Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7CCD3), // Soft pink badge
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 24,
                            color: Color(0xFF4A344E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ahb Notes',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF3F2B32),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isLoggedIn
                                  ? 'Bulut Senkronize'
                                  : 'Çevrimdışı Mod',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: isLoggedIn
                                    ? Colors.green.shade700
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Color(0xFFEFE1E4), thickness: 1),
                ],
              ),
            ),

            // "👤 Hesap" Menu Item matching Sketch 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onOpenAccount,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF8F7193,
                          ).withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFF4E2E6),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_rounded, // 👤 Hesap icon
                            color: Color(0xFF4A344E),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hesap',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3F2B32),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isLoggedIn
                                    ? currentUser!.email
                                    : 'Giriş yap veya kayıt ol',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: isLoggedIn
                                      ? AppTheme.deepLavender
                                      : const Color(0xFF918288),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF918288),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // "🗑️ Çöp Kutusu" Menu Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onOpenTrash,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF8F7193,
                          ).withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFF4E2E6),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_delete_outlined,
                            color: Color(0xFFC04B67),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Çöp Kutusu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3F2B32),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                deletedNotesCount > 0
                                    ? '$deletedNotesCount silinen not'
                                    : 'Boş ♡',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: deletedNotesCount > 0
                                      ? const Color(0xFFC04B67)
                                      : const Color(0xFF918288),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (deletedNotesCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC04B67).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$deletedNotesCount',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC04B67),
                              ),
                            ),
                          ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF918288),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Quick Stats Card (Notlarım & Defterlerim)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFF4E2E6),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$noteCount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3F2B32),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Klasik Not',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: const Color(0xFFEFE1E4),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$notebookCount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3F2B32),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Not Defteri',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Footer / Logout if logged in
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFC04B67),
                    size: 20,
                  ),
                  title: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC04B67),
                    ),
                  ),
                  onTap: onLogout,
                ),
              ),

            // Bottom brand note
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Text(
                'SweetieNotes • Pastel Defter v1.0\nHuzurlu notlar al ♡',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFFA5969C),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
