import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/ui/shared/custom_app_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainLayoutPage extends StatelessWidget {
  
  final Widget child;

  const MainLayoutPage({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => VariablesGlobalesProvider(),
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: child
              ),
              Align(
                alignment: (size >= 450) ? Alignment.topCenter : Alignment.topLeft,
                child: const CustomAppMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

