import 'package:dsapptmi/Cloud/credentials.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:dsapptmi/OCR/processImage.dart';
import 'package:image/image.dart' as imgLib;
import 'dart:convert';
import 'package:camera/camera.dart';

class CloudOCR {
  var _client = CredentialsProvider().clientvision;

  String makeBase64(CameraImage frame) {
    String b52 = "";

    // Redimensiona la imagen
    imgLib.Image fotoPequenia = convertYUV420(frame);
    imgLib.copyResize(fotoPequenia, width: 300);

    // Conversion de imagen a png
    List<int> fotoMenosMal = convertImagetoPng(fotoPequenia);

    // Pasar a base 64
    b52 = base64Encode(fotoMenosMal);

    return b52;
  }

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
          },
          "features": [
            {"type": "TEXT_DETECTION"}
          ]
        }
      ]
    }));

    String ret;
    ret = _response.responses.first.textAnnotations.first.description;
    return ret;
  }
}
