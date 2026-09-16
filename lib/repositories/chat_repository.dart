import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../services/api_client.dart';

/// Talks to /api/chat/* on the backend — the "user trao đổi với nhau qua
/// hệ thống" bonus item. 1:1 conversations only, found/created by the
/// other user's phone or email (see backend/README.md).
class ChatRepository {
  ChatRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<Conversation>> getConversations() async {
    final json = await _client.get('/chat/conversations', auth: true);
    return (json as List).map((c) => Conversation.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<Conversation> startConversation(String phoneOrEmail) async {
    final json = await _client.post(
      '/chat/conversations',
      auth: true,
      body: {'phoneOrEmail': phoneOrEmail},
    );
    return Conversation.fromJson(json as Map<String, dynamic>);
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final json = await _client.get('/chat/conversations/$conversationId/messages', auth: true);
    return (json as List).map((m) => ChatMessage.fromJson(m as Map<String, dynamic>)).toList();
  }

  Future<ChatMessage> sendMessage(String conversationId, String text) async {
    final json = await _client.post(
      '/chat/conversations/$conversationId/messages',
      auth: true,
      body: {'text': text},
    );
    return ChatMessage.fromJson(json as Map<String, dynamic>);
  }
}
