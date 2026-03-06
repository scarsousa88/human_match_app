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
  String get personality => 'Personalidade';

  @override
  String get profileInsights => 'Insights de Perfil';

  @override
  String get noInsights => 'Ainda no tienes insights gerados.';

  @override
  String get generateInsights => 'Generar Insights (Anuncio)';

  @override
  String get update => 'Actualizar';

  @override
  String get profilePillars => 'Pilares do teu Perfil';

  @override
  String get dailyTip => 'Consejo Diario';

  @override
  String get getDailyTip => 'Obtener consejo diario (Anuncio)';

  @override
  String get watchAdForTip => 'Mira el anuncio para obtener tu consejo diario';

  @override
  String get errorFillEmailPassword => 'Preenche email e password.';

  @override
  String get errorAcceptTerms => 'Precisas de aceitar os Termos e Condições.';

  @override
  String get resetEmailSent => 'Email enviado. (Vê spam também)';

  @override
  String get resetEmailError => 'Escreve o email acima e tenta novamente.';

  @override
  String get errorUserNotFound => 'Utilizador não encontrado.';

  @override
  String get errorWrongPassword => 'Password incorreta.';

  @override
  String get errorInvalidEmail => 'Email inválido.';

  @override
  String get errorEmailAlreadyInUse => 'Este email já está a ser usado.';

  @override
  String get errorWeakPassword => 'Password fraca (mín. 6 caracteres).';

  @override
  String errorGeneral(String error) {
    return 'Erro: $error';
  }

  @override
  String get errorFillProfile => 'Preenche nome, data, hora e cidade.';

  @override
  String errorSavingProfile(String error) {
    return 'Erro ao guardar/calcular: $error';
  }

  @override
  String get signAries => 'Carneiro';

  @override
  String get signTaurus => 'Touro';

  @override
  String get signGemini => 'Gémeos';

  @override
  String get signCancer => 'Caranguejo';

  @override
  String get signLeo => 'Leão';

  @override
  String get signVirgo => 'Virgem';

  @override
  String get signLibra => 'Balança';

  @override
  String get signScorpio => 'Escorpião';

  @override
  String get signSagittarius => 'Sagitário';

  @override
  String get signCapricorn => 'Capricórnio';

  @override
  String get signAquarius => 'Aquário';

  @override
  String get signPisces => 'Peixes';
}
