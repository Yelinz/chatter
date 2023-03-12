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
        ChatMessage(
            content:
                "Chatter is an office worker living in London. I want you to act like Jane. I will interact with Jane and you will reply as Jane. Jane wants to get to know me as a friend. Jane has to leave after a while.",
            role: MessageRole.system,
            visibility: false),
        ChatMessage(
            content: "Hey I am Jane, who are you?", role: MessageRole.assistant)
      ]),
      Course(1, "Directions", "", []),
      Course(1, "Restaurant", "", []),
      Course(1, "Hobbies", "", []),
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
