import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Estilos compartidos por las ventanas de usuarios (login, listar, crear,
/// editar). Mismo diseño visto en clase: padding 10, ancho 85 %, borde azul
/// con border radius.

const Color kBordeAzul = Color(0xFF1E6FD9);

/// Campo de texto con el diseño de la clase.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.controller,
    required this.etiqueta,
    this.focusNode,
    this.keyboardType,
    this.autofillHints,
    this.esPassword = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String etiqueta;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool esPassword;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.85,
          child: _CampoConOjito(
            controller: controller,
            etiqueta: etiqueta,
            focusNode: focusNode,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            esPassword: esPassword,
            validator: validator,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ),
    );
  }
}

class _CampoConOjito extends StatefulWidget {
  const _CampoConOjito({
    required this.controller,
    required this.etiqueta,
    this.focusNode,
    this.keyboardType,
    this.autofillHints,
    required this.esPassword,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String etiqueta;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool esPassword;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  State<_CampoConOjito> createState() => _CampoConOjitoState();
}

class _CampoConOjitoState extends State<_CampoConOjito> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    OutlineInputBorder borde(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        );
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      obscureText: widget.esPassword && _oculto,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      style: theme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        hintText: widget.etiqueta,
        filled: true,
        fillColor: theme.secondaryBackground,
        enabledBorder: borde(kBordeAzul),
        focusedBorder: borde(theme.primary),
        errorBorder: borde(theme.error),
        focusedErrorBorder: borde(theme.error),
        suffixIcon: widget.esPassword
            ? IconButton(
                tooltip: _oculto ? 'Mostrar contraseña' : 'Ocultar contraseña',
                icon: Icon(
                  _oculto
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _oculto = !_oculto),
              )
            : null,
      ),
    );
  }
}

/// Botón principal con el color del tema.
class BotonPrincipal extends StatelessWidget {
  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
    this.icono,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton.icon(
            onPressed: cargando ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            icon: cargando
                ? const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  )
                : Icon(icono ?? Icons.check_rounded),
            label: Text(texto),
          ),
        ),
      ),
    );
  }
}

/// Validaciones del formulario (equivalentes a las de "Form Validation"
/// configuradas en clase).
class Validar {
  static String? requerido(String? valor) =>
      (valor == null || valor.trim().isEmpty) ? 'Es requerido' : null;

  static String? email(String? valor) {
    final requeridoError = requerido(valor);
    if (requeridoError != null) return requeridoError;
    // algo@algo.algo
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(valor!.trim())
        ? null
        : 'Ingrese un correo válido (ej: algo@algo.algo)';
  }

  static String? password(String? valor) {
    final requeridoError = requerido(valor);
    if (requeridoError != null) return requeridoError;
    return valor!.length < 6
        ? 'La contraseña debe tener al menos 6 caracteres'
        : null;
  }
}

/// AppBar común de las ventanas de usuarios.
PreferredSizeWidget appBarUsuarios(
  BuildContext context, {
  required String titulo,
  VoidCallback? onAtras,
  List<Widget>? acciones,
}) {
  final theme = FlutterFlowTheme.of(context);
  return AppBar(
    backgroundColor: theme.primary,
    foregroundColor: Colors.white,
    automaticallyImplyLeading: false,
    leading: onAtras == null
        ? null
        : IconButton(
            tooltip: 'Atrás',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onAtras,
          ),
    title: Text(
      titulo,
      style: theme.titleLarge.copyWith(color: Colors.white),
    ),
    actions: acciones,
    elevation: 2.0,
  );
}
