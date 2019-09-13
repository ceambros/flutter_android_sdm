import 'package:flutter/material.dart';

checkConnection() => Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Text(
        "Nenhum dado encontrado. Verifique a conexão com a internet.",
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );

error() => Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Text(
        "Erro ao carregar os dados. Tente novamente.",
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );
