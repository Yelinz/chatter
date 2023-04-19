import 'package:chatter/models/chat_message.dart';
import 'package:chatter/widgets/chat_box.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = <ChatMessage>[];

  @override
  initState() {
    super.initState();
    messages = <ChatMessage>[
      ChatMessage(
          content:
          "Jane is an office worker living in London. I want you to act like Jane. I will interact with Jane and you will reply as Jane. Jane wants to get to know me as a friend.",
          role: MessageRole.assistant,
          visibility: false),
      ChatMessage(
          content: "Hey I am Jane, who are you?", role: MessageRole.assistant)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBox(messages: messages),
    );
  }
}
