import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/themed_background.dart';

/// Screen 4: Settings with visual theme gallery matching the user's reference designs:
/// - Allows switching between 5 aesthetic themes (Sunset, Cosmic, Botanical, Sakura, Neon) + Classic Pastel
/// - Shows rich color palette preview dots for each theme
/// - Sound toggle & language picker
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'Türkçe';
  bool _soundEnabled = true;

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.current.isDark
              ? const Color(0xFF1E1733)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Dil Seçimi',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.current.textDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('Türkçe', '🇹🇷'),
              _buildLanguageOption('English', '🇬🇧'),
              _buildLanguageOption('日本語', '🇯🇵'),
              _buildLanguageOption('Deutsch', '🇩🇪'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String lang, String flag) {
    final isSelected = _selectedLanguage == lang;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        lang,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? AppTheme.current.primaryColor
              : AppTheme.current.textDark,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: AppTheme.current.primaryColor,
            )
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        setState(() {
          _selectedLanguage = lang;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ValueListenableBuilder<AppThemeType>(
          valueListenable: AppTheme.themeNotifier,
          builder: (context, currentType, _) {
            final isDark = AppTheme.current.isDark;

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF19122B) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tema Galerisi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.current.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Görünümü anında değiştir ♡',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.current.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.current.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${ThemeConfig.allThemes.length} Tema',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.current.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Themes List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: ThemeConfig.allThemes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final theme = ThemeConfig.allThemes[index];
                        final isSelected = currentType == theme.type;

                        return GestureDetector(
                          onTap: () {
                            AppTheme.setTheme(theme.type);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                        ? theme.primaryColor.withValues(
                                            alpha: 0.18,
                                          )
                                        : theme.scaffoldBg)
                                  : (isDark
                                        ? const Color(0xFF22193A)
                                        : const Color(0xFFF9F7FC)),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? theme.primaryColor
                                    : (isDark
                                          ? Colors.white12
                                          : Colors.grey.shade200),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: theme.primaryColor.withValues(
                                          alpha: 0.22,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                // Theme Emoji Icon
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: theme.backgroundGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    theme.emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title, description & color palette dots
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            theme.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? Colors.white
                                                  : theme.textDark,
                                            ),
                                          ),
                                          if (theme.isDark) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'Karanlık',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // Color preview dots
                                      Row(
                                        children: theme.previewColors.map((c) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              right: 6,
                                            ),
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: c,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                                width: 1.2,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkmark when selected
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.radio_button_unchecked_rounded,
                                    color: isDark
                                        ? Colors.white30
                                        : Colors.grey.shade400,
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return ThemedBackground(
          child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 4),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: config.isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: config.cardBorderColor.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: config.headerTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: config.activeNavBox,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: config.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayarlar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: config.headerTextColor,
                          ),
                        ),
                        Text(
                          'Görünüm ve tercihlerin',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: config.headerMutedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Option 1: Dil (Language)
              _buildSettingsCard(
                config: config,
                icon: Icons.g_translate_rounded,
                title: 'Dil',
                subtitle: _selectedLanguage,
                subtitleColor: config.primaryColor,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: config.textMuted,
                  size: 24,
                ),
                onTap: _showLanguageDialog,
              ),
              const SizedBox(height: 16),

              // Option 2: Tema (Theme Gallery)
              _buildSettingsCard(
                config: config,
                icon: Icons.palette_outlined,
                title: 'Tema',
                subtitle: '${config.emoji} ${config.name}',
                subtitleColor: config.primaryColor,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mini preview dot
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: config.backgroundGradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: config.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: config.textMuted,
                      size: 24,
                    ),
                  ],
                ),
                onTap: _showThemeDialog,
              ),
              const SizedBox(height: 16),

              // Option 3: Ses (Sound)
              _buildSettingsCard(
                config: config,
                icon: Icons.volume_up_outlined,
                title: 'Ses',
                subtitle: _soundEnabled ? 'Açık' : 'Kapalı',
                subtitleColor: config.textMuted,
                trailing: Switch(
                  value: _soundEnabled,
                  activeThumbColor: config.primaryColor,
                  activeTrackColor: config.primaryColor.withValues(alpha: 0.4),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  onChanged: (val) {
                    setState(() {
                      _soundEnabled = val;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _soundEnabled = !_soundEnabled;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Sweet Info Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: config.isDark
                      ? const Color(0xFF1E1635)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  boxShadow: config.cardShadow,
                  border: Border.all(color: config.cardBorderColor, width: 1.2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: config.primaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: config.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'SweetieNotes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: config.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sürüm 1.0.0 • Çoklu Estetik Tema Desteği',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: config.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ruh haline uygun temayı seç, notlarının tadını çıkar ♡',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: config.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }

  Widget _buildSettingsCard({
    required ThemeConfig config,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: config.isDark ? const Color(0xFF1E1733) : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: config.cardShadow,
          border: Border.all(color: config.cardBorderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: config.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: config.primaryColor, size: 22),
            ),
            const SizedBox(width: 16),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: config.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
        ),
      ),
    );
  }
}
