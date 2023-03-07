import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class MessageBox extends StatefulWidget {
  const MessageBox({super.key, required this.message});

  final Map message;

  @override
  State<MessageBox> createState() => _MessageBox();
}

class _MessageBox extends State<MessageBox> {
  final urlTTS = Uri.https(
      "switzerlandnorth.tts.speech.microsoft.com", "cognitiveservices/v1");
  final player = AudioPlayer();
  String translation = "";

  void textToSpeech() async {
    // TODO: Cache audio, as it stays the same, save in tmp
    var response = await http.post(urlTTS, headers: {
      "Content-Type": "application/ssml+xml",
      "X-Microsoft-OutputForma": "audio-16khz-128kbitrate-mono-mp3",
      "Ocp-Apim-Subscription-Key": "TODO KEY"
    }, body: """
          '<speak version='\''1.0'\'' xml:lang='\''en-US'\''>
            <voice xml:lang='\''en-US'\'' xml:gender='\''Female'\'' name='\''en-US-JennyNeural'\''>
              ${widget.message["content"]}
            </voice>
          </speak>'
         """);

    if (response.statusCode != 200) {
      developer.log('tts error');
    } else {
      response.bodyBytes;
    }
  }

  void playAudio() {
    player.stop();
    player.play(AssetSource(""));
  }

  void translateContent() {
    translation = widget.message["content"];
  }

  Widget getMessageBox() {
    if (widget.message["role"] == "user") {
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
                  widget.message["content"],
                  style: const TextStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: playAudio,
                        icon: const Icon(Icons.volume_up)),
                    IconButton(
                        onPressed: translateContent,
                        icon: const Icon(Icons.translate))
                  ],
                ),
                Visibility(
                  visible: translation != "",
                  child: Text(
                    translation,
                    style: const TextStyle(fontSize: 13),
                  ),
                )
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
