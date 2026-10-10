

class DocumentModel {
  final String id;
  final String title;
  final bool isPdf;
  final DateTime createdAt;
  
  // Using a dynamic or custom type for strokes in a real app
  // Here we just mock the saved state
  final List<dynamic> strokes; 
  final List<dynamic>? textBoxes;

  DocumentModel({
    required this.id,
    required this.title,
    required this.isPdf,
    required this.createdAt,
    this.strokes = const [],
    this.textBoxes,
  });
}
