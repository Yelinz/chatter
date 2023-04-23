import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatter/env/env.dart';
import 'package:chatter/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';

import 'package:wavenet/wavenet.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({super.key, required this.message});

  final ChatMessage message;

  @override
  State<MessageBox> createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox> {
  final urlTranslation = Uri.https("api-free.deepl.com", "v2/translate");
  final player = AudioPlayer();
  String translation = "";
  File? audio;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.message.role == MessageRole.assistant) {
      playAudio();
    }
  }

  void textToAudio() async {
    developer.log('start audio');
    if (audio == null) {
      TextToSpeechService service = TextToSpeechService(Env.gcpKey);
      audio = await service.textToSpeech(
        text: widget.message.content!,
        voiceName: 'en-US-Neural2-A',
        audioEncoding: 'MP3',
        languageCode: 'en-us',
        pitch: 0.0,
        speakingRate: 1.0,
      );
    }


    developer.log(audio!.path);
    await player.play(DeviceFileSource(audio!.path));
  }

  void playAudio() {
    player.stop();
    textToAudio();
  }

  void translateContent() async {
    var response = await http.post(urlTranslation, headers: {
      "Authorization": "DeepL-Auth-Key ${Env.deeplKey}"
    }, body: {
      "target_lang": "DE",
      "text": widget.message.content,
      "formality": "prefer_less",
      "source_lang": "EN"
    });

    if (response.statusCode != 200) {
      developer.log('translation error');
    } else {
      setState(() {
        translation = json
            .decode(utf8.decode(response.bodyBytes))["translations"][0]["text"];
      });
    }
  }

  Widget getMessageBox() {
    if (widget.message.role == MessageRole.user) {
      return Align(
          alignment: Alignment.topRight,
          child: FractionallySizedBox(
            widthFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[200],
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.message.content!,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ));
    }

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: FractionallySizedBox(
            widthFactor: 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.message.content!,
                  style: const TextStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: playAudio,
                        icon: const Icon(Icons.volume_up)),
                    IconButton(
                        onPressed: translation != "" ? null : translateContent,
                        icon: const Icon(Icons.translate)),
                  ],
                ),
                Visibility(
                    visible: translation != "",
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Text(
                        translation,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
        child: getMessageBox());
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
