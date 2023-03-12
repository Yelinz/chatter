import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatter/env/env.dart';
import 'package:chatter/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({super.key, required this.message});

  final ChatMessage message;

  @override
  State<MessageBox> createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox> {
  final urlTTS = Uri.https(
      "switzerlandnorth.tts.speech.microsoft.com", "cognitiveservices/v1");
  final urlTranslation = Uri.https("api-free.deepl.com", "v2/translate");
  final player = AudioPlayer();
  String translation = "";

  void textToAudio() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var file = File(
        '$tempPath/${base64.encode(utf8.encode(widget.message.content!))}');

    if (!(await file.exists())) {
      var response = await http.post(urlTTS, headers: {
        "Content-Type": "application/ssml+xml",
        "X-Microsoft-OutputForma": "audio-16khz-128kbitrate-mono-mp3",
        "Ocp-Apim-Subscription-Key": " ${Env.azureKey}"
      }, body: """
          '<speak version='\''1.0'\'' xml:lang='\''en-US'\''>
            <voice xml:lang='\''en-US'\'' xml:gender='\''Female'\'' name='\''en-US-JennyNeural'\''>
              ${widget.message.content}
            </voice>
          </speak>'
         """);

      if (response.statusCode != 200) {
        developer.log('tts error');
      } else {
        await file.writeAsBytes(response.bodyBytes);
      }
    }

    await player.play(DeviceFileSource(file.path));
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
