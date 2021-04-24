import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
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
}
