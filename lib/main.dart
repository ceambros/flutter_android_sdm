import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_arduino_sdm/historico.dart';
import 'package:flutter_arduino_sdm/utils/Leitura.dart';
import 'package:flutter_arduino_sdm/utils/nav.dart';
import 'package:flutter_arduino_sdm/utils/response.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Temperatura........',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Controle de Temperatura'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _tempAtual = "0";
  num temperatura = 0;

  @override
  void initState() {
    super.initState();
    mostrarTemperatura();
  }

  void mostrarTemperatura() {
    setState(() {
    });
    /*
    Future<Leitura> future = _getActualTemp();
    future.then((Leitura leitura) {
      setState(() {
        _tempAtual = (leitura.temperatura + 1).toString();
        if (temperatura == 0) {
          temperatura = leitura.temperatura;
        } else {
          temperatura = temperatura + 1;
        }
        print("5" + _tempAtual);
        _tempAtual = temperatura.toString();
      });
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: mostrarTemperatura,
          )
        ],
        title: Text(widget.title),
      ),
      body: Container(
        child: _buildBody(),
        alignment: Alignment.center,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, HistoricoPage());
        },
        tooltip: 'Histórico de temperatura',
        child: Icon(Icons.history),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String getImageByTemp(String tempAtual) {
    if (double.tryParse(tempAtual) > 28) {
      return "images/hot.jpg";
    } else {
      return "images/cold.jpg";
    }
  }

  Future<Leitura> _getActualTemp() async {

    //final url = 'http://temperaturerest.herokuapp.com/listTemperatures/max';
    final url = 'http://temperaturerest.herokuapp.com/temperature/getActual/';
    //final url = 'http://www.mocky.io/v2/5d71583b33000032c77798e7';
    var header = {'Content-Type': 'application/x-www-form-urlencoded'};
    final response = await http.get(url, headers: header);
    final body = convert.utf8.decode(response.bodyBytes);
    final mapLeituras = convert.json.decode(body).cast<Map<String, dynamic>>();
    List<Leitura> leituras =
        mapLeituras.map<Leitura>((json) => Leitura.fromJson(json)).toList();
    return leituras.elementAt(0);
  }

  _buildBody() => FutureBuilder(
      future: _getActualTemp(),
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
            if (snapshot.hasError) {
              print(snapshot.connectionState.toString());
              return Text(
                  "Sem conexão com a internet " + snapshot.error.toString());
            }else{
              return _paginaInicial(snapshot.data);}
        }
      });

  Stack _paginaInicial(Leitura leitura) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(leitura.data,
                  style: TextStyle(fontSize: 16, color: Colors.indigo)),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(getImageByTemp(leitura.temperatura.toString())),
                      Text(
                        leitura.temperatura.toString() + '°C',
                        style: Theme.of(context).textTheme.display1,
                      )
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/umidade.png'),
                      Text(
                        leitura.umidade.toString() + '%',
                        style: Theme.of(context).textTheme.display1,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
