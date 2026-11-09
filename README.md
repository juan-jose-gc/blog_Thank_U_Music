# Thank U Music — pantallas Flutter

Vistas sencillas basadas en los mockups, con fondo claro, rojo, logo y menú lateral. Solo front-end: no hay API, base de datos, autenticación real ni envío de correos.

## Carpetas

```text
lib/
├── main.dart
├── Models/
│   ├── usuario_model.dart
│   ├── publicacion_model.dart
│   ├── comentario_model.dart
│   └── datos_ejemplo.dart
├── screens/
│   ├── inicio_sesion_pantalla.dart
│   ├── registro_pantalla.dart
│   ├── inicio_pantalla.dart
│   ├── detalle_publicacion_pantalla.dart
│   ├── editar_publicacion_pantalla.dart
│   ├── perfil_pantalla.dart
│   └── usuarios_pantalla.dart
├── services/
│   └── README.md
└── widgets/
    ├── menu_lateral.dart
    ├── campo_texto.dart
    ├── tarjeta.dart
    ├── portada.dart
    ├── titulo_seccion.dart
    ├── contenido_pagina.dart
    ├── avisos.dart
    └── componentes.dart
```

Las clases y los modelos propios usan nombres en español. Los nombres de Flutter y las carpetas del ejemplo (`Models`, `screens`, `services`, `widgets`) se conservan. `componentes.dart` agrupa los imports de widgets.

El registro normal y de administrador comparten formulario. Agregar y editar una publicación comparten pantalla. El detalle y la moderación comparten la lista de comentarios. Así se conservan las vistas sin duplicar el mismo diseño.

`Models/datos_ejemplo.dart` contiene únicamente datos temporales para visualizar e interactuar con las pantallas; los cambios se pierden al reiniciar. `services` queda reservada, sin servicios implementados.

## Abrir y recorrer

Abre la carpeta que contiene `pubspec.yaml` en VS Code y ejecuta:

```sh
flutter pub get
flutter run -d chrome
```

Para recorrer las vistas, completa el login con cualquier correo válido y un texto de al menos seis caracteres. `admin@example.com` abre el menú de administrador; otro correo abre el de usuario. Esto solo elige las vistas: no autentica ni guarda contraseñas.

El registro muestra el formulario y sus validaciones, sin crear cuentas reales. Las portadas usan tres iconos musicales de ejemplo. No se implementó carga de archivos.

Se incluyen las carpetas web, Android e iOS. iOS requiere macOS y Xcode para compilar.

## Validación

Se revisan imports y tipos con `dart analyze`. No se ha confirmado una compilación: el entorno anterior tuvo problemas de espacio en disco y archivos temporales.
