import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw_pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';

class DrawingEditorScreen extends StatefulWidget {
  final bool isPdfMode;
  final List<Stroke>? initialStrokes;
  final List<TextBoxInfo>? initialTextBoxes;

  const DrawingEditorScreen({
    super.key, 
    this.isPdfMode = false,
    this.initialStrokes,
    this.initialTextBoxes,
  });

  @override
  State<DrawingEditorScreen> createState() => _DrawingEditorScreenState();
}

enum DrawingTool { pen, highlighter, text, move }

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isHighlighter;

  Stroke({
    required this.points,
    required this.color,
    required this.width,
    this.isHighlighter = false,
  });
}

class TextBoxInfo {
  Offset position;
  String text;

  TextBoxInfo({required this.position, this.text = ''});
}

class _DrawingEditorScreenState extends State<DrawingEditorScreen> {
  Uint8List? _pdfData;
  bool _isLoadingPdf = false;

  DrawingTool _currentTool = DrawingTool.pen;
  final Color _currentColor = Colors.black;
  final double _currentWidth = 3.0;

  late List<Stroke> _strokes;
  Stroke? _currentStroke;

  late List<TextBoxInfo> _textBoxes;

  @override
  void initState() {
    super.initState();
    _strokes = widget.initialStrokes != null ? List.from(widget.initialStrokes!) : [];
    _textBoxes = widget.initialTextBoxes != null ? List.from(widget.initialTextBoxes!) : [];

    if (widget.isPdfMode) {
      _loadDummyPdf();
    }
  }

  Future<void> _loadDummyPdf() async {
    setState(() => _isLoadingPdf = true);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: pw_pdf.PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Örnek PDF Belgesi",
                style: const pw.TextStyle(fontSize: 40)),
          );
        },
      ),
    );
    final bytes = await pdf.save();
    if (mounted) {
      setState(() {
        _pdfData = bytes;
        _isLoadingPdf = false;
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_currentTool == DrawingTool.move) return;
    if (_currentTool == DrawingTool.text) {
      setState(() {
        _textBoxes.add(TextBoxInfo(position: details.localPosition));
      });
      _showTextInputDialog(_textBoxes.last);
      return;
    }

    setState(() {
      _currentStroke = Stroke(
        points: [details.localPosition],
        color: _currentTool == DrawingTool.highlighter
            ? Colors.yellow.withValues(alpha: 0.4)
            : _currentColor,
        width: _currentTool == DrawingTool.highlighter ? 20.0 : _currentWidth,
        isHighlighter: _currentTool == DrawingTool.highlighter,
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStroke != null) {
      setState(() {
        _currentStroke!.points.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke != null) {
      setState(() {
        _strokes.add(_currentStroke!);
        _currentStroke = null;
      });
    }
  }

  Future<void> _showTextInputDialog(TextBoxInfo tb) async {
    final TextEditingController ctrl = TextEditingController(text: tb.text);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Metin Ekle'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          )
        ],
      ),
    );
    setState(() {
      tb.text = ctrl.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeType = AppTheme.themeNotifier.value;
    final config = ThemeConfig.fromType(themeType);

    return Scaffold(
      backgroundColor: config.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: config.headerTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isPdfMode ? 'PDF Düzenleyici' : 'Çizim',
          style: TextStyle(
              color: config.headerTextColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: config.primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Kaydedildi')));
              Navigator.pop(context, {
                'strokes': _strokes,
                'textBoxes': _textBoxes,
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Layer (PDF or Blank)
          if (widget.isPdfMode)
            _isLoadingPdf
                ? const Center(child: CircularProgressIndicator())
                : _pdfData != null
                    ? PdfViewer.data(
                        _pdfData!,
                        sourceName: 'dummy.pdf',
                        params: const PdfViewerParams(
                          backgroundColor: Colors.grey,
                        ),
                      )
                    : const Center(child: Text("PDF yüklenemedi"))
          else
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: config.cardShadow,
              ),
            ),

          // Drawing Layer
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _currentTool == DrawingTool.move,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  painter: _DrawingPainter(
                      strokes: _strokes, currentStroke: _currentStroke),
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: _textBoxes.map((tb) {
                        return Positioned(
                          left: tb.position.dx,
                          top: tb.position.dy,
                          child: GestureDetector(
                            onTap: () => _showTextInputDialog(tb),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              color: Colors.white.withValues(alpha: 0.5),
                              child: Text(
                                tb.text.isEmpty ? 'Metin...' : tb.text,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Toolbar
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: config.isDark ? const Color(0xFF2A2345) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToolIcon(Icons.edit_rounded, DrawingTool.pen, config),
                    _buildToolIcon(
                        Icons.brush_rounded, DrawingTool.highlighter, config),
                    _buildToolIcon(
                        Icons.text_fields_rounded, DrawingTool.text, config),
                    _buildToolIcon(
                        Icons.pan_tool_rounded, DrawingTool.move, config),
                    Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 8)),
                    IconButton(
                      icon: const Icon(Icons.undo_rounded),
                      color: config.textMuted,
                      onPressed: () {
                        if (_strokes.isNotEmpty) {
                          setState(() {
                            _strokes.removeLast();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, DrawingTool tool, ThemeConfig config) {
    final isSelected = _currentTool == tool;
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? config.primaryColor : config.textMuted,
      onPressed: () {
        setState(() {
          _currentTool = tool;
        });
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final Stroke? currentStroke;

  _DrawingPainter({required this.strokes, this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      _paintStroke(canvas, stroke);
    }
    if (currentStroke != null) {
      _paintStroke(canvas, currentStroke!);
    }
  }

  void _paintStroke(Canvas canvas, Stroke stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (stroke.isHighlighter) {
      paint.blendMode = BlendMode.multiply;
    }

    final path = Path();
    path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
