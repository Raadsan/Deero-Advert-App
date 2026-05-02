class Conversation {
  final int id;
  final int participant1Id;
  final int participant2Id;
  final String? lastMessage;
  final DateTime updatedAt;
  final Map<String, dynamic>? participant1;
  final Map<String, dynamic>? participant2;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    this.lastMessage,
    required this.updatedAt,
    this.participant1,
    this.participant2,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: int.parse(json['id'].toString()),
      participant1Id: int.parse(json['participant1Id'].toString()),
      participant2Id: int.parse(json['participant2Id'].toString()),
      lastMessage: json['lastMessage'],
      updatedAt: DateTime.parse(json['updatedAt']),
      participant1: json['participant1'],
      participant2: json['participant2'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

class ChatMessage {
  final int id;
  final int conversationId;
  final int senderId;
  final String text;
  final bool isRead;
  final String messageType; // 'text' or 'voice'
  final String? mediaUrl;
  final int? duration;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.isRead,
    this.messageType = 'text',
    this.mediaUrl,
    this.duration,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: int.parse(json['id'].toString()),
      conversationId: int.parse(json['conversationId'].toString()),
      senderId: int.parse(json['senderId'].toString()),
      text: json['text'] ?? '',
      isRead: json['isRead'] ?? false,
      messageType: json['messageType'] ?? 'text',
      mediaUrl: json['mediaUrl'],
      duration: json['duration'] != null ? int.parse(json['duration'].toString()) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

