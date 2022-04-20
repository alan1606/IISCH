import 'package:flutter/material.dart';
import 'package:evaluaciones_web/ui/shared/custom_flat_button.dart';


class View404 extends StatelessWidget {
  
  const View404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle( fontSize: 40, fontWeight: FontWeight.bold )),
            const SizedBox(height: 10),
            const Text('No se encontró la página', style: TextStyle( fontSize: 20 )),
            const SizedBox(height: 15),
            CustomFlatButton(
              text: 'Regresar',
              color: Colors.grey, 
              onPressed: () => Navigator.pushNamed(context, '/inicio')
            ),
          ],
        ),
      ),
    );
  }
}


