import 'dart:typed_data';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

import 'credentials.dart';

class CloudStorage {
  // Cliente
  //var _client = CredentialsProvider().clientstorage;

  // final auth.ServiceAccountCredentials _credentials;
  // auth.AutoRefreshingAuthClient _client;

  // CloudStorage(String json)
  //     : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    var _client = CredentialsProvider().clientstorage;
    // if (_client == null)
    //   _client = await auth.clientViaServiceAccount(
    //       CredentialsProvider()._credentialsstorage, Storage.SCOPES);

    // Instanciar en la nube hasta en dias despejados
    var storage = Storage(await _client, 'Image Upload Google Storage');
    var bucket = storage.bucket('tmi-bucket');

    // Al cubo bucket
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
