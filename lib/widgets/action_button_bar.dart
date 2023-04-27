import 'dart:io';
import 'package:chatter/models/recording_status.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ActionButtonBar extends StatefulWidget {
  const ActionButtonBar({super.key, required this.recordingFinished});

  final Future Function(File) recordingFinished;

  @override
  State<ActionButtonBar> createState() => _ButtonBar();
}

class _ButtonBar extends State<ActionButtonBar> {
  Column _buildButtonColumn(
      ColorScheme colors, IconData icon, VoidCallback callback) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: callback,
          style: IconButton.styleFrom(
            foregroundColor: colors.onSecondaryContainer,
            backgroundColor: colors.secondaryContainer,
            disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
            hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
            focusColor: colors.onSecondaryContainer.withOpacity(0.12),
            highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
          ),
        ),
      ],
    );
  }

  RecordingStatus status = RecordingStatus.idle;
  final record = Record();
  File? file;

  void startRecording() async {
    // Check and request permission
    if (await record.hasPermission()) {
      // Start recording
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      file = File('$tempPath/input.m4a');

      await record.start(path: file!.path);
      setState(() {
        status = RecordingStatus.recording;
      });
    }
  }

  void stopRecording() async {
    await record.stop();
    setState(() {
      status = RecordingStatus.loading;
    });
    await widget.recordingFinished(file!);
    setState(() {
      status = RecordingStatus.idle;
    });
  }

  void cancelRecording() async {
    await record.stop();
    setState(() {
      status = RecordingStatus.idle;
    });
  }

  void showSuggestions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        // create custom list items instead later to facilitate translation and audio
        // https://api.flutter.dev/flutter/material/ListTile-class.html
        return ListView(
          children: const <Widget>[
            Card(
              child: ListTile(
                title: Text('I am doing fine, how about you?'),
                trailing: Icon(Icons.translate),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Goodbye see you later.'),
                trailing: Icon(Icons.translate),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Thank you.'),
                trailing: Icon(Icons.translate),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    var actions = <Widget>[
      _buildButtonColumn(colors, Icons.mic, startRecording),
      _buildButtonColumn(colors, Icons.question_mark, showSuggestions),
      // add button to display hints
      // hint generation by feeding the current chat to model and generate example responses
    ];

    if (status == RecordingStatus.recording) {
      actions = <Widget>[
        _buildButtonColumn(colors, Icons.delete, cancelRecording),
        _buildButtonColumn(colors, Icons.check, stopRecording),
      ];
    } else if (status == RecordingStatus.loading) {
      actions = <Widget>[const CircularProgressIndicator()];
    }

    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 15, top: 10),
            height: 100,
            width: double.infinity,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions)));
  }
}
