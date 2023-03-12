import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:chatter/env/env.dart';
import 'package:chatter/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../widgets/actionButtonBar.dart';
import '../widgets/chatBox.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.initialPrompts});

  final List<ChatMessage> initialPrompts;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final urlAudio = Uri.https('api.openai.com', 'v1/audio/transcriptions');
  final urlChat = Uri.https('api.openai.com', 'v1/chat/completions');
  List<ChatMessage> messages = <ChatMessage>[];

  @override
  initState() {
    super.initState();
    messages = widget.initialPrompts;
  }

  Future processAudioInput(File file) {
    audioToText(file);
    return Future.delayed(const Duration(seconds: 8));
  }

  void audioToText(File file) async {
    var request = http.MultipartRequest('POST', urlAudio)
      ..headers["Authorization"] = "Bearer ${Env.openAiKey}"
      ..fields['model'] = 'whisper-1'
      ..files.add(http.MultipartFile.fromBytes("file", await file.readAsBytes(),
          filename: "audio.m4a", contentType: MediaType("audio", "m4a")));
    var response = await request.send();

    var transcript = json.decode(await response.stream.bytesToString())["text"];

    if (response.statusCode != 200) {
      developer.log('audio error');
    } else {
      getModelResponse(transcript);
      setState(() {
        messages.add(ChatMessage.fromContent(transcript));
      });
    }
  }

  void getModelResponse(String text) async {
    Map data = {
      'model': 'gpt-3.5-turbo',
      "messages": [
        ...(messages.map((e) => e.toJSON()).toList()),
        {"role": "user", "content": text}
      ],
      "user": "todo",
      // hyper parameters
      "temperature": 1,
      "top_p": 1,
      "max_tokens": 2000,
      "presence_penalty": 0.5,
      "frequency_penalty": 1,
    };

    var response = await http.post(urlChat,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Env.openAiKey}"
        },
        body: json.encode(data));
    if (response.statusCode != 200) {
      developer.log('chat error');
    } else {
      var body = json.decode(response.body);
      setState(() {
        messages.add(body["choices"]
            .map((choice) => ChatMessage.fromMessage(choice["message"]))
            .toList()[0]);
      });
    }
  }

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
      body: Stack(
        children: <Widget>[
          ChatBox(messages: messages),
          ActionButtonBar(recordingFinished: processAudioInput)
        ],
      ),
    );
  }
}
