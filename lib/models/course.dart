import 'package:chatter/models/chat_message.dart';

class Course {
  int id;
  String name;
  String translation;
  List<ChatMessage> initialPrompts;

  Course(this.id, this.name, this.translation, this.initialPrompts);
}