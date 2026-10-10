import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';

/// Item metadata for the custom FloatingBottomBar
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Custom Bottom Navigation Bar matching all user specifications & themes:
/// - "Saydam" (translucent / frosted glass effect via BackdropFilter)
/// - Floating container above bottom edge
/// - Active item enclosed in rounded box filled with theme-specific active color
/// - Theme-reactive styling and glow
class FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<NavItem> _items = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Ana Sayfa',
    ),
    NavItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder_rounded,
      label: 'Belgeler',
    ),
    NavItem(
      icon: Icons.auto_stories_outlined,
      activeIcon: Icons.auto_stories_rounded,
      label: 'Defterler',
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Ayarlar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          height: 66,
          decoration: BoxDecoration(
            color: config.navBarBg.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: config.isDark
                    ? config.primaryColor.withValues(alpha: 0.25)
                    : const Color(0xFF8F7193).withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: config.isDark ? 0.4 : 0.04,
                ),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: config.navBarBorderColor, width: 1.4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_items.length, (index) {
                    final item = _items[index];
                    final isSelected = currentIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? config.activeNavBox
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: config.activeNavBorder,
                                  width: 1.2,
                                )
                              : null,
                          boxShadow: isSelected && config.isDark
                              ? [
                                  BoxShadow(
                                    color: config.primaryColor.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 22,
                              color: isSelected
                                  ? config.activeNavIcon
                                  : config.inactiveNavIcon,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? config.activeNavIcon
                                    : config.inactiveNavIcon,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
