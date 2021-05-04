import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'audioResponse.dart';
import 'fileService.dart';

const BASE_URL = 'https://texttospeech.googleapis.com/v1beta1/';

// class TextToSpeechAPI {
//   static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();
//   final _httpClient = HttpClient();
//   static const _apiKey = "6a22605c586c86311f26c9d04f8476641ca422cb";
//   static const _apiURL = "texttospeech.googleapis.com";
//
//   factory TextToSpeechAPI() {
//     return _singleton;
//   }
//
//   TextToSpeechAPI._internal();
//
//   Future<dynamic> synthesizeText(String text) async {
//     try {
//       final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');
//       final Map json = {
//         'input': {'text': text},
//         'voice': {
//           'name': 'es-ES-Wavenet-C',
//           'languageCode': 'es-ES',
//           'ssmlGender': 'FEMALE'
//         },
//         'audioConfig': {'audioEncoding': 'MP3'}
//       };
//
//       final jsonResponse = await _postJson(uri, json);
//       if (jsonResponse == null) return null;
//       final String audioContent = await jsonResponse['audioContent'];
//       return audioContent;
//     } on Exception catch (e) {
//       print("$e");
//       return null;
//     }
//   }
//
//   Future<Map<String, dynamic>> _postJson(Uri uri, Map jsonMap) async {
//     try {
//       final httpRequest = await _httpClient.postUrl(uri);
//       final jsonData = utf8.encode(json.encode(jsonMap));
//       final jsonResponse =
//           await _processRequestIntoJsonResponse(httpRequest, jsonData);
//       return jsonResponse;
//     } on Exception catch (e) {
//       print("$e");
//       return null;
//     }
//   }
//
//   Future<Map<String, dynamic>> _getJson(Uri uri) async {
//     try {
//       final httpRequest = await _httpClient.getUrl(uri);
//       final jsonResponse =
//           await _processRequestIntoJsonResponse(httpRequest, null);
//       return jsonResponse;
//     } on Exception catch (e) {
//       print("$e");
//       return null;
//     }
//   }
//
//   Future<Map<String, dynamic>> _processRequestIntoJsonResponse(
//       HttpClientRequest httpRequest, List<int> data) async {
//     try {
//       httpRequest.headers.add('X-Goog-Api-Key', _apiKey);
//       httpRequest.headers.add(HttpHeaders.CONTENT_TYPE, 'application/json');
//       if (data != null) {
//         httpRequest.add(data);
//       }
//       final httpResponse = await httpRequest.close();
//       if (httpResponse.statusCode != HttpStatus.OK) {
//         throw Exception('Bad Response');
//       }
//       final responseBody = await httpResponse.transform(utf8.decoder).join();
//       return json.decode(responseBody);
//     } on Exception catch (e) {
//       print("$e");
//       return null;
//     }
//   }
//
//   void reproduceTexto(String text) async {
//     AudioPlayer audioPlugin = AudioPlayer();
//     if (audioPlugin.state == AudioPlayerState.PLAYING) {
//       await audioPlugin.stop();
//     }
//     final String audioContent = await TextToSpeechAPI().synthesizeText(text);
//     if (audioContent == null) return;
//     final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
//     final dir = await getTemporaryDirectory();
//     final file = File('${dir.path}/wavenet.mp3');
//     await file.writeAsBytes(bytes);
//     await audioPlugin.play(file.path, isLocal: true);
//   }
// }

class TextToSpeechService {
  String _apiKey = '6a22605c586c86311f26c9d04f8476641ca422cb';

  TextToSpeechService([this._apiKey]);

  Future<File> _createMp3File(AudioResponse response) async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = '$id.mp3';

    // Decode audio content to binary format and create mp3 file
    var bytes = base64.decode(response.audioContent);
    return FileService.createAndWriteFile(fileName, bytes);
  }

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

  Future<File> textToSpeech(
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
      return _createMp3File(audioResponse);
    } catch (e) {
      throw (e);
    }
  }
}
