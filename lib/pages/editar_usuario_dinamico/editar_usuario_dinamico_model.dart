import '/flutter_flow/flutter_flow_util.dart';
import 'editar_usuario_dinamico_widget.dart' show EditarUsuarioDinamicoWidget;
import 'package:flutter/material.dart';

class EditarUsuarioDinamicoModel
    extends FlutterFlowModel<EditarUsuarioDinamicoWidget> {
  final formKey = GlobalKey<FormState>();

  TextEditingController? txtNombreTextController;
  TextEditingController? txtTelefonoTextController;
  String rol = 'usuario';
  String email = '';

  bool cargandoDatos = true;
  bool guardando = false;

  @override
  void initState(BuildContext context) {
    txtNombreTextController = TextEditingController();
    txtTelefonoTextController = TextEditingController();
  }

  @override
  void dispose() {
    txtNombreTextController?.dispose();
    txtTelefonoTextController?.dispose();
  }
}
