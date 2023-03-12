import 'dart:io';

enum MessageRole { user, assistant, system }

class ChatMessage {
  String? content;
  MessageRole? role;
  bool? visibility = true;
  String? translation;
  File? audio;

  ChatMessage(
      {required this.content, required this.role, this.visibility = true});

  ChatMessage.fromMessage(Map message) {
    content = message["content"];
    role = message["role"];
  }

  ChatMessage.fromContent(String this.content) {
    role = MessageRole.user;
  }

  Map toJSON() {
    // TODO: api docs mentions name parameter for system messages, simulating the the input and ouput
    return {"role": role.toString(), "content": content};
  }
}
