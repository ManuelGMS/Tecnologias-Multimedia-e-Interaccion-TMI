import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:gcloud/storage.dart';

/**
 * Clase para obtener los creedenciales de acceso a la APIcan los mosquitos
 */
class CredentialsProvider {
  CredentialsProvider();

  Future<ServiceAccountCredentials> get _credentialsvision async {
    String _filevision = await rootBundle.loadString('assets/maenstorage.json');
    return ServiceAccountCredentials.fromJson(_filevision);
  }

  Future<ServiceAccountCredentials> get _credentialsstorage async {
    String _filestorage =
        await rootBundle.loadString('assets/maenstorage.json');
    return ServiceAccountCredentials.fromJson(_filestorage);
  }

  Future<ServiceAccountCredentials> get _credentialstextspeech async {
    String _fileSpeech =
    await rootBundle.loadString('assets/spach.json');
    return ServiceAccountCredentials.fromJson(_fileSpeech);
  }

  Future<AutoRefreshingAuthClient> get clientvision async {
    AutoRefreshingAuthClient _client = await clientViaServiceAccount(
        await _credentialsvision, [VisionApi.CloudVisionScope]).then((c) => c);
    return _client;
  }

  Future<AutoRefreshingAuthClient> get clientstorage async {
    AutoRefreshingAuthClient _client =
        await clientViaServiceAccount(await _credentialsstorage, Storage.SCOPES)
            .then((c) => c);
    return _client;
  }

  Future<AutoRefreshingAuthClient> get clientTextSpeech async {
    AutoRefreshingAuthClient _client = await clientViaServiceAccount(
        await _credentialstextspeech,[TexttospeechApi.CloudPlatformScope] ).then((c) => c);
    return _client;
  }

}
