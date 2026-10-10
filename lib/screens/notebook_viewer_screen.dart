import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';

class NotebookViewerScreen extends StatefulWidget {
  final NotebookModel notebook;

  const NotebookViewerScreen({super.key, required this.notebook});

  @override
  State<NotebookViewerScreen> createState() => _NotebookViewerScreenState();
}

enum PagePattern { blank, lined, squared, dotted }

class StickerData {
  Offset position;
  double scale;
  double rotation;
  final String emoji;

  StickerData({
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
    required this.emoji,
  });
}

class NotebookPageData {
  PagePattern pattern;
  List<StickerData> stickers;
  String textContent;

  NotebookPageData({
    this.pattern = PagePattern.blank,
    this.stickers = const [],
    this.textContent = '',
  });
}

class _NotebookViewerScreenState extends State<NotebookViewerScreen> {
  final PageController _pageController = PageController();
  late List<NotebookPageData> _pages;

  // Track currently active sticker for interaction
  StickerData? _activeSticker;

  @override
  void initState() {
    super.initState();
    // Initialize with 3 empty pages
    _pages = [
      NotebookPageData(pattern: PagePattern.lined),
      NotebookPageData(pattern: PagePattern.blank),
      NotebookPageData(pattern: PagePattern.squared),
    ];
  }

  void _addPage() {
    setState(() {
      _pages.add(NotebookPageData(pattern: PagePattern.blank));
    });
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showBackgroundPicker(int pageIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sayfa Arka Planı',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBgOption(
                    pageIndex,
                    PagePattern.blank,
                    'Boş',
                    Icons.crop_din_rounded,
                  ),
                  _buildBgOption(
                    pageIndex,
                    PagePattern.lined,
                    'Çizgili',
                    Icons.reorder_rounded,
                  ),
                  _buildBgOption(
                    pageIndex,
                    PagePattern.squared,
                    'Kareli',
                    Icons.grid_4x4_rounded,
                  ),
                  _buildBgOption(
                    pageIndex,
                    PagePattern.dotted,
                    'Noktalı',
                    Icons.blur_on_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBgOption(
    int pageIndex,
    PagePattern pattern,
    String label,
    IconData icon,
  ) {
    final isSelected = _pages[pageIndex].pattern == pattern;
    return GestureDetector(
      onTap: () {
        setState(() {
          _pages[pageIndex].pattern = pattern;
        });
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: Icon(icon, color: isSelected ? Colors.blue : Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _addSticker(int pageIndex) {
    setState(() {
      _pages[pageIndex].stickers.add(
        StickerData(
          position: const Offset(100, 100),
          emoji: '🌟', // Default sticker, can be expanded to a picker
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeType = AppTheme.themeNotifier.value;
    final config = ThemeConfig.fromType(themeType);

    return Scaffold(
      backgroundColor: config.isDark
          ? const Color(0xFF1E1733)
          : const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: config.headerTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.notebook.title,
          style: TextStyle(
            color: config.headerTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: config.primaryColor,
            ),
            onPressed: _addPage,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _buildPage(context, index, config);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index, ThemeConfig config) {
    final pageData = _pages[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSticker = null; // Unfocus sticker
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        decoration: BoxDecoration(
          color: config.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Custom Background Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _PagePatternPainter(
                  pattern: pageData.pattern,
                  config: config,
                ),
              ),
            ),

            // Text Note Area
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buraya dokunarak yazmaya başlayın...',
                    hintStyle: TextStyle(color: config.textHint),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6, // Matches lined paper height
                    color: config.textDark,
                  ),
                  onChanged: (val) => pageData.textContent = val,
                ),
              ),
            ),

            // Stickers Layer
            ...pageData.stickers.map((sticker) {
              return Positioned(
                left: sticker.position.dx,
                top: sticker.position.dy,
                child: GestureDetector(
                  onScaleStart: (details) {
                    setState(() {
                      _activeSticker = sticker;
                    });
                  },
                  onScaleUpdate: (details) {
                    if (_activeSticker == sticker) {
                      setState(() {
                        sticker.position += details.focalPointDelta;
                        sticker.scale = (sticker.scale * details.scale).clamp(
                          0.5,
                          5.0,
                        );
                        sticker.rotation += details.rotation;
                      });
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(-40 * sticker.scale, -40 * sticker.scale),
                    child: Transform.rotate(
                      angle: sticker.rotation,
                      child: Transform.scale(
                        scale: sticker.scale,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: _activeSticker == sticker
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              sticker.emoji,
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Floating Tools for current page
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.wallpaper_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => _showBackgroundPicker(index),
                        tooltip: 'Arka Plan',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => _addSticker(index),
                        tooltip: 'Sticker Ekle',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.brush_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Çizim modu (Belgeler ekranı ile aynı motoru kullanacak)',
                              ),
                            ),
                          );
                        },
                        tooltip: 'Çizim',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Page Number
            Positioned(
              bottom: 10,
              right: 20,
              child: Text(
                '${index + 1} / ${_pages.length}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PagePatternPainter extends CustomPainter {
  final PagePattern pattern;
  final ThemeConfig config;

  _PagePatternPainter({required this.pattern, required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    if (pattern == PagePattern.blank) return;

    final paint = Paint()
      ..color = config.primaryColor.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    if (pattern == PagePattern.lined) {
      const double spacing = 28.8; // line height matching font
      for (double y = 40; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    } else if (pattern == PagePattern.squared) {
      const double spacing = 24.0;
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    } else if (pattern == PagePattern.dotted) {
      const double spacing = 24.0;
      for (double y = spacing / 2; y < size.height; y += spacing) {
        for (double x = spacing / 2; x < size.width; x += spacing) {
          canvas.drawCircle(
            Offset(x, y),
            1.5,
            paint..style = PaintingStyle.fill,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PagePatternPainter oldDelegate) {
    return oldDelegate.pattern != pattern || oldDelegate.config != config;
  }
}
