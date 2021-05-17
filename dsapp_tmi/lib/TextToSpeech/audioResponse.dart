class AudioResponse {
  // Contenido que sera reproducido por la API de Google.
  final String audioContent;

  // Constructora AudioResponse
  AudioResponse(this.audioContent);

  // Constructora AudioResponse para convertir json a audioContent
  AudioResponse.fromJson(Map<String, dynamic> json)
      : audioContent = json['audioContent'];
}