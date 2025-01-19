import 'dart:convert';
import 'dart:typed_data'; // For base64Decode

class Message {
  String? messageId;
  final DateTime sentTime;
  final bool isEdited;
  final String text;
  final String senderId;
  final String conversationId;
  final String? embeddedResourceType;
  final bool isScheduled;
  final List<Document> documents; // List to store documents

  Message({
    required this.sentTime,
    required this.isEdited,
    required this.text,
    required this.senderId,
    required this.conversationId,
    this.embeddedResourceType,
    required this.isScheduled,
    this.documents = const [], // Default to an empty list if no documents
  });

  // Convert to JSON for sending to the backend
  Map<String, dynamic> toJson() {
    return {
      'sentTime': sentTime.toIso8601String(),
      'isEdited': isEdited,
      'text': text,
      'senderId': senderId,
      'conversationId': conversationId,
      'embeddedResourceType': embeddedResourceType,
      'isScheduled': isScheduled,
      'messageId': messageId ?? "00000000-0000-0000-0000-000000000000",
      'documents': documents.map((doc) => doc.toJson()).toList(), // Convert documents to JSON
    };
  }

  Message.name(
      this.messageId,
      this.sentTime,
      this.isEdited,
      this.text,
      this.senderId,
      this.conversationId,
      this.embeddedResourceType,
      this.isScheduled,
      this.documents,
      );

  factory Message.fromJson(Map<String, dynamic> json) {
    var docList = json['documents'] as List? ?? [];
    List<Document> documents = docList.map((docJson) => Document.fromJson(docJson)).toList();

    return Message.name(
      json['messageId'],
      DateTime.parse(json['sentTime']),
      json['isEdited'],
      json['text'],
      json['senderId'],
      json['conversationId'],
      json['embeddedResourceType'],
      json['isScheduled'],
      documents,
    );
  }
}

// Document class to handle file data (Base64 encoded byte array)
class Document {
  String? documentId;
  final String fileName;
  final String documentType;
  final String document1; // This is the Base64 encoded string

  Document({
    this.documentId,
    required this.fileName,
    required this.documentType,
    required this.document1, // This is Base64 string
  });

  // Convert to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId ?? "00000000-0000-0000-0000-000000000000",
      'fileName': fileName,
      'documentType': documentType,
      'document1': document1, // Send Base64 string
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['documentId'],
      fileName: json['fileName'],
      documentType: json['documentType'],
      document1: json['document1'], // Base64 string
    );
  }

  // Decode the Base64 string to a byte array (Uint8List)
  Uint8List get decodedFileData => base64Decode(document1);
}