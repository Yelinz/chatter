import 'package:chatter/widgets/messageBox.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.messages});

  final List<ChatMessage> messages;

  @override
  State<ChatBox> createState() => _ChatBox();
}

class _ChatBox extends State<ChatBox> {
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();

    messages = widget.messages.where((message) => message.visibility!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        return MessageBox(message: messages[index]);
      },
    );
  }
}
