import '/flutter_flow/flutter_flow_util.dart';
import 'listar_usuario_dinamico_widget.dart' show ListarUsuarioDinamicoWidget;
import 'package:flutter/material.dart';

class ListarUsuarioDinamicoModel
    extends FlutterFlowModel<ListarUsuarioDinamicoWidget> {
  // Resultado del custom action exportarUsuariosCSV.
  String? resultadoCSV;
  bool exportando = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
