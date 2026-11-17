import '/flutter_flow/flutter_flow_util.dart';
import 'crear_usuario_widget.dart' show CrearUsuarioWidget;
import 'package:flutter/material.dart';

class CrearUsuarioModel extends FlutterFlowModel<CrearUsuarioWidget> {
  final formKey = GlobalKey<FormState>();

  // txtEmail
  TextEditingController? txtEmailTextController;
  FocusNode? txtEmailFocusNode;

  // txtPassword
  TextEditingController? txtPasswordTextController;
  FocusNode? txtPasswordFocusNode;

  // Resultado del custom action createUsers.
  String? resultado;
  bool cargando = false;

  @override
  void initState(BuildContext context) {
    txtEmailTextController = TextEditingController();
    txtEmailFocusNode = FocusNode();
    txtPasswordTextController = TextEditingController();
    txtPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    txtEmailTextController?.dispose();
    txtEmailFocusNode?.dispose();
    txtPasswordTextController?.dispose();
    txtPasswordFocusNode?.dispose();
  }
}
