class Message {
  String? messageId;
  final DateTime sentTime;
  final bool isEdited;
  final String text;
  final String senderId;
  final String conversationId;
  final String? embeddedResourceType;
  final bool isScheduled;

  Message({
    required this.sentTime,
    required this.isEdited,
    required this.text,
    required this.senderId,
    required this.conversationId,
    this.embeddedResourceType,
    required this.isScheduled,
  });
  // Convert to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'sentTime': sentTime.toIso8601String(),
      'isEdited': isEdited,
      'text': text,
      'senderId': senderId,
      'conversationId': conversationId,
      'embeddedResourceType': embeddedResourceType,
      'isScheduled': isScheduled,
      'messageId': messageId ?? "00000000-0000-0000-0000-000000000000"
    };
  }
  Message.name(this.messageId, this.sentTime, this.isEdited, this.text,
      this.senderId, this.conversationId, this.embeddedResourceType,
      this.isScheduled);

factory Message.fromJson(Map<String, dynamic> json) {
    return Message.name(
      json['messageId'],
      DateTime.parse(json['sentTime']),
      json['isEdited'],
      json['text'],
      json['senderId'],
      json['conversationId'] ,
      json['embeddedResourceType'],
      json['isScheduled'],
    );
  }


}