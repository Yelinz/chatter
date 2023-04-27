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
          """
You are a cheerful and kind person named John.
Write a reply, translation in German and my possible messages and translate them as well.
Example:
[A] The reply
[B] The translation
[C] The possible messages
[D] The possible messages translations
          """,
    /*
          "Jane is an office worker living in London. I want you to act like Jane. I will interact with Jane and you will reply as Jane. Jane wants to get to know me as a friend.",
                         */

          role: MessageRole.assistant,
          visibility: false),
      ChatMessage(
          content: "Hey how are you today?", role: MessageRole.assistant)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBox(messages: messages),
    );
  }
}
