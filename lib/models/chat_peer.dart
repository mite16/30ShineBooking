class ChatPeer {
  final String id;
  final String fullName;
  final String phone;

  const ChatPeer({required this.id, required this.fullName, required this.phone});

  factory ChatPeer.fromJson(Map<String, dynamic> json) {
    return ChatPeer(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String? ?? '',
    );
  }
}
