import 'package:dsapptmi/Cloud/credentials.dart';
import 'package:googleapis/vision/v1.dart';

class CloudOCR {
  var _client = CredentialsProvider().clientvision;

  // La imagen debe estar en base 64
  Future<String> /*Future<WebLabel>*/ ocr(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {
            "content":
                image /* "source": {"imageUri": "uri de la imagen subida al server"}*/
          }, // El comentario es para hacerlo con imagenes subidas
          "features": [
            {"type": "TEXT_DETECTION"}
          ]
        }
      ]
    }));

    /*
    WebLabel _bestGuessLabel;
    _response.responses.forEach((data) {
      var _label = data.webDetection.bestGuessLabels;
      _bestGuessLabel = _label.single;
    });

    return _bestGuessLabel;*/

    String ret;
    ret = _response.responses.first.textAnnotations.first.description;

    return ret;
  }
}
