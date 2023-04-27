import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:chatter/env/env.dart';
import 'package:chatter/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../widgets/action_button_bar.dart';
import '../widgets/message_box.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.messages});

  final List<ChatMessage> messages;

  @override
  State<ChatBox> createState() => _ChatBox();
}

class _ChatBox extends State<ChatBox> {
  final urlAudio = Uri.https('api.openai.com', 'v1/audio/transcriptions');
  final urlChat = Uri.https('api.openai.com', 'v1/chat/completions');
  List<ChatMessage> messages = <ChatMessage>[];
  ChatMessage? initialMessage;

  @override
  initState() {
    super.initState();
    initialMessage = widget.messages.first;
    messages =
        widget.messages.where((element) => element.visibility!).toList();
  }

  Future processAudioInput(File file) {
    audioToText(file);
    return Future.delayed(const Duration(seconds: 8));
  }

  void audioToText(File file) async {
    var request = http.MultipartRequest('POST', urlAudio)
      ..headers["Authorization"] = "Bearer ${Env.openAiKey}"
      ..fields['model'] = 'whisper-1'
      ..files.add(
          http.MultipartFile.fromBytes(
              "file",
              await file.readAsBytes(),
              filename: "audio.m4a",
              contentType: MediaType("audio", "m4a")
          )
      );
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

  Future<void> getModelResponse(String text) async {
    Map data = {
      'model': 'gpt-3.5-turbo',
      "messages": [
        initialMessage!.toJSON(),
        ...(messages.map((e) => e.toJSON()).toList()),
      ],
      "user": "todo",
      // hyper parameters
      "temperature": 1,
      "top_p": 1,
      "max_tokens": 2000,
      "presence_penalty": 0.5,
      "frequency_penalty": 1,
    };

    developer.log(data.toString());

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
        messages.add(ChatMessage.fromMessage(body["choices"][0]["message"]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: messages.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            return MessageBox(message: messages[index]);
          },
        ),
        ActionButtonBar(recordingFinished: processAudioInput)
      ],
    );
  }
}
