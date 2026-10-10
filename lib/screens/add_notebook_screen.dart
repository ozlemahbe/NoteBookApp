import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/notebook_cover_widget.dart';
import '../widgets/themed_background.dart';

/// Screen: "Not defteri Ekle" (Add Notebook):
/// - Header with back arrow, title, check button
/// - "Başlık" text input field
/// - Selectable cover designs grid with rich organic covers
/// - Live preview of the notebook being designed
class AddNotebookScreen extends StatefulWidget {
  const AddNotebookScreen({super.key});

  @override
  State<AddNotebookScreen> createState() => _AddNotebookScreenState();
}

class _AddNotebookScreenState extends State<AddNotebookScreen> {
  final TextEditingController _titleController = TextEditingController();
  int _selectedPresetIndex = 0;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveNotebook() {
    final title = _titleController.text.trim();
    final preset = NotebookCoverDesign.presets[_selectedPresetIndex];

    final newNotebook = NotebookModel(
      id: 'nb_${DateTime.now().millisecondsSinceEpoch}',
      title: title.isEmpty ? 'Yeni Defterim ♡' : title,
      coverColor: preset.coverColor,
      accentColor: preset.accentColor,
      spineColor: preset.spineColor,
      spinePattern: preset.spinePattern,
      icon: preset.icon,
      iconColor: preset.iconColor,
      createdAt: DateTime.now(),
      pageCount: 0,
    );

    final config = AppTheme.current;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: config.fabIconColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'Not defteri oluşturuldu ♡',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: config.accentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      ),
    );

    Navigator.of(context).pop(newNotebook);
  }

  @override
  Widget build(BuildContext context) {
    final activePreset = NotebookCoverDesign.presets[_selectedPresetIndex];
    final previewTitle = _titleController.text.trim().isEmpty
        ? 'Happy Notes ♡'
        : _titleController.text.trim();

    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return Scaffold(
          backgroundColor: config.scaffoldBg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: config.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white,
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
                  color: config.textDark,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            title: Text(
              'Not defteri Ekle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: config.headerTextColor,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: config.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.check_rounded, color: config.primaryColor),
                    onPressed: _saveNotebook,
                  ),
                ),
              ),
            ],
          ),
          body: ThemedBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live Preview Section
                    Center(
                      child: SizedBox(
                        width: 140,
                        height: 190,
                        child: NotebookCoverWidget(
                          notebook: NotebookModel(
                            id: 'preview',
                            title: previewTitle,
                            coverColor: activePreset.coverColor,
                            accentColor: activePreset.accentColor,
                            spineColor: activePreset.spineColor,
                            spinePattern: activePreset.spinePattern,
                            icon: activePreset.icon,
                            iconColor: activePreset.iconColor,
                            createdAt: DateTime.now(),
                            pageCount: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title input field
                    Text(
                      'Başlık',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: config.headerTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: config.isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: config.cardShadow,
                        border: Border.all(
                          color: config.cardBorderColor,
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: TextField(
                        controller: _titleController,
                        onChanged: (val) {
                          setState(() {}); // Updates live preview
                        },
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: config.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Defterine tatlı bir isim ver...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: config.textHint,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Cover Selection Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kapak Çeşitleri',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: config.headerTextColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: config.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${NotebookCoverDesign.presets.length} Çeşit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: config.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: NotebookCoverDesign.presets.length,
                      itemBuilder: (context, index) {
                        final preset = NotebookCoverDesign.presets[index];
                        final isSelected = _selectedPresetIndex == index;

                        return NotebookCoverWidget(
                          compact: true,
                          isSelected: isSelected,
                          notebook: NotebookModel(
                            id: preset.id,
                            title: preset.name,
                            coverColor: preset.coverColor,
                            accentColor: preset.accentColor,
                            spineColor: preset.spineColor,
                            spinePattern: preset.spinePattern,
                            icon: preset.icon,
                            iconColor: preset.iconColor,
                            createdAt: DateTime.now(),
                            pageCount: 0,
                          ),
                          onTap: () {
                            setState(() {
                              _selectedPresetIndex = index;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
