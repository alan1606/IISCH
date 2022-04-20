import 'package:evaluaciones_web/ui/views/evaluaciones/alumno/contestar_preguntas_view.dart';
import 'package:evaluaciones_web/ui/views/evaluaciones/alumno/evaluaciones_alumnos_view.dart';
import 'package:evaluaciones_web/ui/views/evaluaciones/evaluaciones_view.dart';
import 'package:evaluaciones_web/ui/views/evaluaciones/new_evaluacion_view.dart';
import 'package:evaluaciones_web/ui/views/inicio_view.dart';
import 'package:evaluaciones_web/ui/views/login/login_o_nologin.dart';
import 'package:evaluaciones_web/ui/views/resultados/comparativa_respuestas_view.dart';
import 'package:evaluaciones_web/ui/views/resultados/graficas_view.dart';
import 'package:evaluaciones_web/ui/views/resultados/resultados_listas.dart';
import 'package:evaluaciones_web/ui/views/resultados/resultados_view.dart';
import 'package:fluro/fluro.dart';
import 'package:evaluaciones_web/ui/views/view_404.dart';

//Inicio
final inicioHandler = Handler(
  handlerFunc: ( context , params ){  
    return const InicioView();
  }
);

//Evaluaciones
final evaluacionesHandler = Handler(
  handlerFunc: ( context , params ){  
    return const EvaluacionView();
  }
);

final newEvaluacionHandler = Handler(
  handlerFunc: ( context , params ){  
    return NewEvaluacionView( base: params['base']?.first ?? 'Evaluacion' );
  }
);

//Login
final loginHandler = Handler(
  handlerFunc: ( context, params ){
    return const LoginNoLogin();
  }
);

//Resultados
final resultadosHandler = Handler(
  handlerFunc: ( context, params ){
    return const MenuResultadosView();
  }
);

final graficosHandler = Handler(
  handlerFunc: ( context, params ){
    return const GraficasView();
  }
);

final tegistrosBaseHandler = Handler(
  handlerFunc: ( context, params ){
    return const EvaluacionesAlumnosView();
  }
);

final resultadosListaHandler = Handler(
  handlerFunc: ( context, params ){
    return const ResultadosListas();
  }
);

final comparativaRespuestasHandler = Handler(
  handlerFunc: ( context, params ){
    return const ComparativaRespuestasView();
  }
);

final contestarBaseHandler = Handler(
  handlerFunc: ( context, params ){
    return const ContestarPreguntasView();
  }
);

//404
final pageNotFound = Handler(
  handlerFunc: ( _ , __ ) => const View404()
);