// Elige la implementación según la plataforma (web o celular).
export 'guardar_archivo_io.dart'
    if (dart.library.js_interop) 'guardar_archivo_web.dart';
