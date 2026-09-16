import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../widgets/error_retry.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });
  }

  Future<void> _startNewConversation() async {
    final controller = TextEditingController();
    final phoneOrEmail = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nhắn tin với ai?'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Số điện thoại hoặc email của họ'),
          onSubmitted: (v) => Navigator.pop(dialogContext, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );

    if (phoneOrEmail == null || phoneOrEmail.trim().isEmpty || !mounted) return;

    final conversation = await context.read<ChatProvider>().startConversation(phoneOrEmail.trim());
    if (!mounted) return;

    if (conversation == null) {
      final error = context.read<ChatProvider>().startConversationError;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error ?? 'Không thể bắt đầu trò chuyện')));
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(conversation: conversation)));
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nhắn tin'), automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewConversation,
        child: const Icon(Icons.add_comment_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ChatProvider>().loadConversations(),
        child: chat.isLoadingConversations
            ? const Center(child: CircularProgressIndicator())
            : chat.conversationsError != null
                ? ListView(
                    children: [
                      ErrorRetry(
                        message: chat.conversationsError!,
                        onRetry: () => context.read<ChatProvider>().loadConversations(),
                      ),
                    ],
                  )
                : chat.conversations.isEmpty
                    ? ListView(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: Center(
                              child: Text(
                                'Chưa có cuộc trò chuyện nào.\nBấm nút + để nhắn cho người khác qua số điện thoại/email.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        itemCount: chat.conversations.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final conversation = chat.conversations[i];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(conversation.peer.fullName.isNotEmpty
                                  ? conversation.peer.fullName[0].toUpperCase()
                                  : '?'),
                            ),
                            title: Text(conversation.peer.fullName),
                            subtitle: Text(
                              conversation.lastMessageText ?? 'Chưa có tin nhắn',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ChatScreen(conversation: conversation)),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
