import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'audioResponse.dart';

// URL de la API de google
const BASE_URL = 'https://texttospeech.googleapis.com/v1/';

class TextToSpeechService {
  // ApiKey del servicio
  String _apiKey;

  //Constructora de la clase con la ApiKey
  TextToSpeechService([this._apiKey]);

  // Reproduce el audio recibido en forma de AudioResponse
  Future _playMp3File(AudioResponse response) async {
    // Plugin para reproducir el audio
    AudioPlayer audioPlugin = AudioPlayer();
    // Si se esta reproducioendo el audio, este para para dar paso al nuevo recibido por parametro.
    // if (audioPlugin.state == AudioPlayerState.PLAYING) {
    //   await audioPlugin.stop();
    // }
    // Decodificador en base 64
    final bytes = Base64Decoder()
        .convert(response.audioContent, 0, response.audioContent.length);
    // Se obtiene el directorio temporal en el cual se ha guardado el audio
    final dir = await getTemporaryDirectory();
    // Se el archivo de audio del directorio temporal
    final file = File('${dir.path}/wavenet.mp3');
    // Se escribe en el archivo los bytes del audio
    await file.writeAsBytes(bytes);
    // Se reproduce el audio
    await audioPlugin.play(file.path, isLocal: true);
  }

  // Se obtiene la URL del servicio de Google.
  _getApiUrl(String endpoint) {
    return '$BASE_URL$endpoint?key=$_apiKey';
  }

  // Se obtiene la respuesta del servicio y se controlan los posibles errores.
  _getResponse(Future<http.Response> request) {
    return request.then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw (jsonDecode(response.body));
    });
  }
  // Función para llamar a la API de manera sencilla
  // Los parametros se han configurado por defecto.
  Future textToSpeech(
      {@required String text,
      String voiceName = 'es-ES-Wavenet-C',
      String audioEncoding = 'MP3',
      String languageCode = 'es-ES',
      String ssmlGender = 'FEMALE'}) async {
    // Declaracion del endpoint
    const endpoint = 'text:synthesize';

    // Se configuran los parametros necesarios para la llamada a la API
    String body = '{'
        '"input": {"text":"$text"},'
        '"voice": {"languageCode": "$languageCode", "name": "$voiceName", "ssmlGender": "$ssmlGender"},'
        '"audioConfig": {"audioEncoding": "$audioEncoding"}'
        '}';
    // Se obtiene la respuesta del servidor.
    Future request = http.post(_getApiUrl(endpoint), body: body);
    try {
      // Reproduccion del audio en el caso de exito
      var response = await _getResponse(request);
      AudioResponse audioResponse = AudioResponse.fromJson(response);
      _playMp3File(audioResponse);
    } catch (e) {
      // Mensaje de error si el no ha sido posible reproducir el audio
      print("No se ha podido reproducir el audio");
    }
  }
}
