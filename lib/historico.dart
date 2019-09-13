import 'dart:convert' as convert;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_arduino_sdm/historico.dart';
import 'package:flutter_arduino_sdm/utils/Leitura.dart';
import 'package:flutter_arduino_sdm/utils/nav.dart';
import 'package:flutter_arduino_sdm/utils/response.dart';
import 'package:http/http.dart' as http;

class HistoricoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de temperaturas'),
      ),
      body: Container(
        child: _buildBody(),
        alignment: Alignment.center,
      ),
    );
  }

  _buildBody() => FutureBuilder(
      future: getHistoricoTemp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Container(
              width: 200.0,
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 5.0,
              ),
            );
          default:
            print(snapshot);
            if (snapshot.hasError)
              return Text("Sem conexão com a internet");
            else
              return _table(snapshot.data);
        }
      });

  Future<List<Leitura>> getHistoricoTemp() async {
    final url = 'http://temperaturerest.herokuapp.com/listTemperatures/max';
    //final url = 'http://www.mocky.io/v2/5d70631e310000def2660b46';
    var header = {'Content-Type': 'application/x-www-form-urlencoded'};
    final response = await http.get(url, headers: header);
    final body = convert.utf8.decode(response.bodyBytes);
    final mapLeituras = convert.json.decode(body).cast<Map<String, dynamic>>();
    return mapLeituras.map<Leitura>((json) => Leitura.fromJson(json)).toList();
  }

  _table(List<Leitura> leituras) => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: _dataBody(leituras),
          ),
        ],
      );

  _dataBody(List<Leitura> leituras) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
//        sortAscending: sort,
//        sortColumnIndex: 0,
        columns: [
          DataColumn(
            label: Text("Icon", style: _textStyle()),
            numeric: false,
            tooltip: "Icone",
          ),
          DataColumn(
            label: Text("Temp", style: _textStyle()),
            numeric: false,
            tooltip: "Temperatura",
          ),
          DataColumn(
            label: Text("Umidade", style: _textStyle()),
            numeric: false,
            tooltip: "Umidade",
          )
        ],
        rows: leituras
            .map(
              (leitura) => DataRow(cells: [
                DataCell(Image.asset(
                    getImageByTemp(leitura.temperatura.toString()))),
                DataCell(
                  Text(
                    "${leitura.temperatura}°C",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                ),
                DataCell(
                  Text(
                    leitura.umidade.toString() + '%',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }

  _textStyle() => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      );

  String getImageByTemp(String tempAtual) {
    if (double.tryParse(tempAtual) > 28) {
      return "images/hot.jpg";
    } else {
      return "images/cold.jpg";
    }
  }
}
