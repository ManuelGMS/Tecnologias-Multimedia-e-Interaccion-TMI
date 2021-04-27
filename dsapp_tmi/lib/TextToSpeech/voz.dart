class Voz {
  final String name;
  final String gender;
  final List<String> languageCodes;

  Voz(this.name, this.gender, this.languageCodes);

  static List<Voz> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((v) {
      return Voz(v['name'], v['ssmlGender'], List<String>.from(v['languageCodes']));
    }).toList();
  }

}