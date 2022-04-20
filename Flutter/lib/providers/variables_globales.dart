import 'package:flutter/material.dart';

class VariablesGlobalesProvider with ChangeNotifier {

  int _posicionLogin = 0;
  String _docReferenciEdit = '';
  String _coleccionReferen = '';
  String _docente = '';
  String _materia = '';
  String _referenciaContestar = '';

  List<dynamic> _listResCorrect = [];
  List<dynamic> _listResAlumno  = [];
  List<String> _listTipoPregunta = [];
  List<String> _listPreguntas = [];
  String _currentAlumno = '';
  String _referenciaDocumentoID = '';
  List<Map<String,dynamic>> _respuestasCuestionario = [];
  List<List<dynamic>> _listRespuestasTodosAlumnos = [];
  List<String> _alumnos = [];

  String _ubicacionRuta = 'inicio';
  bool _mostrarMenu = false;

  // Seccion de ver resultados
  List<dynamic> get listResCorrect => _listResCorrect;
  set listResCorrect(List<dynamic> value){
    _listResCorrect = value;
    notifyListeners();
  }
  List<dynamic> get listResAlumno => _listResAlumno;
  set listResAlumno(List<dynamic> value){
    _listResAlumno = value;
    notifyListeners();
  }
  List<String> get listTipoPregunta => _listTipoPregunta;
  set listTipoPregunta(List<String> value){
    _listTipoPregunta = value;
    notifyListeners();
  }
  List<String> get listPreguntas => _listPreguntas;
  set listPreguntas(List<String> value){
    _listPreguntas = value;
    notifyListeners();
  }
  String get currentAlumno => _currentAlumno;
  set currentAlumno(String value){
    _currentAlumno = value;
    notifyListeners();
  }
  String get referenciaDocumentoID => _referenciaDocumentoID;
  set referenciaDocumentoID(String value){
    _referenciaDocumentoID = value;
    notifyListeners();
  }
  List<Map<String,dynamic>> get respuestasCuestionario => _respuestasCuestionario;
  set respuestasCuestionario(List<Map<String,dynamic>> value){
    _respuestasCuestionario = value;
    notifyListeners();
  }
  List<List<dynamic>> get listRespuestasTodosAlumnos => _listRespuestasTodosAlumnos;
  set listRespuestasTodosAlumnos(List<List<dynamic>> value){
    _listRespuestasTodosAlumnos = value;
    notifyListeners();
  }
  List<String> get alumnos => _alumnos;
  set alumnos(List<String> value){
    _alumnos = value;
    notifyListeners();
  }

  int get posicionLogin => _posicionLogin;
  set posicionLogin(int value){
    _posicionLogin = value;
    notifyListeners();
  }

  String get docReferenciEdit => _docReferenciEdit;
  set docReferenciEdit(String value){
    _docReferenciEdit = value;
    notifyListeners();
  }

  String get coleccionReferen => _coleccionReferen;
  set coleccionReferen(String value){
    _coleccionReferen = value;
    notifyListeners();
  }

  String get docente => _docente;
  set docente(String value){
    _docente = value;
    notifyListeners();
  }

  String get materia => _materia;
  set materia(String value){
    _materia = value;
    notifyListeners();
  }

  String get referenciaContestar => _referenciaContestar;
  set referenciaContestar(String value){
    _referenciaContestar = value;
    notifyListeners();
  }

  String get ubicacionRuta => _ubicacionRuta;
  set ubicacionRuta(String value){
    _ubicacionRuta = value;
    notifyListeners();
  }

  bool get mostrarMenu => _mostrarMenu;
  set mostrarMenu(bool value){
    _mostrarMenu = value;
    notifyListeners();
  }
}