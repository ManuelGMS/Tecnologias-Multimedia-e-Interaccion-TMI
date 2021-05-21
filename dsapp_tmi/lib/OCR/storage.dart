// Almacenamiento en la API cloud de google

import 'dart:typed_data';
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:dsapptmi/Cloud/credentials.dart';

class CloudStorage {
  // Cliente

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    var _client = CredentialsProvider().clientstorage;

    // Instanciar el espacio en el cloud
    var storage = Storage(await _client, 'Image Upload Google Storage');
    var bucket = storage.bucket('tmi-bucket');

    // Trasferencia de contenido al cubo bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);

    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }
}
