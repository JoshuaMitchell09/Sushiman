import '/flutter_flow/flutter_flow_util.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  final formKey = GlobalKey<FormState>();

  // txtEmail
  TextEditingController? txtEmailTextController;
  FocusNode? txtEmailFocusNode;

  // txtPassword
  TextEditingController? txtPasswordTextController;
  FocusNode? txtPasswordFocusNode;

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
