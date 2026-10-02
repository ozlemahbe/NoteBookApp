import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';

/// Cute notebook cover widget matching Sketch 2:
/// - Left-side accent spine simulating a realistic journal book
/// - Center cute icon (e.g. heart, star, flower)
/// - Title displayed at bottom (e.g. "Happy Notes")
/// - Floating "Antigravity" effect
class NotebookCoverWidget extends StatelessWidget {
  final NotebookModel notebook;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool compact;

  const NotebookCoverWidget({
    super.key,
    required this.notebook,
    this.onTap,
    this.isSelected = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? AppTheme.lavenderGlowShadow
              : AppTheme.antigravityShadow,
          border: isSelected
              ? Border.all(color: AppTheme.primaryLavender, width: 2.5)
              : Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: notebook.coverColor,
            child: Row(
              children: [
                // Book Spine Simulation (left-side accent strip)
                Container(
                  width: compact ? 14 : 20,
                  decoration: BoxDecoration(
                    color: notebook.spineColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      compact ? 3 : 5,
                      (index) => Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Cover Center Content & Title
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 8 : 12,
                      vertical: compact ? 8 : 14,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // Center Cute Icon with soft glow container
                        Container(
                          padding: EdgeInsets.all(compact ? 8 : 14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.85),
                            boxShadow: [
                              BoxShadow(
                                color: notebook.spineColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            notebook.icon,
                            size: compact ? 22 : 34,
                            color: notebook.spineColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Notebook Title (e.g. "Happy Notes" like in Sketch 2)
                        Text(
                          notebook.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 12 : 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            height: 1.2,
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Page count or ribbon accent at bottom
                        if (!compact)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_stories_outlined,
                                size: 12,
                                color: AppTheme.textMuted.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${notebook.pageCount} sayfa',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textMuted.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Page edge layer on right (mimics closed paper block)
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6EE),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 2,
                        offset: const Offset(-1, 0),
                      ),
                    ],
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
