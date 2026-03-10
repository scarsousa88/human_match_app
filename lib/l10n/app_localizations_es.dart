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
      'Política de Privacidad - Human Match\n\nEsta Política de Privacidad describe cómo Human Match, una aplicación móvil que genera informes personalizados de Diseño Humano, Astrología y Numerología basados en el nombre completo, la fecha y el lugar de nacimiento de los usuarios, recopila, utiliza y protege sus datos personales. Estamos comprometidos con la protección de su privacidad de acuerdo con el Reglamento General de Protección de Datos (RGPD) de la Unión Europea y la legislación aplicável en Portugal.\n\nDatos Recopilados\nRecopilamos solo los datos estrictamente necesarios para prestar el servicio:\n\nNombre completo;\n\nFecha de nacimiento;\n\nLugar de nacimiento.\n\nEstos datos se utilizan exclusivamente para calcular y generar sus informes personalizados de Diseño Humano, Astrología y Numerología. No recopilamos datos sensibles adicionales, como direcciones de correo electrónico o información financiera, a menos que se proporcionen voluntariamente para soporte o registro de cuenta.\n\nFinalidades del Tratamiento\nLos datos se tratan para:\n\nGenerar informes precisos basados en las entradas proporcionadas;\n\nMejorar la precisión de los cálculos astrológicos y de diseño humano;\n\nPermitir el almacenamiento opcional de informes para acceso futuro (con su consentimiento explícito).\n\nEl tratamiento es lícito basado en su consentimiento libre e informado, obtenido en el momento del envío de los datos.\n\nIntercambio de Datos\nNo compartimos sus datos personales con terceros, excepto:\n\nProveedores de servicios técnicos esenciales (ej.: servidores en la nube seguros en la UE) bajo acuerdos de procesamiento de datos que garantizan la confidencialidad;\n\nCuando lo exija la ley o las autoridades competentes.\n\nLos informes generados son privados y no se venden ni se utilizan para marketing.\n​\n\nAlmacenamiento y Seguridad\nLos datos se almacenan en servidores seguros ubicados en la Unión Europea, con medidas técnicas como cifrado (AES-256), seudonimización y controles de acceso. Conservamos los datos solo el tiempo necesario para el servicio (generalmente hasta 30 días después del último acceso, a menos que se dé el consentimiento para un almacenamiento prolongado). Procedemos a la eliminación segura automática después de este período.\n\nSus Derechos\nPuede ejercer sus derechos RGPD en cualquier momento:\n\nAcceso a los datos;\n\nRectificación o corrección;\n\nSupresión (\"derecho al olvido\");\n\nOposición al tratamiento;\n\nLimitación del tratamiento;\n\nPortabilidad de los datos.\n\nPara solicitar la eliminación de su cuenta y de todos los datos asociados, puede hacerlo a través del siguiente enlace: https://humanmatch.app/delete-account o enviando un correo electrónico a support@humanmatch.app.\n\nConsentimiento e Cambios\nAl usar la aplicación, usted acepta esta política. Puede revocar su consentimiento en cualquier momento, lo que impedirá el acceso a los informes existentes. Actualizaremos esta política según sea necesario, notificando a los usuarios a través de la aplicación.';

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
  String get baseDataDesc =>
      'Esto permite calcular Diseño Humano + ascendente.';

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
  String get hdTitle => 'Diseño Humano';

  @override
  String get hdCalculating => 'Calculando Diseño Humano...';

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
  String get profileInsights => 'Análisis del Perfil';

  @override
  String get noInsights => 'Aún no tienes análisis generados.';

  @override
  String get generateInsights => 'Generar Análisis (Anuncio)';

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
  String get hdAuthority => 'Autoridade';

  @override
  String get hdStrategy => 'Estrategia';

  @override
  String get hdProfile => 'Perfil';

  @override
  String get hdSignature => 'Firma';

  @override
  String get hdNotSelf => 'No-ser';

  @override
  String get hdDefinition => 'Definicón';

  @override
  String get hdIncarnationCross => 'Cruz de Encarnação';

  @override
  String get hdEnergyCenters => 'Centros';

  @override
  String get hdEnergyCentersChannels => 'Centros, canales y puertas';

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
  String get hdUnconscious => '(Unconscious)';

  @override
  String get hdPlanetaryActivation => 'Activación Planetaria';

  @override
  String get hdPlanets => 'Astros';

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
  String get hdAuthLun => 'Lunar';

  @override
  String get hdStrInf => 'Informar';

  @override
  String get hdStrResp => 'Responder';

  @override
  String get hdStrRespInf => 'Responder e informar';

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
  String get hdDefSpl => 'Definición Partida';

  @override
  String get hdDefTri => 'Triple Partida';

  @override
  String get hdDefQua => 'Cuádruple Partida';

  @override
  String get hdCrossRight => 'Ángulo Derecho';

  @override
  String get hdCrossLeft => 'Ángulo Izquierdo';

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
  String get hdCenterEgo => 'Corazón (Ego)';

  @override
  String get hdCenterSpleen => 'Bazo';

  @override
  String get hdCenterSolar => 'Plexo Solar';

  @override
  String get hdCenterSacral => 'Sacral';

  @override
  String get hdCenterRoot => 'Raíz';

  @override
  String get hdCenterNameHead => 'Cabeza';

  @override
  String get hdCenterNameAjna => 'Ajna';

  @override
  String get hdCenterNameThroat => 'Garganta';

  @override
  String get hdCenterNameG => 'Centro G';

  @override
  String get hdCenterNameHeart => 'Corazón';

  @override
  String get hdCenterNameSpleen => 'Bazo';

  @override
  String get hdCenterNameSolar => 'Plexo Solar';

  @override
  String get hdCenterNameSacral => 'Sacral';

  @override
  String get hdCenterNameRoot => 'Raíz';

  @override
  String get hdTypeDefDesc =>
      'El Tipo define cómo tu energía interactúa con el mundo.';

  @override
  String get hdAuthorityDefDesc =>
      'Tu Autoridad é tu sistema interno de toma de decisiones.';

  @override
  String get hdStrategyDefDesc =>
      'La Estrategia es el método para navegar por la vida con menos resistencia.';

  @override
  String get hdProfileDefDesc =>
      'El Perfil describe tu papel y cómo aprendes y evolucionas.';

  @override
  String get hdSignatureDefDesc =>
      'La Firma es el sentimiento de estar en alineación con tu diseño.';

  @override
  String get hdNotSelfDefDesc =>
      'El No-ser es la señal de que te estás alejando de tu verdad.';

  @override
  String get hdDefinitionDefDesc =>
      'La Definición muestra cómo fluye la energía entre tus centros.';

  @override
  String get hdIncarnationCrossDefDesc =>
      'Tu Cruz de Encarnación representa el propósito de tu vida.';

  @override
  String get hdValTypeGenerator =>
      'Como Generador, tu energía está diseñada para responder a lo que la vida te trae, en lugar de iniciar.';

  @override
  String get hdValTypeManifestingGenerator =>
      'Tienes la rapidez del Manifestador y la sostenibilidad del Generador. Responde antes de actuar.';

  @override
  String get hdValTypeManifestor =>
      'Viniste para iniciar e impactar. Informa a los demás antes de actuar para reducir la resistencia.';

  @override
  String get hdValTypeProjector =>
      'Estás aquí para guiar los otros. Tu éxito viene al esperar el reconocimiento y la invitación.';

  @override
  String get hdValTypeReflector =>
      'Eres un espejo de la comunidad. Espera un ciclo lunar completo antes de tomar decisiones importantes.';

  @override
  String get hdValAuthEmotional =>
      'La claridad no sucede en el ahora. Espera a que tu ola emocional se estabilice antes de decidir.';

  @override
  String get hdValAuthSacral =>
      'Confía en tu respuesta visceral inmediata (sonidos sacrales o inclinación física) en el momento presente.';

  @override
  String get hdValAuthSplenic =>
      'Confía en tu intuición instintiva y espontánea que te avisa sobre lo que es seguro y saludable.';

  @override
  String get hdValAuthEgo =>
      'Tu voluntad es tu guía. ¿Qué es lo que realmente quieres y tienes ganas de hacer?';

  @override
  String get hdValAuthSelfProjected =>
      'Tu verdad sale por tu boca. Escucha lo que dices cuando hablas sin pensar sobre tu futuro.';

  @override
  String get hdValAuthMental =>
      'Necesitas usar a los demás como caja de resonancia para escuchar tu propia verdad al hablar.';

  @override
  String get hdValAuthLunar =>
      'Como Reflector, tu decisión madura a lo largo de 28 días en sintonía con el ciclo de la Luna.';

  @override
  String get hdValStrRespond =>
      'Tu mejor forma de actuar es responder a las oportunidades que aparecen, en lugar de intentar forzar cosas nuevas.';

  @override
  String get hdValStrInform =>
      'Para reducir la resistencia de los demás, informa a las personas afectadas por tus acciones antes de tomarlas.';

  @override
  String get hdValStrRespondInform =>
      'Como MG, debes responder primero y luego informar a quienes te rodean antes de entrar en acción rápida.';

  @override
  String get hdValStrInvite =>
      'Debes esperar por reconocimiento formal y una invitación antes de compartir tu sabiduría o guía.';

  @override
  String get hdValStrLunar =>
      'Decisiones importantes deben ser tomadas solo después de un ciclo lunar completo (aproximadamente 28 días).';

  @override
  String get hdValSigSatisfaction =>
      'Sientes satisfacción cuando usas tu energía de forma profesional en algo que te da placer.';

  @override
  String get hdValSigSuccess =>
      'El éxito para ti es ser reconocido por lo que eres y ver a los demás prosperar con tu guía.';

  @override
  String get hdValSigPeace =>
      'Puedes actuar libremente y sin resistencia después de informar a los demás.';

  @override
  String get hdValSigSurprise =>
      'La sorpresa es la señal de que estás viendo la vida con ojos nuevos, como un espejo puro del ambiente.';

  @override
  String get hdValNotFrustration =>
      'La frustración surge cuando intentas iniciar cosas sin esperar por la respuesta correcta.';

  @override
  String get hdValNotBitterness =>
      'La amargura aparece cuando te esfuerzas demasiado sin ser invitado ou reconocido.';

  @override
  String get hdValNotAnger =>
      'La rabia es el resultado de sentir resistencia por no informar a los demás sobre tus intenciones.';

  @override
  String get hdValNotDisappointment =>
      'La desilusión ocurre cuando no estás en un ambiente saludable o intentas decidir demasiado rápido.';

  @override
  String get hdValProf13 =>
      'Investigador/Mártir: Aprende a través de la experimentación, fundaciones sólidas y profundidad.';

  @override
  String get hdValProf14 =>
      'Investigador/Oportunista: Influye en su red cercana compartiendo su estudio profundo.';

  @override
  String get hdValProf24 =>
      'Eremita/Oportunista: Un talento natural que necesita tiempo a solas, pero que florece en su red.';

  @override
  String get hdValProf25 =>
      'Eremita/Herege: Talento natural proyectado para ser un guía o salvador para los demás.';

  @override
  String get hdValProf35 =>
      'Mártir/Herege: Aprende por prueba y error y comparte lo que funciona para desafiar o status quo.';

  @override
  String get hdValProf36 =>
      'Mártir/Observador: Experimenta en la primera fase de la vida para convertirse en un guia sabio y objetivo.';

  @override
  String get hdValProf46 =>
      'Oportunista/Observador: Influye a través de la red y objetividad, convirtiéndose en un modelo a seguir.';

  @override
  String get hdValProf41 =>
      'Oportunista/Investigador: Sigue un camino fijo y único con base en fundaciones muy sólidas.';

  @override
  String get hdValProf51 =>
      'Herege/Investigador: El maestro que resuelve problemas práticos a través de estudio y autoridad.';

  @override
  String get hdValProf52 =>
      'Herege/Eremita: Motivado por la autorreflexión, pero visto por los demás como un guía natural.';

  @override
  String get hdValProf62 =>
      'Observador/Eremita: Modelo a seguir que vive con objetividad y desapego tras una vida de experiencia.';

  @override
  String get hdValProf63 =>
      'Observador/Mártir: Modelo a seguir que continúa evolucionando a través da experimentación constante.';

  @override
  String get hdCenterHeadDefDesc =>
      'Procesas pensamientos de forma constante e te inspiras en tus próprias ideias.';

  @override
  String get hdCenterHeadUndDesc =>
      'Eres abierto a nuevas ideas y tienes flexibilidad para ver diferentes perspectivas.';

  @override
  String get hdCenterAjnaDefDesc =>
      'Tienes una forma fija y organizada de pensar y procesar información.';

  @override
  String get hdCenterAjnaUndDesc =>
      'Puedes adaptar tu forma de pensar a cualquier situación sin opiniones rígidas.';

  @override
  String get hdCenterThroatDefDesc =>
      'Comunicación y acción constantes e fiáveis a través da tu voz e fatos.';

  @override
  String get hdCenterThroatUndDesc =>
      'Comunicación variable, dependiendo del ambiente e de quien te rodea.';

  @override
  String get hdCenterGDefDesc =>
      'Tienes um sentido fijo y claro de quem és, do teu propósito e direção na vida.';

  @override
  String get hdCenterGUndDesc =>
      'Tu identidade é fluida e podes adaptar-te e encontrar-te em diversos ambientes.';

  @override
  String get hdCenterEgoDefDesc =>
      'Tienes força de vontade e um compromisso natural para alcançar os teus objetivos.';

  @override
  String get hdCenterEgoUndDesc =>
      'Não precisas de provar nada a ninguém; a tua vontade é flexível.';

  @override
  String get hdCenterSpleenDefDesc =>
      'Intuición aguda e instinto de supervivencia fuerte y constante.';

  @override
  String get hdCenterSpleenUndDesc =>
      'Captación de la salud y el bienestar de los demás de forma sensible e intuitiva.';

  @override
  String get hdCenterSolarDefDesc =>
      'Vives uma onda emocional cíclica e profunda; a claridad llega com o tempo.';

  @override
  String get hdCenterSolarUndDesc =>
      'Eres sensible às emoções dos outros, captando-as e amplificando-as.';

  @override
  String get hdCenterSacralDefDesc =>
      'Fuente inagotable de energía vital y persistencia para el trabajo que amas.';

  @override
  String get hdCenterSacralUndDesc =>
      'Necesitas descansar cuando la energía se agota; no tienes un motor vital constante.';

  @override
  String get hdCenterRootDefDesc =>
      'Manejas bien la presión y tienes un motor interno para impulsar la acción.';

  @override
  String get hdCenterRootUndDesc =>
      'Puedes sentir la presión externa pero prefieres actuar a tu próprio ritmo.';

  @override
  String get hdDefined => 'Definido';

  @override
  String get hdUndefined => 'Indefinido';

  @override
  String get hdGates => 'Puertas';

  @override
  String get hdGatesUser => 'Puertas del usuario';

  @override
  String get hdChannelsUser => 'Canales del usuario';

  @override
  String get legalInfo => 'Información Legal';

  @override
  String get deleteAccountData => 'Eliminación de Cuenta y Datos';

  @override
  String get verifyEmailTitle => 'Verifica tu Email';

  @override
  String verifyEmailSent(String email) {
    return 'Hemos enviado um correo de confirmación a $email. Por favor, revisa tu bandeja de entrada (y carpeta de spam).';
  }

  @override
  String get checkVerification => 'Ya lo he verificado';

  @override
  String get resendVerification => 'Reenviar correo';

  @override
  String get verificationResent => 'Correo de verificación reenviado.';

  @override
  String get orDivider => 'O';

  @override
  String get errorEmailAlreadyRegistered =>
      'Este email ya está registrado. Intente iniciar sesión en lugar de crear uma cuenta.';

  @override
  String get errorInvalidCredentials =>
      'Credenciales incorrectas o cuenta inexistente.';

  @override
  String get errorUserDisabled => 'Cuenta desactivada.';

  @override
  String get errorTooManyRequests =>
      'Bloqueado temporariamente por exceso de intentos.';

  @override
  String get errorAccountExistsGoogle =>
      'Ya existe uma conta com este email vinculada a Google. Use \"Continuar com Google\".';

  @override
  String errorUnexpected(Object error) {
    return 'Error inesperado: $error';
  }

  @override
  String errorGoogle(Object error) {
    return 'Error Google: $error';
  }

  @override
  String errorResetPassword(Object error) {
    return 'Error al restablecer: $error';
  }

  @override
  String get close => 'Cerrar';

  @override
  String authError(Object error) {
    return 'Error de Autenticación: $error';
  }

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String loadProfileError(String error) {
    return 'Error al cargar perfil: $error';
  }

  @override
  String get logoutAndTryAgain => 'Cerrar sesión e intentar de nuevo';

  @override
  String get astroMoonSign => 'Signo Lunar';

  @override
  String get astroMercurySign => 'Mercurio';

  @override
  String get astroVenusSign => 'Venus';

  @override
  String get astroMarsSign => 'Marte';

  @override
  String get astroMC => 'Medio del Cielo (MC)';

  @override
  String get astroNorthNode => 'Nodo Norte';

  @override
  String get astroSouthNode => 'Nodo Sur';

  @override
  String get astroHouses => 'Casas Astrológicas';

  @override
  String astroHouseN(int n) {
    return 'Casa $n';
  }

  @override
  String get astroAspects => 'Aspectos Planetários';

  @override
  String get astroBig3 => '🌟 Big 3';

  @override
  String get astroPersonalPlanets => '🪐 Planetas Pessoais';

  @override
  String get astroSocialGenerationalPlanets =>
      '🪐 Planetas Sociales y Generacionales';

  @override
  String get astroMCNodes => '🎯 MC y Nodos Lunares';

  @override
  String get hdIndicators => 'Indicadores principales';

  @override
  String get hdBodygraph => 'Mapa del cuerpo';

  @override
  String get astroSunDefDesc =>
      'El Sol representa tu esencia, tu identidad central, tu ego y la forma en que brillas en el mundo. Es el núcleo de tu personalidad.';

  @override
  String get astroMoonDefDesc =>
      'La Luna rige tus emociones, tu mundo interior, tus necesidades subconscientes y cómo te sientes seguro y nutrido.';

  @override
  String get astroAscendantDefDesc =>
      'El Ascendente es tu máscara social, la primera impresión que causas en los demás y la forma en que inicias nuevas etapas en la vida.';

  @override
  String get astroMercuryDefDesc =>
      'Mercurio rige tu mente, tu forma de comunicar, de procesar información, tu curiosidad intelectual y aprendizaje.';

  @override
  String get astroVenusDefDesc =>
      'Venus representa cómo amas, lo que valoras, tu estética y la forma en que te relacionas, das valor y atraes armonía.';

  @override
  String get astroMarsDefDesc =>
      'Marte simboliza tu acción, tu impulso, tu coraje y la forma en que persigues tus deseos y manejas desafíos y conflictos.';

  @override
  String get astroValSignAries =>
      'Energía pionera, valiente y llena de iniciativa. Le gusta liderar y enfrentar nuevos desafíos.';

  @override
  String get astroValSignTaurus =>
      'Enfoque en la estabilidad, el placer sensorial y la persistencia. Valora la seguridad y el confort material.';

  @override
  String get astroValSignGemini =>
      'Curiosidad insaciable, comunicación versátil y agilidad mental. Le encanta intercambiar ideas y aprender.';

  @override
  String get astroValSignCancer =>
      'Sensibilidad profunda, nutrición emocional y fuerte conexión con las raíces y la familia.';

  @override
  String get astroValSignLeo =>
      'Expresión creativa, confianza, calor y brillo personal. Busca reconocimiento y ser auténtico.';

  @override
  String get astroValSignVirgo =>
      'Análisis detallado, búsqueda de la perfección, organización y deseo de ser útil y práctico.';

  @override
  String get astroValSignLibra =>
      'Equilibrio, armonía en las relaciones, diplomacia y un fuerte sentido estético y de justicia.';

  @override
  String get astroValSignScorpio =>
      'Intensidad profunda, pasión, transformación y un poderoso magnetismo emocional.';

  @override
  String get astroValSignSagittarius =>
      'Expansión, búsqueda de significado, optimismo y amor por la libertad y la aventura intelectual.';

  @override
  String get astroValSignCapricorn =>
      'Responsabilidad, ambición, disciplina y un enfoque estructurado para alcanzar el éxito.';

  @override
  String get astroValSignAquarius =>
      'Originalidad, visión humanitaria, independencia y un pensamiento innovador y progresista.';

  @override
  String get astroValSignPisces =>
      'Empatía vasta, intuición aguda, imaginación y una fuerte conexión con el mundo espiritual y emocional.';
}
