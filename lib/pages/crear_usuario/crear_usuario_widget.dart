import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/usuarios_ui.dart';
import 'package:flutter/material.dart';
import 'crear_usuario_model.dart';
export 'crear_usuario_model.dart';

/// Práctica clase 3: ventana "Crear usuario".
/// Dos campos (correo y contraseña) dentro de un Form con validación y el
/// botón "Crear usuario", que ejecuta el custom action `createUsers`.
class CrearUsuarioWidget extends StatefulWidget {
  const CrearUsuarioWidget({super.key});

  static String routeName = 'CrearUsuario';
  static String routePath = '/crearUsuario';

  @override
  State<CrearUsuarioWidget> createState() => _CrearUsuarioWidgetState();
}

class _CrearUsuarioWidgetState extends State<CrearUsuarioWidget> {
  late CrearUsuarioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CrearUsuarioModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _crearUsuario() async {
    // 1. Validate Form
    if (!(_model.formKey.currentState?.validate() ?? false)) return;

    // 2. Custom Action: createUsers
    setState(() => _model.cargando = true);
    _model.resultado = await actions.createUsers(
      _model.txtEmailTextController!.text,
      _model.txtPasswordTextController!.text,
      'secundaria',
    );
    if (!mounted) return;
    setState(() => _model.cargando = false);

    // 3. Show Snack Bar con el resultado
    showSnackbar(context, _model.resultado!);

    // 4. Si se creó, vuelve a la lista
    if (_model.resultado == 'Usuario creado') {
      context.goNamed(ListarUsuarioDinamicoWidget.routeName);
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
          titulo: 'Crear usuario',
          // Navigate To: listar usuario dinámico
          onAtras: () =>
              context.goNamed(ListarUsuarioDinamicoWidget.routeName),
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
                          child: Icon(Icons.person_add_alt_1_rounded,
                              size: 64.0, color: theme.primary),
                        ),
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
                          autofillHints: const [AutofillHints.newPassword],
                          esPassword: true,
                          validator: Validar.password,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _crearUsuario(),
                        ),
                        BotonPrincipal(
                          key: const ValueKey('btnCrearUsuario'),
                          texto: 'Crear usuario',
                          icono: Icons.person_add_rounded,
                          cargando: _model.cargando,
                          onPressed: _crearUsuario,
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
