import 'credentials.dart';
import 'package:googleapis/vision/v1.dart';

class RekognizeProvider {
  var _client = CredentialsProvider().client;

  // La imagen debe estar en base 64
  Future<WebLabel> search(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image /* "source": {"imageUri": "uri de la imagen subida al server"}*/}, // El comentario es para hacerlo con imagenes subidas
          "features": [
            {"type": "TEXT_DETECTION"}
          ]
        }
      ]
    }));

    WebLabel _bestGuessLabel;
    _response.responses.forEach((data) {
      var _label = data.webDetection.bestGuessLabels;
      _bestGuessLabel = _label.single;
    });

    return _bestGuessLabel;
  }
}