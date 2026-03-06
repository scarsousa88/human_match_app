// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Human Match';

  @override
  String get tabProfile => 'Mi Perfil';

  @override
  String get tabCommunity => 'Comunidad';

  @override
  String get tabCompare => 'Comparar';

  @override
  String get welcomeMessage => '¡Conócete bien, relaciónate mejor!';

  @override
  String get soonMessage => 'Próximamente';

  @override
  String get communitySoon => 'Explora perfiles cercanos y compatibles';

  @override
  String get compareSoon => 'Compara perfiles manualmente';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Crear cuenta';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get noAccount => '¿No tienes cuenta? Crear';

  @override
  String get hasAccount => '¿Ya tienes cuenta? Entrar';

  @override
  String get acceptTerms => 'Acepto los Términos y Condiciones';

  @override
  String get termsTitle => 'Términos y Condiciones';

  @override
  String get termsContent =>
      'Bienvenido a Human Match.\n\n1. Protección de Datos: Al utilizar esta aplicación, acepta el procesamiento de sus datos de nacimiento (fecha, hora y lugar) para el cálculo de su perfil de Human Design, Astrología y Numerología.\n\n2. Inteligencia Artificial: Los insights y consejos generados son producidos por modelos de IA y deben interpretarse como sugerencias de autoconocimiento, no como asesoramiento profesional o médico.\n\n3. Anuncios: La aplicación utiliza anuncios premiados para desbloquear contenidos gratuitos. Los datos anónimos de publicidad pueden ser procesados por Google AdMob.\n\n4. Privacidad: No compartimos sus datos personales con terceros. Puede eliminar su cuenta en cualquier momento en los ajustes.\n\nAl aceptar, confirma que tiene más de 18 años o autorización parental.';

  @override
  String get processing => 'Procesando...';

  @override
  String get acceptAndContinue => 'Aceptar y continuar';

  @override
  String get cancelAndExit => 'Cancelar y salir';

  @override
  String get loading => 'Espera...';

  @override
  String get createProfile => 'Crear perfil';

  @override
  String get baseData => 'Datos básicos';

  @override
  String get baseDataDesc => 'Esto permite calcular Human Design + ascendente.';

  @override
  String get name => 'Nombre';

  @override
  String get country => 'País';

  @override
  String get city => 'Ciudad';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get birthPlace => 'Lugar de nacimiento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectTime => 'Seleccionar hora';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String greeting(String name) {
    return 'Hola $name';
  }

  @override
  String get greetingEmpty => '¡Hola!';

  @override
  String get hdTitle => 'Human Design';

  @override
  String get hdCalculating => 'Calculando Human Design...';

  @override
  String get astroTitle => 'Astrología';

  @override
  String get zodiacSign => 'Signo';

  @override
  String get ascendant => 'Ascendente';

  @override
  String get numTitle => 'Numerología';

  @override
  String get lifePath => 'Camino de Vida';

  @override
  String get expression => 'Expresión';

  @override
  String get soul => 'Alma';

  @override
  String get personality => 'Personalidad';

  @override
  String get profileInsights => 'Insights de Perfil';

  @override
  String get noInsights => 'Aún no tienes insights generados.';

  @override
  String get generateInsights => 'Generar Insights (Anuncio)';

  @override
  String get update => 'Actualizar';

  @override
  String get profilePillars => 'Pilares de tu Perfil';

  @override
  String get dailyTip => 'Consejo Diario';

  @override
  String get getDailyTip => 'Obtener consejo diario (Anuncio)';

  @override
  String get watchAdForTip => 'Mira el anuncio para obtener tu consejo diario';

  @override
  String get errorFillEmailPassword =>
      'Ingresa correo electrónico y contraseña.';

  @override
  String get errorAcceptTerms => 'Debes aceptar los Términos y Condiciones.';

  @override
  String get resetEmailSent =>
      'Correo enviado. (Revisa también la carpeta de spam)';

  @override
  String get resetEmailError =>
      'Escribe tu correo arriba e inténtalo de nuevo.';

  @override
  String get errorUserNotFound => 'Usuario no encontrado.';

  @override
  String get errorWrongPassword => 'Contraseña incorrecta.';

  @override
  String get errorInvalidEmail => 'Correo electrónico inválido.';

  @override
  String get errorEmailAlreadyInUse => 'Este correo ya está en uso.';

  @override
  String get errorWeakPassword => 'Contraseña débil (mín. 6 caracteres).';

  @override
  String errorGeneral(String error) {
    return 'Error: $error';
  }

  @override
  String get errorFillProfile => 'Completa nombre, fecha, hora y ciudad.';

  @override
  String errorSavingProfile(String error) {
    return 'Error al guardar/calcular: $error';
  }

  @override
  String get signAries => 'Aries';

  @override
  String get signTaurus => 'Tauro';

  @override
  String get signGemini => 'Géminis';

  @override
  String get signCancer => 'Cáncer';

  @override
  String get signLeo => 'Leo';

  @override
  String get signVirgo => 'Virgo';

  @override
  String get signLibra => 'Libra';

  @override
  String get signScorpio => 'Escorpio';

  @override
  String get signSagittarius => 'Sagitario';

  @override
  String get signCapricorn => 'Capricornio';

  @override
  String get signAquarius => 'Acuario';

  @override
  String get signPisces => 'Piscis';
}
