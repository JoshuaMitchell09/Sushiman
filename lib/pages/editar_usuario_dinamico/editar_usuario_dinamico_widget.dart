import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/usuarios_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editar_usuario_dinamico_model.dart';
export 'editar_usuario_dinamico_model.dart';

/// Edita un documento de la colección `users` (Update Document).
class EditarUsuarioDinamicoWidget extends StatefulWidget {
  const EditarUsuarioDinamicoWidget({super.key, required this.userId});

  final String? userId;

  static String routeName = 'EditarUsuarioDinamico';
  static String routePath = '/editarUsuarioDinamico';

  @override
  State<EditarUsuarioDinamicoWidget> createState() =>
      _EditarUsuarioDinamicoWidgetState();
}

class _EditarUsuarioDinamicoWidgetState
    extends State<EditarUsuarioDinamicoWidget> {
  late EditarUsuarioDinamicoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const roles = ['usuario', 'admin'];

  DocumentReference<Map<String, dynamic>>? get _ref =>
      (widget.userId == null || widget.userId!.isEmpty)
          ? null
          : FirebaseFirestore.instance.collection('users').doc(widget.userId);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditarUsuarioDinamicoModel());
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final snap = await _ref?.get();
      final data = snap?.data();
      if (data != null) {
        _model.email = (data['email'] ?? '') as String;
        _model.txtNombreTextController!.text =
            (data['display_name'] ?? '') as String;
        _model.txtTelefonoTextController!.text =
            (data['phone_number'] ?? '') as String;
        final rol = (data['role'] ?? 'usuario') as String;
        _model.rol = roles.contains(rol) ? rol : 'usuario';
      }
    } catch (e) {
      if (mounted) showSnackbar(context, 'No se pudo cargar: $e');
    }
    if (mounted) setState(() => _model.cargandoDatos = false);
  }

  Future<void> _actualizar() async {
    if (_ref == null) return;
    if (!(_model.formKey.currentState?.validate() ?? false)) return;
    setState(() => _model.guardando = true);
    try {
      await _ref!.update({
        'display_name': _model.txtNombreTextController!.text.trim(),
        'phone_number': _model.txtTelefonoTextController!.text.trim(),
        'role': _model.rol,
      });
      if (!mounted) return;
      showSnackbar(context, 'Usuario actualizado');
      context.goNamed(ListarUsuarioDinamicoWidget.routeName);
    } catch (e) {
      if (mounted) showSnackbar(context, 'No se pudo actualizar: $e');
    } finally {
      if (mounted) setState(() => _model.guardando = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
          titulo: 'Editar usuario',
          onAtras: () =>
              context.goNamed(ListarUsuarioDinamicoWidget.routeName),
        ),
        body: SafeArea(
          child: _model.cargandoDatos
              ? Center(child: CircularProgressIndicator(color: theme.primary))
              : Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520.0),
                      child: Form(
                        key: _model.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _model.email,
                                style: theme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CampoTexto(
                              controller: _model.txtNombreTextController!,
                              etiqueta: 'Nombre',
                              keyboardType: TextInputType.name,
                              validator: Validar.requerido,
                            ),
                            CampoTexto(
                              controller: _model.txtTelefonoTextController!,
                              etiqueta: 'Teléfono',
                              keyboardType: TextInputType.phone,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FractionallySizedBox(
                                widthFactor: 0.85,
                                child: DropdownButtonFormField<String>(
                                  initialValue: _model.rol,
                                  decoration: InputDecoration(
                                    labelText: 'Rol',
                                    filled: true,
                                    fillColor: theme.secondaryBackground,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: kBordeAzul, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  items: roles
                                      .map((r) => DropdownMenuItem(
                                          value: r, child: Text(r)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _model.rol = v ?? 'usuario'),
                                ),
                              ),
                            ),
                            BotonPrincipal(
                              texto: 'Actualizar',
                              icono: Icons.save_rounded,
                              cargando: _model.guardando,
                              onPressed: _actualizar,
                            ),
                          ],
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
