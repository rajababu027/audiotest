import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordScreen extends StatefulWidget {
  AudioRecordScreen({super.key});

  @override
  State<AudioRecordScreen> createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();
  bool isRecorderReady = false;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    print(path);
    final audioFile = File(path!);
    print('Recorded audio: ${File(path)}');
    audioPlayer.setSourceDeviceFile(path);
    // audioPlayer.play(path);
    // audioPlayer.setOnPlayer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorder.closeRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration =
                  snapshot.hasData ? snapshot.data!.duration : Duration.zero;

              String twoDigits(int n) => n.toString().padLeft(5);
              final twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
              final twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));
              return Center(
                child: Text(
                  '$twoDigitMinutes:$twoDigitSeconds',
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              );
            },
          ),
          ElevatedButton(
            child: Icon(
              recorder.isRecording ? Icons.stop : Icons.mic,
              size: 80,
            ),
            onPressed: () async {
              if (recorder.isRecording) {
                await stop();
              } else {
                await record();
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
