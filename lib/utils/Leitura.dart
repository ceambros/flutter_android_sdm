class Leitura {
  num temperatura;
  num umidade;
  String data;

  Leitura.fromJson(Map<String, dynamic> map)
      : temperatura = map["temperatura"],
        umidade = map["umidade"],
        data = map["data"];

  Map toMap() {
    Map<String, dynamic> map = {
      "temperatura": temperatura,
      "umidade": umidade,
      data: "data"
    };
    return map;
  }
}
