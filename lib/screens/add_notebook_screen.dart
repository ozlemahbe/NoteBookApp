import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';
import '../widgets/notebook_cover_widget.dart';

/// Screen: "Not defteri Ekle" (Add Notebook) matching Sketch 2:
/// - Header with back arrow `< `, title "Not defteri Ekle", check button `✓`
/// - "Başlık" text input field
/// - Selectable cover designs grid (covers with spine + cute center icon)
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
      spineColor: preset.spineColor,
      icon: preset.icon,
      createdAt: DateTime.now(),
      pageCount: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Not defteri oluşturuldu ♡',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppTheme.deepLavender,
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

    return Scaffold(
      backgroundColor: AppTheme.background,
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
        // Title: "Not defteri Ekle" matching Sketch 2
        title: const Text(
          'Not defteri Ekle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          // Right check/save button `✓` matching Sketch 2
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryLavender.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.check_rounded,
                  color: AppTheme.deepLavender,
                ),
                onPressed: _saveNotebook,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      spineColor: activePreset.spineColor,
                      icon: activePreset.icon,
                      createdAt: DateTime.now(),
                      pageCount: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title input field ("Başlık" as sketched in Image 2)
              const Text(
                'Başlık',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.antigravityShadow,
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Defterine tatlı bir isim ver...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textHint,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Cover Selection Grid ("Not defteri Çeşitleri olacak (kaydırılacak)")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kapak Çeşitleri',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    '${NotebookCoverDesign.presets.length} Çeşit',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      spineColor: preset.spineColor,
                      icon: preset.icon,
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
    );
  }
}
