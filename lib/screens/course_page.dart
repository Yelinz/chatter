import 'package:chatter/models/chat_message.dart';
import 'package:chatter/widgets/chat_box.dart';
import 'package:flutter/material.dart';


class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.initialPrompts});

  final List<ChatMessage> initialPrompts;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Introductions",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.info_outline,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChatBox(messages: widget.initialPrompts),
    );
  }
}
