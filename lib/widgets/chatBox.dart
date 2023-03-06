import 'package:chatter/widgets/messageBox.dart';
import 'package:flutter/material.dart';
import '../models/ChatMessage.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.messages});

  final List messages;

  @override
  State<ChatBox> createState() => _ChatBox();
}

class _ChatBox extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        return MessageBox(message: widget.messages[index]);
      },
    );
  }
}
