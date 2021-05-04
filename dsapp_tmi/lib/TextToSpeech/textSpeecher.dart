import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'audioResponse.dart';

const BASE_URL = 'https://texttospeech.googleapis.com/v1/';

class TextToSpeechService {
  String _apiKey;

  TextToSpeechService([this._apiKey]);

  Future _playMp3File(AudioResponse response) async {
    AudioPlayer audioPlugin = AudioPlayer();
    if (audioPlugin.state == AudioPlayerState.PLAYING) {
      await audioPlugin.stop();
    }
    final bytes = Base64Decoder()
        .convert(response.audioContent, 0, response.audioContent.length);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/wavenet.mp3');
    await file.writeAsBytes(bytes);
    await audioPlugin.play(file.path, isLocal: true);
  }

  _getApiUrl(String endpoint) {
    return '$BASE_URL$endpoint?key=$_apiKey';
  }

  _getResponse(Future<http.Response> request) {
    return request.then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw (jsonDecode(response.body));
    });
  }

  Future availableVoices() async {
    const endpoint = 'voices';
    Future request = http.get(_getApiUrl(endpoint));
    try {
      await _getResponse(request);
    } catch (e) {
      throw (e);
    }
  }

  Future textToSpeech(
      {@required String text,
      String voiceName = 'es-ES-Wavenet-C',
      String audioEncoding = 'MP3',
      String languageCode = 'es-ES',
      String ssmlGender = 'FEMALE'}) async {
    const endpoint = 'text:synthesize';
    String body = '{'
        '"input": {"text":"$text"},'
        '"voice": {"languageCode": "$languageCode", "name": "$voiceName", "ssmlGender": "$ssmlGender"},'
        '"audioConfig": {"audioEncoding": "$audioEncoding"}'
        '}';
    Future request = http.post(_getApiUrl(endpoint), body: body);
    try {
      var response = await _getResponse(request);
      AudioResponse audioResponse = AudioResponse.fromJson(response);
      _playMp3File(audioResponse);
    } catch (e) {
      print("No se ha podido reproducir el audio");
    }
  }
}
