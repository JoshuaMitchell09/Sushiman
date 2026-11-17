import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/usuarios_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_model.dart';
export 'login_model.dart';

/// Inicio de sesión del administrador. Solo un usuario autenticado puede
/// entrar a "Listar usuario dinámico" y crear, editar o eliminar usuarios.
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _traducirError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'El usuario está deshabilitado';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'email-already-in-use':
        return 'El correo electrónico ya está registrado';
      case 'weak-password':
        return 'La contraseña debe tener al menos seis caracteres';
      case 'operation-not-allowed':
        return 'Habilite "Correo/contraseña" en Firebase Authentication';
      default:
        return 'Error: ${e.code}';
    }
  }

  Future<void> _ingresar({required bool crearCuenta}) async {
    if (!(_model.formKey.currentState?.validate() ?? false)) return;
    setState(() => _model.cargando = true);
    final correo = _model.txtEmailTextController!.text.trim();
    final pass = _model.txtPasswordTextController!.text;
    try {
      if (crearCuenta) {
        // Primer administrador: cuenta normal (Create Account) y su
        // documento en la colección "users".
        final cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: correo, password: pass);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'uid': cred.user!.uid,
          'email': correo,
          'display_name': 'Administrador',
          'phone_number': '',
          'role': 'admin',
          'created_time': DateTime.now(),
        });
      } else {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: correo, password: pass);
      }
      if (!mounted) return;
      context.goNamed(ListarUsuarioDinamicoWidget.routeName);
    } on FirebaseAuthException catch (e) {
      if (mounted) showSnackbar(context, _traducirError(e));
    } catch (e) {
      if (mounted) showSnackbar(context, 'Error inesperado: $e');
    } finally {
      if (mounted) setState(() => _model.cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: appBarUsuarios(
          context,
          titulo: 'Iniciar sesión',
          onAtras: () => context.goNamed(HomeWidget.routeName),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520.0),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 72.0,
                            color: theme.primary,
                          ),
                        ),
                        Text(
                          'Administración de usuarios',
                          style: theme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        CampoTexto(
                          controller: _model.txtEmailTextController!,
                          focusNode: _model.txtEmailFocusNode,
                          etiqueta: 'Ingrese su correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: Validar.email,
                          textInputAction: TextInputAction.next,
                        ),
                        CampoTexto(
                          controller: _model.txtPasswordTextController!,
                          focusNode: _model.txtPasswordFocusNode,
                          etiqueta: 'Ingrese su contraseña',
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          esPassword: true,
                          validator: Validar.password,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              _ingresar(crearCuenta: false),
                        ),
                        BotonPrincipal(
                          texto: 'Ingresar',
                          icono: Icons.login_rounded,
                          cargando: _model.cargando,
                          onPressed: () => _ingresar(crearCuenta: false),
                        ),
                        TextButton(
                          onPressed: _model.cargando
                              ? null
                              : () => _ingresar(crearCuenta: true),
                          child: Text(
                            '¿Primera vez? Crear cuenta de administrador',
                            style: theme.bodyMedium
                                .copyWith(color: theme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
