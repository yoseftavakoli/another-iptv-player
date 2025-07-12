// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get slogan => 'Reproductor IPTV de Código Abierto';

  @override
  String get search => 'Buscar';

  @override
  String get search_live_stream => 'Buscar transmisión en vivo';

  @override
  String get search_movie => 'Buscar película';

  @override
  String get search_series => 'Buscar serie';

  @override
  String get not_found_in_category =>
      'No se encontró contenido en esta categoría';

  @override
  String get live_stream_not_found => 'No se encontró transmisión en vivo';

  @override
  String get movie_not_found => 'No se encontró película';

  @override
  String get see_all => 'Ver Todo';

  @override
  String get preview => 'Vista Previa';

  @override
  String get info => 'Información';

  @override
  String get close => 'Cerrar';

  @override
  String get reset => 'Restablecer';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get back => 'Atrás';

  @override
  String get clear => 'Limpiar';

  @override
  String get clear_all => 'Limpiar Todo';

  @override
  String get day => 'Día';

  @override
  String get clear_all_confirmation_message =>
      '¿Estás seguro de que quieres eliminar todo el historial?';

  @override
  String get try_again => 'Intentar de Nuevo';

  @override
  String get history => 'Historial';

  @override
  String get history_empty_message => 'Los videos que veas aparecerán aquí';

  @override
  String get live => 'En Vivo';

  @override
  String get live_streams => 'Transmisiones en Vivo';

  @override
  String get on_live => 'En Vivo';

  @override
  String get other_channels => 'Otros Canales';

  @override
  String get movies => 'Películas';

  @override
  String get movie => 'Película';

  @override
  String get series_singular => 'Serie';

  @override
  String get series_plural => 'Series';

  @override
  String get category_id => 'ID de Categoría';

  @override
  String get channel_information => 'Información del Canal';

  @override
  String get channel_id => 'ID del Canal';

  @override
  String get series_id => 'ID de Serie';

  @override
  String get quality => 'Calidad';

  @override
  String get stream_type => 'Tipo de Transmisión';

  @override
  String get format => 'Formato';

  @override
  String get season => 'Temporadas';

  @override
  String episode_count(Object count) {
    return '$count Episodios';
  }

  @override
  String duration(Object duration) {
    return 'Duración: $duration';
  }

  @override
  String get episode_duration => 'Duración del Episodio';

  @override
  String get creation_date => 'Fecha de Agregado';

  @override
  String get release_date => 'Fecha de Estreno';

  @override
  String get genre => 'Género';

  @override
  String get cast => 'Reparto';

  @override
  String get description => 'Descripción';

  @override
  String get video_track => 'Pista de Video';

  @override
  String get audio_track => 'Pista de Audio';

  @override
  String get subtitle_track => 'Pista de Subtítulos';

  @override
  String get settings => 'Configuración';

  @override
  String get general_settings => 'Configuración General';

  @override
  String get app_language => 'Idioma de la App';

  @override
  String get continue_on_background =>
      'Continuar Reproduciendo en Segundo Plano';

  @override
  String get continue_on_background_description =>
      'Seguir reproduciendo aunque la app esté en segundo plano';

  @override
  String get refresh_contents => 'Actualizar Contenido';

  @override
  String get subtitle_settings => 'Configuración de Subtítulos';

  @override
  String get subtitle_settings_description =>
      'Personalizar la apariencia de los subtítulos';

  @override
  String get sample_text => 'Texto de subtítulo de ejemplo\nSe verá así';

  @override
  String get font_settings => 'Configuración de Fuente';

  @override
  String get font_size => 'Tamaño de Fuente';

  @override
  String get font_height => 'Altura de Línea';

  @override
  String get letter_spacing => 'Espaciado de Letras';

  @override
  String get word_spacing => 'Espaciado de Palabras';

  @override
  String get padding => 'Relleno';

  @override
  String get color_settings => 'Configuración de Color';

  @override
  String get text_color => 'Color del Texto';

  @override
  String get background_color => 'Color de Fondo';

  @override
  String get style_settings => 'Configuración de Estilo';

  @override
  String get font_weight => 'Grosor de Fuente';

  @override
  String get thin => 'Delgado';

  @override
  String get normal => 'Normal';

  @override
  String get medium => 'Medio';

  @override
  String get bold => 'Negrita';

  @override
  String get extreme_bold => 'Extra Negrita';

  @override
  String get text_align => 'Alineación del Texto';

  @override
  String get left => 'Izquierda';

  @override
  String get center => 'Centro';

  @override
  String get right => 'Derecha';

  @override
  String get justify => 'Justificar';

  @override
  String get pick_color => 'Elegir Color';

  @override
  String get my_playlists => 'Mis Listas de Reproducción';

  @override
  String get create_new_playlist => 'Crear Nueva Lista';

  @override
  String get loading_playlists => 'Cargando Listas...';

  @override
  String get playlist_list => 'Lista de Reproducción';

  @override
  String get playlist_information => 'Información de la Lista';

  @override
  String get playlist_name => 'Nombre de la Lista';

  @override
  String get playlist_name_placeholder => 'Ingresa un nombre para tu lista';

  @override
  String get playlist_name_required => 'El nombre de la lista es requerido';

  @override
  String get playlist_name_min_2 =>
      'El nombre debe tener al menos 2 caracteres';

  @override
  String playlist_deleted(Object name) {
    return '$name eliminada';
  }

  @override
  String get playlist_delete_confirmation_title => 'Eliminar Lista';

  @override
  String playlist_delete_confirmation_message(Object name) {
    return '¿Estás seguro de que quieres eliminar la lista \'$name\'?\nEsta acción no se puede deshacer.';
  }

  @override
  String get empty_playlist_title => 'Aún No Hay Listas';

  @override
  String get empty_playlist_message =>
      'Comienza creando tu primera lista de reproducción.\nPuedes agregar listas en formato Xtream Code o M3U.';

  @override
  String get empty_playlist_button => 'Crear Mi Primera Lista';

  @override
  String get select_playlist_type => 'Seleccionar Tipo de Lista';

  @override
  String get select_playlist_message =>
      'Elige el tipo de lista que quieres crear';

  @override
  String get xtream_code_title =>
      'Conectar con URL de API, Usuario y Contraseña';

  @override
  String get xtream_code_description =>
      'Conéctate fácilmente con la información de tu proveedor IPTV';

  @override
  String get select_playlist_type_footer =>
      'La información de tu lista se almacena de forma segura en tu dispositivo.';

  @override
  String get api_url => 'URL de API';

  @override
  String get api_url_required => 'URL de API requerida';

  @override
  String get username => 'Usuario';

  @override
  String get username_placeholder => 'Ingresa tu usuario';

  @override
  String get username_required => 'Usuario requerido';

  @override
  String get username_min_3 => 'El usuario debe tener al menos 3 caracteres';

  @override
  String get password => 'Contraseña';

  @override
  String get password_placeholder => 'Ingresa tu contraseña';

  @override
  String get password_required => 'Contraseña requerida';

  @override
  String get password_min_3 => 'La contraseña debe tener al menos 3 caracteres';

  @override
  String get server_url => 'URL del Servidor';

  @override
  String get submitting => 'Guardando...';

  @override
  String get submit_create_playlist => 'Guardar Lista';

  @override
  String get subscription_details => 'Detalles de Suscripción';

  @override
  String subscription_remaining_day(Object days) {
    return 'Suscripción: $days';
  }

  @override
  String get remaining_day_title => 'Tiempo Restante';

  @override
  String remaining_day(Object days) {
    return '$days Días';
  }

  @override
  String get connected => 'Conectado';

  @override
  String get no_connection => 'Sin Conexión';

  @override
  String get expired => 'Expirado';

  @override
  String get active_connection => 'Conexión Activa';

  @override
  String get maximum_connection => 'Conexión Máxima';

  @override
  String get server_information => 'Información del Servidor';

  @override
  String get timezone => 'Zona Horaria';

  @override
  String get server_message => 'Mensaje del Servidor';

  @override
  String get all_datas_are_stored_in_device =>
      'Todos los datos se almacenan de forma segura en tu dispositivo';

  @override
  String get url_format_validate_message =>
      'El formato de URL debe ser como http://servidor:puerto';

  @override
  String get url_format_validate_error =>
      'Ingresa una URL válida (debe comenzar con http:// o https://)';

  @override
  String get playlist_name_already_exists =>
      'Ya existe una lista con este nombre';

  @override
  String get invalid_credentials =>
      'No se pudo obtener respuesta de tu proveedor IPTV, verifica tu información';

  @override
  String get error_occurred => 'Ocurrió un error';

  @override
  String get connecting => 'Conectando';

  @override
  String get preparing_categories => 'Preparando categorías';

  @override
  String preparing_categories_exception(Object error) {
    return 'No se pudieron cargar las categorías: $error';
  }

  @override
  String get preparing_live_streams => 'Cargando canales en vivo';

  @override
  String get preparing_live_streams_exception_1 =>
      'No se pudieron obtener los canales en vivo';

  @override
  String preparing_live_streams_exception_2(Object error) {
    return 'Error al cargar canales en vivo: $error';
  }

  @override
  String get preparing_movies => 'Abriendo biblioteca de películas';

  @override
  String get preparing_movies_exception_1 =>
      'No se pudieron obtener las películas';

  @override
  String preparing_movies_exception_2(Object error) {
    return 'Error al cargar películas: $error';
  }

  @override
  String get preparing_series => 'Preparando biblioteca de series';

  @override
  String get preparing_series_exception_1 =>
      'No se pudieron obtener las series';

  @override
  String preparing_series_exception_2(Object error) {
    return 'Error al cargar series: $error';
  }

  @override
  String get preparing_user_info_exception_1 =>
      'No se pudo obtener información del usuario';

  @override
  String preparing_user_info_exception_2(Object error) {
    return 'Error al cargar información del usuario: $error';
  }
}
