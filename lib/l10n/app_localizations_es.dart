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
  String get continueWithGoogle => 'Continuar with Google';

  @override
  String get acceptTerms => 'Acepto los Términos y Condiciones';

  @override
  String get termsTitle => 'Términos y Condiciones';

  @override
  String get termsContent =>
      'Política de Privacidad - Human Match\n\nEsta Política de Privacidade descreve como a Human Match, uma aplicação móvel que gera relatórios personalizados de Human Design, Astrologia e Numerologia com base no nome completo, data e local de nascimento dos utilizadores, recolhe, utiliza e protege os seus dados pessoais. Estamos comprometidos com a proteção da sua privacidade em conformidade com o Regulamento Geral de Proteção de Dados (RGPD) da União Europeia e legislação aplicável em Portugal.\n\nDados Recolhidos\nRecolhemos apenas os dados estritamente necessários para fornecer o serviço:\n\nNome completo;\n\nData de nascimento;\n\nLocal de nascimento.\n\nEstes dados são usados exclusivamente para calcular e gerar os seus relatórios personalizados de Human Design, Astrologia e Numerologia. No recolhemos dados sensíveis adicionais, como endereço de email ou informações financeiras, a menos que sejam voluntariamente fornecidos para suporte ou registo de conta.\n\nFinalidades do Tratamento\nOs dados são tratados para:\n\nGerar relatórios precisos baseados nos inputs fornecidos;\n\nMelhorar a precisão dos cálculos astrológicos e de design humano;\n\nPermitir o armazenamento opcional de relatórios para acesso futuro (com o seu consentimento explícito).\n\nO tratamento é lícito con base en su consentimiento libre e informado, obtenido en el momento del envío de los datos.\n\nIntercambio de Datos\nNo compartimos sus datos personales con terceros, excepto:\n\nProveedores de servicios técnicos esenciales (ej.: servidores en la nube seguros en la UE) bajo acuerdos de procesamiento de datos que garantizan la confidencialidad;\n\nCuando lo exija la ley o las autoridades competentes.\n\nLos informes generados son privados y no se venden ni se utilizan para marketing.\n​\n\nAlmacenamiento y Seguridad\nLos datos se almacenan en servidores seguros ubicados en la Unión Europea, con medidas técnicas como cifrado (AES-256), seudonimización y controles de acceso. Conservamos los datos solo el tiempo necesario para el servicio (generally up to 30 days after the last access, unless consent for prolonged storage is given). Procedemos a la eliminación segura automática después de este período.\n\nSus Derechos\nPuede ejercer sus derechos RGPD en cualquier momento:\n\nAcceso a los datos;\n\nRectificación o correction;\n\nSupresión (\"derecho al olvido\");\n\nOposición al tratamiento;\n\nLimitación del tratamiento;\n\nPortabilidad de los datos.\n\nPara solicitar la eliminación de su cuenta y de todos los datos asociados, puede hacerlo a través del siguiente enlace: https://humanmatch.app/delete-account o enviando un correo electrónico a support@humanmatch.app.\n\nConsentimiento e Cambios\nAl usar la aplicación, usted acepta esta política. Puede revocar su consentimiento en cualquier momento, lo que impedirá el acceso a los informes existentes. Actualizaremos esta política según sea necesario, notificando a los usuarios a través de la aplicación.';

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
  String get numTitle => 'Numerologia';

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
  String get hdStrategy => 'Estratégia';

  @override
  String get hdProfile => 'Perfil';

  @override
  String get hdSignature => 'Firma';

  @override
  String get hdNotSelf => 'No-ser';

  @override
  String get hdDefinition => 'Definicón';

  @override
  String get hdIncarnationCross => 'Cruz de Encarnación';

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
  String get hdUnconscious => '(Inconsciente)';

  @override
  String get hdPlanetaryActivation => 'Activación Planetaria';

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
  String get hdDefSin => 'Definicón Única';

  @override
  String get hdDefSpl => 'Definicón Partida';

  @override
  String get hdDefTri => 'Triple Partida';

  @override
  String get hdDefQua => 'Cuádruple Partida';

  @override
  String get hdCrossRight => 'Ángulo Direito';

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
  String get hdCenterEgo => 'Corazón';

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
  String get astroSouthNode => 'Nodo Sul';

  @override
  String get astroHouses => 'Casas Astrológicas';

  @override
  String astroHouseN(int n) {
    return 'Casa $n';
  }

  @override
  String get astroAspects => 'Aspectos Planetarios';

  @override
  String get astroBig3 => '🌟 Big 3';

  @override
  String get astroPersonalPlanets => '🪐 Planetas Pessoales';

  @override
  String get astroSocialGenerationalPlanets =>
      '🪐 Planetas Sociales y Geracionales';

  @override
  String get astroMCNodes => '🎯 MC y Nodos Lunares';

  @override
  String get hdIndicators => 'Indicadores principales';

  @override
  String get hdBodygraph => 'Mapa del cuerpo';

  @override
  String get hdCenterHeadDefDesc =>
      'Procesas pensamientos de forma constante y te inspiras en tus propias ideas.';

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
      'Comunicación y ação constantes e fiáveis através da tua voz e feitos.';

  @override
  String get hdCenterThroatUndDesc =>
      'Comunicación variable, dependendo do ambiente e de quem te rodeia.';

  @override
  String get hdCenterGDefDesc =>
      'Tienes un sentido fijo y claro de quem és, do teu propósito e direção na vida.';

  @override
  String get hdCenterGUndDesc =>
      'Tu identidad es fluida e podes adaptar-te e encontrar-te em diversos ambientes.';

  @override
  String get hdCenterEgoDefDesc =>
      'Tienes força de vontade e um compromisso natural para alcançar os teus objetivos.';

  @override
  String get hdCenterEgoUndDesc =>
      'No necesitas provar nada a ninguém; a tua vontade é flexível.';

  @override
  String get hdCenterSpleenDefDesc =>
      'Intuición aguçada e instinto de sobrevivência forte e constante.';

  @override
  String get hdCenterSpleenUndDesc =>
      'Captación da saúde e bem-estar dos outros de forma sensível e intuitiva.';

  @override
  String get hdCenterSolarDefDesc =>
      'Vives uma onda emocional cíclica e profunda; a claridade vem com o tempo.';

  @override
  String get hdCenterSolarUndDesc =>
      'Eres sensível às emoções dos outros, captando-as e amplificando-as.';

  @override
  String get hdCenterSacralDefDesc =>
      'Fonte inesgotável de energia vital e persistência para o trabalho que amas.';

  @override
  String get hdCenterSacralUndDesc =>
      'Necesitas descansar quando a energia acaba; não tens um motor vital constante.';

  @override
  String get hdCenterRootDefDesc =>
      'Manejas bem a pressão e tens um motor interno para impulsionar a ação.';

  @override
  String get hdCenterRootUndDesc =>
      'Podes sentir a pressão externa mas preferes agir ao teu próprio ritmo.';

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
  String get hdCenterName_head => 'Cabeza';

  @override
  String get hdCenterName_ajna => 'Ajna';

  @override
  String get hdCenterName_throat => 'Garganta';

  @override
  String get hdCenterName_g => 'Centro G';

  @override
  String get hdCenterName_heart => 'Corazón';

  @override
  String get hdCenterName_spleen => 'Bazo';

  @override
  String get hdCenterName_solar => 'Plexo Solar';

  @override
  String get hdCenterName_sacral => 'Sacral';

  @override
  String get hdCenterName_root => 'Raiz';

  @override
  String get hdTypeDefDesc =>
      'El Tipo define cómo tu energía interactúa con el mundo.';

  @override
  String get hdAuthorityDefDesc =>
      'Tu Autoridad es tu sistema interno de toma de decisiones.';

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
      'Tu Cruz de Encarnación representa o propósito da tua vida.';

  @override
  String get hdValType_generator =>
      'Como Gerador, a tua energia é desenhada para responder ao que a vida te traz, em vez de iniciares.';

  @override
  String get hdValType_manifestingGenerator =>
      'Tens a rapidez do Manifestador e a sustentabilidade do Gerador. Responde antes de agir.';

  @override
  String get hdValType_manifestor =>
      'Vieste para iniciar e impactar. Informa os outros antes de agires para reduzir a resistência.';

  @override
  String get hdValType_projector =>
      'Estás aqui para guiar os outros. O teu sucesso vem ao esperares pelo reconhecimento e convite.';

  @override
  String get hdValType_reflector =>
      'És um espelho da comunidade. Espera um ciclo lunar completo antes de tomares decisões importantes.';

  @override
  String get hdValAuth_emotional =>
      'A claridade não acontece no agora. Espera que a tua onda emocional estabilize antes de decidires.';

  @override
  String get hdValAuth_sacral =>
      'Confia na tua resposta visceral imediata (sons sacrais ou inclinação física) no momento presente.';

  @override
  String get hdValAuth_splenic =>
      'Confia na tua intuição instintiva e espontânea que te avisa sobre o que é seguro e saudável.';

  @override
  String get hdValAuth_ego =>
      'A tua vontade é o teu guia. O que é que tu realmente queres e tens vontade de fazer?';

  @override
  String get hdValAuth_selfProjected =>
      'A tua verdade sai pela tua boca. Ouve o que dizes quando falas sem pensar sobre o teu futuro.';

  @override
  String get hdValAuth_mental =>
      'Precisas de usar os outros como caixa de ressonância para ouvires a tua própria verdade ao falar.';

  @override
  String get hdValAuth_lunar =>
      'Como Refletor, a tua decisão amadurece ao longo de 28 dias em sintonia com o ciclo da Lua.';

  @override
  String get hdValStr_respond =>
      'A tua melhor forma de agir é responder às oportunidades que aparecem, em vez de tentar forçar coisas novas.';

  @override
  String get hdValStr_inform =>
      'Para reduzir a resistência dos outros, informa as pessoas afetadas pelas tuas ações antes de as tomares.';

  @override
  String get hdValStr_respondInform =>
      'Como MG, deves responder primeiro e depois informar quem te rodeia antes de entrares em ação rápida.';

  @override
  String get hdValStr_invite =>
      'Deves esperar por reconhecimento formal e um convite antes de partilhares a tua sabedoria ou orientação.';

  @override
  String get hdValStr_lunar =>
      'Decisões importantes devem ser tomadas apenas após um ciclo lunar completo (aproximadamente 28 dias).';

  @override
  String get hdValSig_satisfaction =>
      'Sentes satisfação quando usas a tua energia de forma produtiva em algo que te dá prazer.';

  @override
  String get hdValSig_success =>
      'O sucesso para ti é ser reconhecido pelo que és e ver os outros prosperarem com a tua guia.';

  @override
  String get hdValSig_peace =>
      'Sentirás paz quando puderes agir livremente e sem resistência após informares os outros.';

  @override
  String get hdValSig_surprise =>
      'A surpresa é o sinal de que estás a ver a vida com olhos novos, como um espelho puro do ambiente.';

  @override
  String get hdValNot_frustration =>
      'A frustração surge quando tentas iniciar coisas sem esperar pela resposta certa.';

  @override
  String get hdValNot_bitterness =>
      'A amargura aparece quando te esforças demais sem ser convidado ou reconhecido.';

  @override
  String get hdValNot_anger =>
      'A raiva é o resultado de sentires resistência por não informares os outros sobre as tuas intenções.';

  @override
  String get hdValNot_disappointment =>
      'A desilusão ocorre quando não estás num ambiente saudável ou tentas decidir depressa demais.';
}
