import '../../models/message.dart';  // Import your Document model

class DocumentMedia {
  final Document document;
  final String embeddedResourceType;
  final String text;

  DocumentMedia({
    required this.document,
    required this.embeddedResourceType,
    required this.text,
  });

  // Factory constructor to create a DocumentMedia from JSON (if needed)
  factory DocumentMedia.fromJson(Map<String, dynamic> json) {
    return DocumentMedia(
      document: Document.fromJson(json['document']),  // Assuming your Document class has a fromJson method
      embeddedResourceType: json['embeddedResourceType'],
      text: json['text'],
    );
  }

  // Convert DocumentMedia to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'document': document.toJson(),  // Assuming your Document class has a toJson method
      'embeddedResourceType': embeddedResourceType,
      'text': text,
    };
  }
}