import 'chat_peer.dart';

class Conversation {
  final String id;
  final ChatPeer peer;
  final String? lastMessageText;
  final DateTime? lastMessageAt;

  const Conversation({
    required this.id,
    required this.peer,
    required this.lastMessageText,
    required this.lastMessageAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      peer: ChatPeer.fromJson(json['peer'] as Map<String, dynamic>),
      lastMessageText: json['lastMessageText'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String).toLocal(),
    );
  }
}
