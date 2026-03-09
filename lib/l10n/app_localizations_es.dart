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
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get acceptTerms => 'Acepto los Términos y Condiciones';

  @override
  String get termsTitle => 'Términos y Condiciones';

  @override
  String get termsContent =>
      'Política de Privacidad - Human Match\n\nEsta Política de Privacidad describe cómo Human Match, una aplicación móvil que genera informes personalizados de Human Design, Astrología y Numerología basados en el nombre completo, fecha y lugar de nacimiento de los usuarios, recopila, utiliza y protege sus datos personales. Estamos comprometidos con la protección de su privacidad de acuerdo con el Reglamento General de Protección de Datos (RGPD) de la Unión Europea y la legislación aplicable en Portugal.\n\nDatos Recopilados\nRecopilamos solo los datos estrictamente necesarios para prestar el servicio:\n- Nombre completo;\n- Fecha de nacimiento;\n- Lugar de nacimiento.\n\nEstos datos se utilizan exclusivamente para calcular y generar sus informes personalizados de Human Design, Astrología y Numerología. No recopilamos datos sensibles adicionales, como la dirección de correo electrónico o información financiera, a menos que se proporcionen voluntariamente para soporte o registro de cuenta.\n\nFinalidades del Tratamiento\nLos datos se tratan para:\n- Generar informes precisos basados en las entradas proporcionadas;\n- Mejorar la precisión de los cálculos astrológicos y de diseño humano;\n- Permitir el almacenamiento opcional de informes para acceso futuro (con su consentimiento explícito).\n\nEl tratamiento es lícito sobre la base de su consentimiento libre e informado, obtenido en el momento de la entrega de los datos.\n\nIntercambio de Datos\nNo compartimos sus datos personales con terceiros, excepto:\n- Proveedores de servicios técnicos esenciales (por ejemplo, servidores en la nube seguros en la UE) bajo acuerdos de procesamiento de datos que garantizan la confidencialidad;\n- Cuando así lo exija la ley o las autoridades competentes.\n\nLos informes generados son privados y no se venden ni se utilizan para marketing.\n\nAlmacenamiento y Seguridad\nLos datos se almacenan en servidores seguros ubicados en la Unión Europea, con medidas técnicas como el cifrado (AES-256), la seudonimización y los controles de acceso. Conservamos los datos únicamente durante el tiempo necesario para el servicio (generally hasta 30 días después del último acceso, a menos que se dé el consentimiento para un almacenamiento prolongado). Procedemos a la eliminación segura automática después de este período.\n\nSus Derechos\nPuede ejercer sus derechos RGPD en cualquier momento:\n- Acceso a los datos;\n- Rectificación o corrección;\n- Supresión (\"derecho al olvido\");\n- Oposición al tratamiento;\n- Limitación del tratamiento;\n- Portabilidad de los datos.\n\nPara solicitar la eliminación de su cuenta y de todos los datos asociados, puede hacerlo a través del siguiente enlace: https://humanmatch.app/delete-account o enviando un correo electrónico a support@humanmatch.app.\n\nConsentimiento y Cambios\nAl usar la aplicación, acepta esta política. Puede revocar su consentimiento en cualquier momento, lo que impedirá el acceso a los informes existentes. Actualizaremos esta política según sea necesario, notificando los usuarios a través de la aplicación.';

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
  String get editProfile => 'Editar perfil';

  @override
  String get baseData => 'Datos del usuario';

  @override
  String get baseDataDesc => 'Esto permite calcular Human Design + ascendente.';

  @override
  String get name => 'Nombre completo';

  @override
  String get nameNumerologyInfo =>
      'Este campo se utilizará para determinar las variables de la Numerología. No se deben utilizar caracteres especiales ni acentos.';

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
  String get noInsights => 'Aún no tienes insights gerados.';

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

  @override
  String get hdType => 'Tipo';

  @override
  String get hdAuthority => 'Autoridad';

  @override
  String get hdStrategy => 'Estrategia';

  @override
  String get hdProfile => 'Perfil';

  @override
  String get hdSignature => 'Firma';

  @override
  String get hdNotSelf => 'No-ser';

  @override
  String get hdDefinition => 'Definición';

  @override
  String get hdIncarnationCross => 'Cruz';

  @override
  String get hdEnergyCenters => 'Centros energéticos';

  @override
  String get hdDefinedCenters => 'Centros Definidos';

  @override
  String get hdChannels => 'Canales';

  @override
  String get hdNoData => 'No hay datos disponibles.';

  @override
  String hdAuthorityNotice(String center) {
    return '* $center es el centro de autoridad';
  }

  @override
  String get hdDesign => 'Diseño';

  @override
  String get hdUnconscious => '(Inconsciente)';

  @override
  String get hdPlanets => 'Astros';

  @override
  String get hdPersonality => 'Personalidad';

  @override
  String get hdConscious => '(Consciente)';

  @override
  String get hdGen => 'Generador';

  @override
  String get hdMG => 'Generador Manifestante';

  @override
  String get hdMan => 'Manifestador';

  @override
  String get hdProj => 'Proyector';

  @override
  String get hdRef => 'Reflector';

  @override
  String get hdAuthEmo => 'Emocional';

  @override
  String get hdAuthSac => 'Sacral';

  @override
  String get hdAuthSpl => 'Esplénica';

  @override
  String get hdAuthEgo => 'Ego';

  @override
  String get hdAuthSelf => 'Autoproyectada';

  @override
  String get hdAuthMen => 'Mental';

  @override
  String get hdStrInf => 'Informar';

  @override
  String get hdStrResp => 'Esperar para responder';

  @override
  String get hdStrInv => 'Esperar la invitación';

  @override
  String get hdStrLun => 'Esperar un ciclo lunar';

  @override
  String get hdSigSat => 'Satisfacción';

  @override
  String get hdSigSuc => 'Éxito';

  @override
  String get hdSigPea => 'Paz';

  @override
  String get hdSigSur => 'Sorpresa';

  @override
  String get hdNotFru => 'Frustración';

  @override
  String get hdNotBit => 'Amargura';

  @override
  String get hdNotAng => 'Rabia';

  @override
  String get hdNotDis => 'Desilusión';

  @override
  String get hdDefSin => 'Definición Única';

  @override
  String get hdDefSpl => 'Definição Partida';

  @override
  String get hdDefTri => 'Triple Partida';

  @override
  String get hdDefQua => 'Cuádruple Partida';

  @override
  String get hdCrossRight => 'Ângulo Direito';

  @override
  String get hdCrossLeft => 'Ângulo Esquerdo';

  @override
  String get hdCrossJuxta => 'Justaposición';

  @override
  String get hdCrossOf => 'Cruz de';

  @override
  String get hdCenterHead => 'Cabeza';

  @override
  String get hdCenterAjna => 'Ajna';

  @override
  String get hdCenterThroat => 'Garganta';

  @override
  String get hdCenterG => 'Centro G';

  @override
  String get hdCenterEgo => 'Ego (Corazón)';

  @override
  String get hdCenterSpleen => 'Bazo';

  @override
  String get hdCenterSolar => 'Plexo Solar';

  @override
  String get hdCenterSacral => 'Sacral';

  @override
  String get hdCenterRoot => 'Raíz';

  @override
  String get hdPlanetSun => 'Sol';

  @override
  String get hdPlanetEarth => 'Tierra';

  @override
  String get hdPlanetMoon => 'Luna';

  @override
  String get hdPlanetMercury => 'Mercurio';

  @override
  String get hdPlanetVenus => 'Venus';

  @override
  String get hdPlanetMars => 'Marte';

  @override
  String get hdPlanetJupiter => 'Júpiter';

  @override
  String get hdPlanetSaturn => 'Saturno';

  @override
  String get hdPlanetUranus => 'Urano';

  @override
  String get hdPlanetNeptune => 'Neptuno';

  @override
  String get hdPlanetPluto => 'Plutón';

  @override
  String get legalInfo => 'Información Legal';

  @override
  String get deleteAccountData => 'Eliminar Cuenta y Datos';

  @override
  String get verifyEmailTitle => 'Verifica tu Email';

  @override
  String verifyEmailSent(String email) {
    return 'Hemos enviado un correo de confirmación a $email. Por favor, revisa tu bandeja de entrada (y carpeta de spam).';
  }

  @override
  String get checkVerification => 'Ya lo he verificado';

  @override
  String get resendVerification => 'Reenviar correo';

  @override
  String get verificationResent => 'Correo de verificación reenviado.';

  @override
  String get orDivider => 'OU';

  @override
  String get errorEmailAlreadyRegistered =>
      'Este email já está registado. Tente fazer LOGIN em vez de criar conta.';

  @override
  String get errorInvalidCredentials =>
      'Credenciais incorretas ou conta inexistente.';

  @override
  String get errorUserDisabled => 'Conta desativada.';

  @override
  String get errorTooManyRequests =>
      'Bloqueado temporariamente por excesso de tentativas.';

  @override
  String get errorAccountExistsGoogle =>
      'Já existe uma conta com este email vinculada ao Google. Use \"Continuar com Google\".';

  @override
  String errorUnexpected(Object error) {
    return 'Erro inesperado: $error';
  }

  @override
  String errorGoogle(Object error) {
    return 'Erro Google: $error';
  }

  @override
  String errorResetPassword(Object error) {
    return 'Erro ao resetar: $error';
  }

  @override
  String get close => 'Fechar';

  @override
  String authError(Object error) {
    return 'Erro de Autenticação: $error';
  }

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String loadProfileError(Object error) {
    return 'Erro ao carregar perfil: $error';
  }

  @override
  String get logoutAndTryAgain => 'Sair e Tentar Novamente';
}
