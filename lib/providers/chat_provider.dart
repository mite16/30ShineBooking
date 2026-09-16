import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../repositories/chat_repository.dart';

/// Drives the conversation list and one open thread at a time. While a
/// thread is open, polls for new messages every few seconds — a REST-only
/// stand-in for a live chat, no WebSocket/Firebase account needed.
class ChatProvider extends ChangeNotifier {
  ChatProvider(this._repository);

  final ChatRepository _repository;

  List<Conversation> conversations = [];
  bool isLoadingConversations = false;
  String? conversationsError;

  bool isStartingConversation = false;
  String? startConversationError;

  String? openConversationId;
  List<ChatMessage> messages = [];
  bool isLoadingMessages = false;
  String? messagesError;
  bool isSending = false;

  Timer? _pollTimer;

  Future<void> loadConversations() async {
    isLoadingConversations = true;
    conversationsError = null;
    notifyListeners();
    try {
      conversations = await _repository.getConversations();
    } catch (e) {
      conversationsError = _readable(e);
    } finally {
      isLoadingConversations = false;
      notifyListeners();
    }
  }

  Future<Conversation?> startConversation(String phoneOrEmail) async {
    isStartingConversation = true;
    startConversationError = null;
    notifyListeners();
    try {
      final conversation = await _repository.startConversation(phoneOrEmail);
      final withoutDuplicate = conversations.where((c) => c.id != conversation.id);
      conversations = [conversation, ...withoutDuplicate];
      return conversation;
    } catch (e) {
      startConversationError = _readable(e);
      return null;
    } finally {
      isStartingConversation = false;
      notifyListeners();
    }
  }

  Future<void> openConversation(String conversationId) async {
    openConversationId = conversationId;
    messages = [];
    await _loadMessages();
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _loadMessages(silently: true));
  }

  void closeConversation() {
    _pollTimer?.cancel();
    _pollTimer = null;
    openConversationId = null;
    messages = [];
  }

  Future<void> _loadMessages({bool silently = false}) async {
    final conversationId = openConversationId;
    if (conversationId == null) return;
    if (!silently) {
      isLoadingMessages = true;
      messagesError = null;
      notifyListeners();
    }
    try {
      final fetched = await _repository.getMessages(conversationId);
      if (openConversationId == conversationId) {
        messages = fetched;
      }
    } catch (e) {
      if (!silently) messagesError = _readable(e);
    } finally {
      if (!silently) isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage(String text) async {
    final conversationId = openConversationId;
    if (conversationId == null || text.trim().isEmpty) return false;
    isSending = true;
    notifyListeners();
    try {
      final message = await _repository.sendMessage(conversationId, text.trim());
      messages = [...messages, message];
      return true;
    } catch (e) {
      messagesError = _readable(e);
      return false;
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  String _readable(Object e) => e.toString().replaceFirst('Exception: ', '');

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
