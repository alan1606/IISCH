import 'package:fluro/fluro.dart';
import 'package:evaluaciones_web/router/route_handlers.dart';


class Flurorouter {
  
  static final FluroRouter router = FluroRouter();

  static void configureRoutes() {

    router.define('/inicio', handler: inicioHandler, transitionType: TransitionType.fadeIn );

    // Evaluaciones
    router.define('/evaluaciones', handler: evaluacionesHandler, transitionType: TransitionType.fadeIn );
    router.define('/evaluaciones/:base', handler: newEvaluacionHandler, transitionType: TransitionType.fadeIn );

    //View Evaluaciones Alumnos
    router.define('/registrosdocente', handler: tegistrosBaseHandler, transitionType: TransitionType.fadeIn );
    router.define('/aplicarcuestionario', handler: contestarBaseHandler, transitionType: TransitionType.fadeIn );
    
    //Login
    router.define('/cuenta', handler: loginHandler, transitionType: TransitionType.fadeIn );

    //Resultados
    router.define('/resultados', handler: resultadosHandler, transitionType: TransitionType.fadeIn );
    router.define('/resultados/listas', handler: resultadosListaHandler, transitionType: TransitionType.fadeIn );
    router.define('/resultados/listas/revision', handler: comparativaRespuestasHandler, transitionType: TransitionType.fadeIn );
    router.define('/resultados/graficos', handler: graficosHandler, transitionType: TransitionType.fadeIn );

    // 404 - Not Page Found
    router.notFoundHandler = pageNotFound;

  }

}