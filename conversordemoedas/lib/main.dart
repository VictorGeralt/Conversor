import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const URL = 'https://api.hgbrasil.com/finance?format=json&key=cab75d3b';

void main() async{
  runApp(new MaterialApp(
    home: new Home(),
    theme: ThemeData(hintColor: Colors.black , primaryColor: Colors.red[500]),
  ));
}

Future<Map> getDados() async{
  http.Response response = await http.get(URL);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = new TextEditingController();
  final dolarController = new TextEditingController();
  final euroController = new TextEditingController();

  var dolar = 0.0;
  var euro = 0.0;
  
  void _digitouReal(String text){
    if(text.isEmpty){
      _limparCampos();
      return;
    }
    var valor = double.parse(text);
    dolarController.text = (valor/dolar).toStringAsFixed(2);
    euroController.text = (valor/euro).toStringAsFixed(2);
      }
  


    void _digitouDolar(String text){
    if(text.isEmpty){
      _limparCampos();
      return;
    }
    var valor = double.parse(text);
    realController.text = (valor * dolar).toStringAsFixed(2);
    euroController.text = (valor * dolar/euro).toStringAsFixed(2);
    }



    void _digitouEuro(String text){
    if(text.isEmpty){
      _limparCampos();
      return;
    }
    var valor = double.parse(text);
    realController.text = (valor * euro).toStringAsFixed(2);
    dolarController.text = (valor * euro/dolar).toStringAsFixed(2);
    }

    void _limparCampos(){
      realController.text ="";
      dolarController.text = "";
      euroController.text = "";
    }
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(title: Text('Conversor de Moeda\$'),
      backgroundColor: Colors.red,
      centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getDados(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text('Carregando...',
              style: TextStyle(color: Colors.red, fontSize: 25),
              textAlign: TextAlign.center,
              );
              default:
              if (snapshot.hasError) {
              return Text('Erro ao carregar dados',
              style: TextStyle(color: Colors.red, fontSize: 25),
              textAlign: TextAlign.center,);
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["UER"]["buy"];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 150,
                      color: Colors.red,
                    ),
                    buildTextField('Reais','R\$',realController,_digitouReal),
                    Divider(),
                    buildTextField('Dólar','US\$',dolarController,_digitouDolar),
                    Divider(),
                    buildTextField('Euro','€',realController,_digitouEuro)
                    
                  ],
                ),
              );
              }
          }
        }
      )
    );
  }
}

Widget buildTextField(String label,String prefixo, TextEditingController controlador, Function funcao){
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(),
      prefixText: prefixo),
    style: TextStyle(color: Colors.red, fontSize: 25),
    controller: controlador,
    onChanged: funcao,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}