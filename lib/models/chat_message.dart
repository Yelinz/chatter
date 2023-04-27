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
    String fullContent = message["content"];

    RegExp exp = RegExp(r"^\[A\](.+)\[B\](.+)\[C\](.+)$", dotAll: true);
    Iterable<Match> matches = exp.allMatches(fullContent);

    if (matches.isNotEmpty) {
      content = matches.elementAt(0).group(1)?.trim();
      translation = matches.elementAt(0).group(2)?.trim();
    } else {
      content = fullContent;
    }

    role = MessageRole.values.byName(message["role"]);
  }

  ChatMessage.fromContent(String this.content) {
    role = MessageRole.user;
  }

  Map toJSON() {
    // TODO: api docs mentions name parameter for system messages, simulating the the input and ouput
    return {"role": role.toString().split('.').last, "content": content};
  }
}
