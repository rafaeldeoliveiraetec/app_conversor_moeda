import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=92fce8db";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    final realController = TextEditingController();
    final dolarController = TextEditingController();
    final euroController = TextEditingController();

    double dolar;
    double euro;

    void _realChanged(String text){
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }

    void _dolarChanged(String text){
      double valor = double.parse(text);
      realController.text = (valor * dolar).toStringAsFixed(2);
      euroController.text = (valor * dolar / euro).toStringAsFixed(2);
    }

    void _euroChanged(String text){
      double valor = double.parse(text);
      realController.text = (valor * euro).toStringAsFixed(2);
      euroController.text = (valor * euro / dolar).toStringAsFixed(2);
    }

    //print(getDados());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Conversor Moeda",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: //estado não tiver nada
            case ConnectionState.waiting: //estado esperando/carregando
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                //se da erro
                return Center(
                  child: Text(
                    "Erro ao carregar Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                //se não
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                //print(dolar);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextField(
                        controller: realController,
                        decoration: InputDecoration(
                          labelText: "Reais", labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$ ",
                        ),
                        style: TextStyle(color: Colors.amber,fontSize: 25.0),
                        onChanged: _realChanged,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        decoration: InputDecoration(
                          labelText: "Dólares", labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$ ",
                        ),
                        style: TextStyle(color: Colors.amber,fontSize: 25.0),
                        onChanged: _dolarChanged,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        decoration: InputDecoration(
                          labelText: "Euros", labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "€\$ ",
                        ),
                        style: TextStyle(color: Colors.amber,fontSize: 25.0),
                        onChanged: _euroChanged,
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    ); //é o widget com scroll,onde home vai ficar,inves container
  }

  Future<Map> getDados() async {
    http.Response response = await http.get(request);
    //print(response.body);
    return json.decode(response.body);
  }
}
