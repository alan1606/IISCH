// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';

import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';

import '../../../locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GraficasView extends StatefulWidget {
  const GraficasView({ Key? key }) : super(key: key);

  @override
  _GraficasViewState createState() => _GraficasViewState();
}

class _GraficasViewState extends State<GraficasView> {
  
  List<dynamic> respuestasCorrectas = [];
  List<String> tipoPregunta = [];
  List<List<dynamic>> respuestasAlumnos = [];
  List<String> preguntasTitulo = [];
  List<Map<String,dynamic>> respuestasCuestionario = [];

  List<Map<String,dynamic>> dataPreguntas = [];
  List<Map<int,dynamic>> listaR = [];
  List<Map<int,dynamic>> listaRTitulos = [];

  List<String> nombresAlumnos = [];
  List<List<String>> respuestasForExcel = [];
  
  @override
  void initState() {
    super.initState();
    recuperarData();
  }

  void recuperarData() async {
    if(FirebaseAuth.instance.currentUser == null){
      locator<NavigationService>().navigateTo('/cuenta');
    } else {

      final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
      
      respuestasCorrectas = modeloDatos.listResCorrect;
      tipoPregunta = modeloDatos.listTipoPregunta;
      respuestasAlumnos = modeloDatos.listRespuestasTodosAlumnos;
      preguntasTitulo = modeloDatos.listPreguntas;
      respuestasCuestionario = modeloDatos.respuestasCuestionario;
      nombresAlumnos = modeloDatos.alumnos;

      List<Map<int,dynamic>> listaRespuestasAux = List<Map<int,dynamic>>.generate(
        preguntasTitulo.length, (i) => {}
      );

      List<Map<int,dynamic>> listaResTitulosAux = List<Map<int,dynamic>>.generate(
        preguntasTitulo.length, (i) => {}
      );

      for(int mj = 0; mj < preguntasTitulo.length; mj++){
        for(int j = 0; j < respuestasCuestionario[mj].length; j++){
          listaResTitulosAux[mj].addEntries({ j : respuestasCuestionario[mj]['Op$j'].toString()}.entries);
        }        
      }

      for(int mj = 0; mj < preguntasTitulo.length; mj++){
        for(int j = 0; j < respuestasCuestionario[mj].length; j++){
          listaRespuestasAux[mj].addEntries({j : 0}.entries);
        }        
      }

      for(int m = 0; m < listaRespuestasAux.length; m++){
        for(int j = 0; j < listaRespuestasAux[m].length; j++){
          for(int mj = 0; mj < respuestasAlumnos.length; mj++){
            if(j == respuestasAlumnos[mj][m]){
              listaRespuestasAux[m].update(respuestasAlumnos[mj][m], (value) => value + 1);
            }              
          }
        }
      }

      listaR = listaRespuestasAux;
      listaRTitulos = listaResTitulosAux;

      List<Map<int,dynamic>> respuestasExcelAux = List<Map<int,dynamic>>.generate(
        respuestasAlumnos.length, (i) => {}
      );

      //Create Data para descarga Excel
      for(int m = 0; m < respuestasAlumnos.length; m++){
        respuestasExcelAux[m].addEntries({0: nombresAlumnos[m]}.entries);
        for(int j = 0; j < respuestasAlumnos[m].length; j++){
          if(tipoPregunta[j] == 'a'){
            respuestasExcelAux[m].addEntries({(j + 1): respuestasCuestionario[j]['Op${respuestasAlumnos[m][j]}']}.entries);
          } else {
            if(respuestasAlumnos[m][j].toString().contains('1102')){
              String newRespuesta = respuestasAlumnos[m][j].toString().substring(0, (respuestasAlumnos[m][j].toString().length - 4));
              respuestasExcelAux[m].addEntries({(j + 1): newRespuesta}.entries);
            } else {
              respuestasExcelAux[m].addEntries({(j + 1): respuestasAlumnos[m][j]}.entries);
            }
          }
        }
      }

      List<Map<int,dynamic>> titulosTabla = [{}];
      for(int mj = 0; mj < preguntasTitulo.length + 1; mj++){
        if(mj == 0){
          titulosTabla[0].addEntries({0 : 'Nombre'}.entries);
        } else {
          titulosTabla[0].addEntries({mj : preguntasTitulo[mj - 1]}.entries);
        }
      }

      List<Map<int,dynamic>> respuestasExcel = [];
      respuestasExcel = titulosTabla + respuestasExcelAux;

      List<List<String>> listStringTitulos = List<List<String>>.generate(
        respuestasExcel.length, (i) => []
      );
      for(int j = 0; j < respuestasExcel.length; j++){
        for(int m = 0; m < respuestasExcel[j].length; m++){
          listStringTitulos[j].add(respuestasExcel[j][m]);
        }
      }
      respuestasForExcel = listStringTitulos;

      if(mounted){
        setState(() {});
      }
    }    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          const SizedBox(height: 80),
          _titulo(),
          const SizedBox(height: 50),
          _listaExamEval()
        ],
      ),
    );
  }

  Widget _titulo(){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(modeloDatos.referenciaContestar, style: const TextStyle(color: Colors.black, fontSize: 15)),
              const SizedBox(
                width: 50,
                child: Divider(color: Colors.grey),
              ),
              const Text('Resultados Gráficos', style: TextStyle(color: Colors.black, fontSize: 13)),
            ],
          ),
          const Spacer(),
          _descargarGraficas()
        ],
      )
    );
  }

  Widget _descargarGraficas(){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=> _saveExcel(),
        child: Container(
          height: 30,
          alignment: AlignmentDirectional.center,
          width: 80,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(23, 139, 246, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(CupertinoIcons.cloud_download, color: Colors.white)
        ),
      ),
    );
  }

  void _saveExcel() async {

    DateTime fechaHoy = DateTime.now();
    String fechaString = '';
    String horaString  = '';
    String miliSecond  = DateTime.now().millisecond.toString();

    if ((fechaHoy.day <= 9) && (fechaHoy.month <= 9)){
      fechaString = '${fechaHoy.year}-0${fechaHoy.month}-0${fechaHoy.day}';
    } if ((fechaHoy.day <= 9) && (fechaHoy.month >= 10)){
      fechaString = '${fechaHoy.year}-${fechaHoy.month}-0${fechaHoy.day}';
    } if ((fechaHoy.day >= 10) && (fechaHoy.month <= 9)){
      fechaString = '${fechaHoy.year}-0${fechaHoy.month}-${fechaHoy.day}';
    } if ((fechaHoy.day >= 10) && (fechaHoy.month >= 10)){
      fechaString = '${fechaHoy.year}-${fechaHoy.month}-${fechaHoy.day}';
    }

    if ((fechaHoy.hour <= 9) && (fechaHoy.minute <= 9)){
      horaString = '0${fechaHoy.hour}0${fechaHoy.minute}';
    } if ((fechaHoy.hour <= 9) && (fechaHoy.minute >= 10)){
      horaString = '0${fechaHoy.hour}${fechaHoy.minute}';
    } if ((fechaHoy.hour >= 10) && (fechaHoy.minute <= 9)){
      horaString = '${fechaHoy.hour}0${fechaHoy.minute}';
    } if ((fechaHoy.hour >= 10) && (fechaHoy.minute >= 10)){
      horaString = '${fechaHoy.hour}${fechaHoy.minute}';
    }

    Excel descargaData = Excel.createExcel();
    descargaData.rename('Sheet1', 'Respuestas');
    
    for(int mj = 0; mj < respuestasForExcel.length; mj++){
      descargaData.insertRowIterables('Respuestas', respuestasForExcel[mj], mj);
    }

    if(kIsWeb){
      List<int>? fileBytes = descargaData.encode();
      String _base64 = base64Encode(fileBytes!);
      final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
      ..setAttribute('download', 'Respuestas-$fechaString-$horaString-$miliSecond.xlsx');
      anchor.click();
      anchor.remove();
      return;
    } else {
      Directory directory = await getApplicationDocumentsDirectory();
      List<int>? fileBytes = descargaData.save();
      File("${directory.path}/Respuestas-$fechaString-$horaString-$miliSecond.xlsx").writeAsBytes(fileBytes!);
    }
  }

  Widget _listaExamEval(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listaR.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemTipeCuestionario(index);
      },
    );
  }

  Widget _itemTipeCuestionario(int index){

    Map<String,double> data = {};

    if(listaR.isNotEmpty){
      for(int j = 0; j < listaRTitulos[index].length; j++){
        double valor = listaR[index][j].toDouble();
        data.addEntries({listaRTitulos[index][j].toString() : valor}.entries);
      }
    }
    
    List<Color> colores = [
      Colors.lime.shade600,
      Colors.pink.shade400,
      Colors.cyan.shade700,
      Colors.orangeAccent,
      Colors.red.shade400,
      Colors.teal,
      Colors.blue,
      Colors.pink,
      Colors.teal.shade700,
      Colors.orange,
      Colors.green,
      Colors.deepOrange.shade300,
      Colors.redAccent.shade400,
      Colors.purple,
      Colors.cyan,
      Colors.blueGrey,
      Colors.brown.shade300,
      Colors.indigo,
      Colors.redAccent.shade100,
      Colors.lightGreen.shade600,
      Colors.indigo.shade400,
    ];

    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _textModel(preguntasTitulo[index], false, 13, Colors.white),
            ],
          ),
          const Spacer(),
          _grafica(data, colores),
          const Spacer(),
        ],
      )
    );
  }

  Widget _grafica(Map<String,double> data, List<Color> colores){
    if(data.isNotEmpty){
      return PieChart(
        dataMap: data,
        animationDuration: const Duration(milliseconds: 100),
        chartLegendSpacing: 32,
        chartRadius: 130,
        colorList: colores,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
          chartValueStyle: TextStyle(color: Colors.white, fontSize: 12)
        ),
      );
    } else {
      return Center(child: _textModel('Grafica no disponible en preguntas abiertas.', false, 12, Colors.white));
    }
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont, Color color){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
        color: color,
        overflow: TextOverflow.visible
      )
    );
  }
}