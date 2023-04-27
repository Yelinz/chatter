import 'package:chatter/models/course.dart';
import 'package:chatter/screens/course_page.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class CourseOverviewPage extends StatefulWidget {
  const CourseOverviewPage({
    super.key,
  });

  @override
  State<CourseOverviewPage> createState() => _CourseOverviewPageState();
}

class _CourseOverviewPageState extends State<CourseOverviewPage> {
  List<Course> entries = [];

  @override
  void initState() {
    super.initState();
    entries = [
      Course(1, "Introduction", "Vorstellung", [
        ChatMessage(content: """
You are a cheerful and kind person named John.
Write a reply in English, a translation in German and my possible messages and translate them as well.
Example:
[A] The reply
[B] The translation
[C] The possible messages
[D] The possible messages translations
          """, role: MessageRole.system, visibility: false),
        ChatMessage(
            content: "Hey nice to meet you I am John, who are you?", role: MessageRole.assistant)
      ]),
      Course(1, "Directions", "", [
        ChatMessage(content: """
You are a cheerful and kind person named John.
Write a reply in English, a translation in German and my possible messages and translate them as well.
Example:
[A] The reply
[B] The translation
[C] The possible messages
[D] The possible messages translations
          """, role: MessageRole.system, visibility: false),
        ChatMessage(
            content: "Hey how can I help you?", role: MessageRole.assistant)
      ]),
      Course(1, "Restaurant", "", [
        ChatMessage(content: """
You are a cheerful and kind person named John.
Write a reply in English, a translation in German and my possible messages and translate them as well.
Example:
[A] The reply
[B] The translation
[C] The possible messages
[D] The possible messages translations
          """, role: MessageRole.system, visibility: false),
        ChatMessage(
            content: "Welcome do you have a reservation?", role: MessageRole.assistant)
      ]),
      Course(1, "Hobbies", "", [
        ChatMessage(content: """
You are a cheerful and kind person named John.
Write a reply in English, a translation in German and my possible messages and translate them as well.
Example:
[A] The reply
[B] The translation
[C] The possible messages
[D] The possible messages translations
          """, role: MessageRole.system, visibility: false),
        ChatMessage(
            content: "What kind of sports do you play?", role: MessageRole.assistant)
      ]),
    ];
  }

  void openCourse(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CoursePage(
          initialPrompts: course.initialPrompts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF642B73),
                          Color(0xFFC6426E),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    openCourse(entries[index]);
                  },
                  child: Text(entries[index].name),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          thickness: 0,
        ),
      ),
    );
  }
}
