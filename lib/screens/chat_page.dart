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

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.initialPrompt});

  final ChatMessage? initialPrompt;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final urlAudio = Uri.https('api.openai.com', 'v1/audio/transcriptions');
  final urlChat = Uri.https('api.openai.com', 'v1/chat/completions');
  final urlModeration = Uri.https('api.openai.com', 'v1/moderations');
  List<ChatMessage> messages = <ChatMessage>[];

  @override
  initState() {
    super.initState();
    // TODO: hide inital prompt, inital prompt includes course information such as personality etc.
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

    checkTranscript(transcript);

    if (response.statusCode != 200) {
      developer.log('audio error');
    } else {
      getModelResponse(transcript);
      setState(() {
        messages.add(ChatMessage.fromContent(transcript));
      });
    }
  }

  void checkTranscript(String transcript) async {
    Map data = {
      "input": transcript
    };

    var response = await http.post(urlModeration,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Env.openAiKey}"
        },
        body: json.encode(data));

    if (response.statusCode != 200) {
      developer.log('moderation error');
    } else {
      var body = json.decode(response.body);
      setState(() {
        body["results"][0]["flagged"];
      });
    }
  }

  void getModelResponse(String text) async {
    Map data = {
      'model': 'gpt-3.5-turbo',
      "messages": [
        ...messages,
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
      body: Stack(
        children: <Widget>[
          ChatBox(messages: messages),
          ActionButtonBar(recordingFinished: processAudioInput)
        ],
      ),
    );
  }
}
