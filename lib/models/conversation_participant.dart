class ConversationParticipant {
  final String participantId;
  final String userId;
  final String conversationId;

  ConversationParticipant({
    required this.participantId,
    required this.userId,
    required this.conversationId,
  });

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      participantId: json['participantId'],
      userId: json['userId'],
      conversationId: json['conversationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'userId': userId,
      'conversationId': conversationId,
    };
  }
}