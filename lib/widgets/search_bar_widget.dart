import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';

/// Cute rounded search bar matching the theme designs:
/// - Supports theme background, border, and custom theme icon (sun, sparkle, leaf, sakura)
/// - 3-line hamburger menu icon
/// - Dynamic responsive styling
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSettingsTap;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.onMenuTap,
    this.onSettingsTap,
    this.hintText = 'Ara...',
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: config.searchBarBg,
            borderRadius: AppTheme.borderPill,
            border: Border.all(color: config.searchBarBorderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: config.isDark
                    ? config.primaryColor.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              color: config.searchBarTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                color: config.searchBarHintColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hamburger Menu
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onMenuTap,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.menu_rounded,
                            color: config.searchBarIconColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.search_rounded,
                      color: config.searchBarHintColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: config.searchBarHintColor,
                        size: 18,
                      ),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                        if (onClear != null) onClear!();
                      },
                    ),
                  Tooltip(
                    message: 'Ayarlar',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: const Key('search_bar_settings_button'),
                        borderRadius: BorderRadius.circular(20),
                        onTap: onSettingsTap,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, left: 4),
                          child: Icon(
                            Icons.settings_outlined,
                            color: config.searchBarIconColor,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        );
      },
    );
  }
}
