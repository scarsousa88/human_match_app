// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Human Match';

  @override
  String get tabProfile => 'O meu Perfil';

  @override
  String get tabCommunity => 'Comunidade';

  @override
  String get tabCompare => 'Comparar';

  @override
  String get welcomeMessage => 'Conhece-te bem, relaciona-te melhor!';

  @override
  String get soonMessage => 'Brevemente';

  @override
  String get communitySoon => 'Explora perfis próximos e compatíveis';

  @override
  String get compareSoon => 'Compara perfis manualmente';

  @override
  String get logout => 'Sair';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Criar conta';

  @override
  String get forgotPassword => 'Esqueci-me da password';

  @override
  String get noAccount => 'Não tens conta? Criar';

  @override
  String get hasAccount => 'Já tens conta? Entrar';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get acceptTerms => 'Aceito os Termos e Condições';

  @override
  String get termsTitle => 'Terms and Conditions';

  @override
  String get termsContent =>
      'Política de Privacidade - Human Match\n\nEsta Política de Privacidade descreve como a Human Match, uma aplicação móvel que gera relatórios personalizados de Human Design, Astrologia e Numerologia com base no nome completo, data e local de nascimento dos utilizadores, recolhe, utiliza e protege os seus dados pessoais. Estamos comprometidos com a proteção da sua privacidade em conformidade com o Regulamento Geral de Proteção de Dados (RGPD) da União Europeia e legislação aplicável em Portugal.\n\nDados Recolhidos\nRecolhemos apenas os dados estritamente necessários para fornecer o serviço:\n\nNome completo;\n\nData de nascimento;\n\nLocal de nascimento.\n\nEstes dados são usados exclusivamente para calcular e gerar os seus relatórios personalizados de Human Design, Astrologia e Numerologia. Não recolhemos dados sensíveis adicionais, como endereço de email ou informações financeiras, a menos que sejam voluntariamente fornecidos para suporte ou registo de conta.\n\nFinalidades do Tratamento\nOs dados são tratados para:\n\nGerar relatórios precisos baseados nos inputs fornecidos;\n\nMelhorar a precisão dos cálculos astrológicos e de design humano;\n\nPermitir o armazenamento opcional de relatórios para acesso futuro (com o seu consentimento explícito).\n\nO tratamento é lícito com base no seu consentimento livre e informado, obtido no momento da submissão dos dados.\n\nPartilha de Dados\nNão partilhamos os seus dados pessoais com terceiros, exceto:\n\nPrestadores de serviços técnicos essenciais (ex.: servidores de cloud seguros na UE) sob acordos de processamento de dados que garantisent confidencialidade;\n\nQuando exigido por lei ou autoridades competentes.\n\nOs relatórios gerados são privados e não são vendidos ou usados para marketing.\n​\n\nArmazenamento e Segurança\nDados são armazenados em servidores seguros localizados na União Europeia, com medidas técnicas como encriptação (AES-256), pseudonimização e controlos de acesso. Retemos os dados apenas pelo tempo necessário para o serviço (geralmente até 30 dias após o último acesso, salvo consentimento para armazenamento prolongado). Procedemos à eliminação segura automática após esse período.\n\nOs Seus Direitos\nPode exercer os seus direitos RGPD a qualquer momento:\n\nAcesso aos dados;\n\nRectificação ou correção;\n\nApagamento (\"direito ao esquecimento\");\n\nOposição ao tratamento;\n\nLimitação do tratamento;\n\nPortabilidade dos dados.\n\nPara solicitar a eliminação da sua conta e de todos os dados associados, poderá fazê-lo através do seguinte link: https://humanmatch.app/delete-account ou enviando um email para support@humanmatch.app.\n\nConsentement e Alterações\nAo usar a app, você consente com esta política. Pode revogar o consentimento a qualquer momento, o que impedirá o acesso a relatórios existentes. Atualizaremos esta política conforme necessário, notificando os utilizadores via app.';

  @override
  String get processing => 'A processar...';

  @override
  String get acceptAndContinue => 'Aceito e desejo continuar';

  @override
  String get cancelAndExit => 'Cancelar e sair';

  @override
  String get loading => 'Aguarda...';

  @override
  String get createProfile => 'Criar perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get baseData => 'Dados do utilizador';

  @override
  String get baseDataDesc => 'Isto permite calcular Human Design + ascendente.';

  @override
  String get name => 'Nome Completo';

  @override
  String get nameNumerologyInfo =>
      'Este campo será usado para determinar as variáveis da Numerologia. Não deves usar caracteres especiais ou acentuação.';

  @override
  String get country => 'País';

  @override
  String get city => 'Cidade';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get birthPlace => 'Local de nascimento';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get selectTime => 'Selecionar hora';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String greeting(String name) {
    return 'Olá $name';
  }

  @override
  String get greetingEmpty => 'Olá!';

  @override
  String get hdTitle => 'Human Design';

  @override
  String get hdCalculating => 'Ainda a calcular Human Design...';

  @override
  String get astroTitle => 'Astrologia';

  @override
  String get zodiacSign => 'Signo';

  @override
  String get ascendant => 'Ascendente';

  @override
  String get numTitle => 'Numerologia';

  @override
  String get lifePath => 'Caminho de Vida';

  @override
  String get expression => 'Expressão';

  @override
  String get soul => 'Alma';

  @override
  String get personality => 'Personalidade';

  @override
  String get profileInsights => 'Insights de Perfil';

  @override
  String get noInsights => 'Ainda não tens insights gerados.';

  @override
  String get generateInsights => 'Gerar Insights (Anúncio)';

  @override
  String get update => 'Atualizar';

  @override
  String get profilePillars => 'Pilares do teu Perfil';

  @override
  String get dailyTip => 'Dica Diária';

  @override
  String get getDailyTip => 'Obter dica diária';

  @override
  String get watchAdForTip => 'Vê o vídeo para obteres a tua dica diária';

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
    return 'Erro ao guardar/calculando: $error';
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

  @override
  String get hdType => 'Tipo';

  @override
  String get hdAuthority => 'Autoridade';

  @override
  String get hdStrategy => 'Estratégia';

  @override
  String get hdProfile => 'Perfil';

  @override
  String get hdSignature => 'Assinatura';

  @override
  String get hdNotSelf => 'Não-ser';

  @override
  String get hdDefinition => 'Definição';

  @override
  String get hdIncarnationCross => 'Cruz de Encarnação';

  @override
  String get hdEnergyCenters => 'Centros';

  @override
  String get hdEnergyCentersChannels => 'Centros, canais e portas';

  @override
  String get hdDefinedCenters => 'Centros Definidos';

  @override
  String get hdChannels => 'Canais';

  @override
  String get hdNoData => 'Nenhum dado disponível.';

  @override
  String hdAuthorityNotice(String center) {
    return '* $center é o centro autoritário (Autoridade)';
  }

  @override
  String get hdDesign => 'Design';

  @override
  String get hdUnconscious => '(Inconsciente)';

  @override
  String get hdPlanetaryActivation => 'Ativação Planetária';

  @override
  String get hdPlanets => 'Astros';

  @override
  String get hdPlanetSun => 'Sol';

  @override
  String get hdPlanetEarth => 'Terra';

  @override
  String get hdPlanetMoon => 'Lua';

  @override
  String get hdPlanetMercury => 'Mercúrio';

  @override
  String get hdPlanetVenus => 'Vénus';

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
  String get hdPlanetPluto => 'Plutão';

  @override
  String get hdPersonality => 'Personalidade';

  @override
  String get hdConscious => '(Consciente)';

  @override
  String get hdGen => 'Gerador';

  @override
  String get hdMG => 'Gerador Manifestador';

  @override
  String get hdMan => 'Manifestador';

  @override
  String get hdProj => 'Projetor';

  @override
  String get hdRef => 'Refletor';

  @override
  String get hdAuthEmo => 'Emocional';

  @override
  String get hdAuthSac => 'Sacral';

  @override
  String get hdAuthSpl => 'Esplénica';

  @override
  String get hdAuthEgo => 'Ego';

  @override
  String get hdAuthSelf => 'Auto-projetada';

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
  String get hdStrInv => 'Esperar pelo convite';

  @override
  String get hdStrLun => 'Esperar ciclo lunar';

  @override
  String get hdSigSat => 'Satisfação';

  @override
  String get hdSigSuc => 'Sucesso';

  @override
  String get hdSigPea => 'Paz';

  @override
  String get hdSigSur => 'Surpresa';

  @override
  String get hdNotFru => 'Frustração';

  @override
  String get hdNotBit => 'Amargura';

  @override
  String get hdNotAng => 'Raiva';

  @override
  String get hdNotDis => 'Desilusão';

  @override
  String get hdDefSin => 'Definição Única';

  @override
  String get hdDefSpl => 'Definição Partida';

  @override
  String get hdDefTri => 'Definição Tripla';

  @override
  String get hdDefQua => 'Definição Quádrupla';

  @override
  String get hdCrossRight => 'Ângulo Direito';

  @override
  String get hdCrossLeft => 'Ângulo Esquerdo';

  @override
  String get hdCrossJuxta => 'Justaposição';

  @override
  String get hdCrossOf => 'Cruz de';

  @override
  String get hdCenterHead => 'Cabeça';

  @override
  String get hdCenterAjna => 'Ajna';

  @override
  String get hdCenterThroat => 'Garganta';

  @override
  String get hdCenterG => 'Centro G';

  @override
  String get hdCenterEgo => 'Coração (Ego)';

  @override
  String get hdCenterSpleen => 'Baço';

  @override
  String get hdCenterSolar => 'Plexo Solar';

  @override
  String get hdCenterSacral => 'Sacral';

  @override
  String get hdCenterRoot => 'Raiz';

  @override
  String get hdCenterNameHead => 'Cabeça';

  @override
  String get hdCenterNameAjna => 'Ajna';

  @override
  String get hdCenterNameThroat => 'Garganta';

  @override
  String get hdCenterNameG => 'Centro G';

  @override
  String get hdCenterNameHeart => 'Coração';

  @override
  String get hdCenterNameSpleen => 'Baço';

  @override
  String get hdCenterNameSolar => 'Plexo Solar';

  @override
  String get hdCenterNameSacral => 'Sacral';

  @override
  String get hdCenterNameRoot => 'Raiz';

  @override
  String get hdTypeDefDesc =>
      'O Tipo define a forma como a tua energia interage com o mundo.';

  @override
  String get hdAuthorityDefDesc =>
      'A tua Autoridade é o teu sistema interno de tomada de decisão.';

  @override
  String get hdStrategyDefDesc =>
      'A Estratégia é o método para navegar na vida com menos resistência.';

  @override
  String get hdProfileDefDesc =>
      'O Perfil descreve o teu papel e a forma como aprendes e evoluis.';

  @override
  String get hdSignatureDefDesc =>
      'A Assinatura é a sensação de estar alinhado com o teu design.';

  @override
  String get hdNotSelfDefDesc =>
      'O Não-ser é o sinal de que te estás a desviar da tua verdade.';

  @override
  String get hdDefinitionDefDesc =>
      'A Definição mostra como a energia flui entre os teus centros.';

  @override
  String get hdIncarnationCrossDefDesc =>
      'A tua Cruz de Encarnação representa o teu propósito de vida.';

  @override
  String get hdValTypeGenerator =>
      'Como Gerador, a tua energia é desenhada para responder ao que a vida te traz, em vez de iniciares.';

  @override
  String get hdValTypeManifestingGenerator =>
      'Tens a rapidez do Manifestador e a sustentabilidade do Gerador. Responde antes de agir.';

  @override
  String get hdValTypeManifestor =>
      'Vieste para iniciar e impactar. Informa os outros antes de agires para reduzir a resistência.';

  @override
  String get hdValTypeProjector =>
      'Estás aqui para guiar os outros. O teu sucesso vem ao esperares pelo reconhecimento e convite.';

  @override
  String get hdValTypeReflector =>
      'És um espelho da comunidade. Espera um ciclo lunar completo antes de tomares decisões importantes.';

  @override
  String get hdValAuthEmotional =>
      'A claridade não acontece no agora. Espera que a tua onda emocional estabilize antes de decidires.';

  @override
  String get hdValAuthSacral =>
      'Confia na tua resposta visceral imediata (sons sacrais ou inclinação física) no momento presente.';

  @override
  String get hdValAuthSplenic =>
      'Confia na tua intuição instintiva e espontânea que te avisa sobre o que é seguro e saudável.';

  @override
  String get hdValAuthEgo =>
      'A tua vontade é o teu guia. O que é que tu realmente queres e tens vontade de fazer?';

  @override
  String get hdValAuthSelfProjected =>
      'A tua verdade sai pela tua boca. Ouve o que dizes quando falas sem pensar sobre o teu futuro.';

  @override
  String get hdValAuthMental =>
      'Precisas de usar os outros como caixa de ressonância para ouvires a tua própria verdade ao falar.';

  @override
  String get hdValAuthLunar =>
      'Como Reflector, a tua decisão amadurece ao longo de 28 dias em sintonia com o ciclo da Lua.';

  @override
  String get hdValStrRespond =>
      'A tua melhor forma de agir é responder às oportunidades que aparecem, em vez de tentar forçar coisas novas.';

  @override
  String get hdValStrInform =>
      'Para reduzir a resistência dos outros, informa as pessoas afetadas pelas tuas ações antes de as tomares.';

  @override
  String get hdValStrRespondInform =>
      'Como MG, deves responder primeiro e depois informar quem te rodeia antes de entrares em ação rápida.';

  @override
  String get hdValStrInvite =>
      'Deves esperar por reconhecimento formal e um convite antes de partilhares a tua sabedoria ou orientação.';

  @override
  String get hdValStrLunar =>
      'Decisões importantes devem ser tomadas apenas após um ciclo lunar completo (aproximadamente 28 dias).';

  @override
  String get hdValSigSatisfaction =>
      'Sentes satisfação quando usas a tua energia de forma produtiva em algo que te dá prazer.';

  @override
  String get hdValSigSuccess =>
      'O sucesso para ti é ser reconhecido pelo que és e ver os outros prosperarem com a tua guia.';

  @override
  String get hdValSigPeace =>
      'Sentirás paz quando puderes agir livremente e sem resistência após informares os outros.';

  @override
  String get hdValSigSurprise =>
      'A surpresa é o sinal de que estás a ver a vida com olhos novos, como um espelho puro do ambiente.';

  @override
  String get hdValNotFrustration =>
      'A frustração surge quando tentas iniciar coisas sem esperar pela resposta certa.';

  @override
  String get hdValNotBitterness =>
      'A amargura aparece quando te esforças demais sem ser convidado ou reconhecido.';

  @override
  String get hdValNotAnger =>
      'A raiva é o resultado de sentires resistência por não informares os outros sobre as tuas intenções.';

  @override
  String get hdValNotDisappointment =>
      'A desilusão ocorre quando não estás num ambiente saudável ou tentas decidir depressa demais.';

  @override
  String get hdValProf13 =>
      'Investigador/Mártir: Aprende através da experimentação, fundações sólidas e profundidade.';

  @override
  String get hdValProf14 =>
      'Investigador/Oportunista: Influencia a sua rede próxima partilhando o seu estudo profundo.';

  @override
  String get hdValProf24 =>
      'Eremita/Oportunista: Um talento natural que precisa de tempo sozinho, mas que florece na sua rede.';

  @override
  String get hdValProf25 =>
      'Eremita/Herege: Talento natural projetado para ser um guia ou salvador para os outros.';

  @override
  String get hdValProf35 =>
      'Mártir/Herege: Aprende por tentativa e erro e partilha o que funciona para desafiar o status quo.';

  @override
  String get hdValProf36 =>
      'Mártir/Observador: Experimenta na primeira fase da vida para se tornar um guia sábio e objetivo.';

  @override
  String get hdValProf46 =>
      'Oportunista/Observador: Influencia através da rede e objetividade, tornando-se um modelo de papel.';

  @override
  String get hdValProf41 =>
      'Oportunista/Investigador: Segue um caminho fixo e único com base em fundações muito sólidas.';

  @override
  String get hdValProf51 =>
      'Herege/Investigador: O mestre que resolve problemas práticos através de estudo e autoridade.';

  @override
  String get hdValProf52 =>
      'Herege/Eremita: Motivado pela autorreflexão, mas visto pelos outros como um guia natural.';

  @override
  String get hdValProf62 =>
      'Observador/Eremita: Modelo de papel que vive with objetividade e desapego após uma vida de experiência.';

  @override
  String get hdValProf63 =>
      'Observador/Mártir: Modelo de papel que continua a evoluir através da experimentação constante.';

  @override
  String get hdCenterHeadDefDesc =>
      'Processas pensamentos de forma constante e inspiras-te nas tuas próprias ideias.';

  @override
  String get hdCenterHeadUndDesc =>
      'És aberto a novas ideias e tens flexibilidade para ver diferentes perspetivas.';

  @override
  String get hdCenterAjnaDefDesc =>
      'Tens uma forma fixa e organizada de pensar e processar informação.';

  @override
  String get hdCenterAjnaUndDesc =>
      'Podes adaptar a tua forma de pensar a qualquer situação sem opiniões rígidas.';

  @override
  String get hdCenterThroatDefDesc =>
      'Comunicação e ação constantes e fiáveis através da tua voz e feitos.';

  @override
  String get hdCenterThroatUndDesc =>
      'Comunicação variável, dependendo do ambiente e de quem te rodeia.';

  @override
  String get hdCenterGDefDesc =>
      'Tens um sentido fixo e claro de quem és, do teu propósito e direção na vida.';

  @override
  String get hdCenterGUndDesc =>
      'A tua identidade é fluida e podes adaptar-te e encontrar-te em diversos ambientes.';

  @override
  String get hdCenterEgoDefDesc =>
      'Tens força de vontade e um compromisso natural para alcançar os teus objetivos.';

  @override
  String get hdCenterEgoUndDesc =>
      'Não precisas de provar nada a ninguém; a tua vontade é flexível.';

  @override
  String get hdCenterSpleenDefDesc =>
      'Intuição aguçada e instinto de sobrevivência forte e constante.';

  @override
  String get hdCenterSpleenUndDesc =>
      'Captação da saúde e bem-estar dos outros de forma sensível e intuitiva.';

  @override
  String get hdCenterSolarDefDesc =>
      'Vives uma onda emocional cíclica e profunda; a claridade vem com o tempo.';

  @override
  String get hdCenterSolarUndDesc =>
      'És sensível às emoções dos outros, captando-as e amplificando-as.';

  @override
  String get hdCenterSacralDefDesc =>
      'Fonte inesgotável de energia vital e persistência para o trabalho que amas.';

  @override
  String get hdCenterSacralUndDesc =>
      'Precisas de descansar quando a energia acaba; não tens um motor vital constante.';

  @override
  String get hdCenterRootDefDesc =>
      'Lidas bem com a pressão e tens um motor interno para impulsionar a ação.';

  @override
  String get hdCenterRootUndDesc =>
      'Podes sentir a pressão externa mas preferes agir ao teu próprio ritmo.';

  @override
  String get hdDefined => 'Definido';

  @override
  String get hdUndefined => 'Indefinido';

  @override
  String get hdGates => 'Portas';

  @override
  String get hdGatesUser => 'Portas do utilizador';

  @override
  String get hdChannelsUser => 'Canais do utilizador';

  @override
  String get legalInfo => 'Informações Legais';

  @override
  String get deleteAccountData => 'Eliminação de Conta e Dados';

  @override
  String get verifyEmailTitle => 'Verifica o teu Email';

  @override
  String verifyEmailSent(String email) {
    return 'Enviámos um email de confirmação para $email. Por favor, verifica a tua caixa de entrada (e pasta de spam).';
  }

  @override
  String get checkVerification => 'Já verifiquei';

  @override
  String get resendVerification => 'Reenviar email';

  @override
  String get verificationResent => 'Email de verificação reenviado.';

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
  String loadProfileError(String error) {
    return 'Erro ao carregar perfil: $error';
  }

  @override
  String get logoutAndTryAgain => 'Sair e Tentar Novamente';

  @override
  String get astroMoonSign => 'Signo Lunar';

  @override
  String get astroMercurySign => 'Mercúrio';

  @override
  String get astroVenusSign => 'Vénus';

  @override
  String get astroMarsSign => 'Marte';

  @override
  String get astroMC => 'Meio do Céu (MC)';

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
  String get astroAspects => 'Aspetos Planetários';

  @override
  String get astroBig3 => '🌟 Big 3';

  @override
  String get astroPersonalPlanets => '🪐 Planetas Pessoais';

  @override
  String get astroSocialGenerationalPlanets =>
      '🪐 Planetas Sociais e Geracionais';

  @override
  String get astroMCNodes => '🎯 MC e Nodos Lunares';

  @override
  String get hdIndicators => 'Principais Indicadores';

  @override
  String get hdBodygraph => 'Mapa do Corpo (Bodygraph)';

  @override
  String get astroSunDefDesc =>
      'O Sol representa a tua essência, a tua identidade central, o teu ego e a forma como brilhas no mundo. É o núcleo da tua personalidade.';

  @override
  String get astroMoonDefDesc =>
      'A Lua rege as tuas emoções, o teu mundo interior, as tuas necessidades subconscientes e como te sentes seguro e nutrido.';

  @override
  String get astroAscendantDefDesc =>
      'O Ascendente é a tua máscara social, a primeira impressão que causas nos outros e a forma como inicias novas etapas na vida.';

  @override
  String get astroMercuryDefDesc =>
      'Mercúrio rege a tua mente, a tua forma de comunicar, de processar informação, a tua curiosidade intelectual e aprendizagem.';

  @override
  String get astroVenusDefDesc =>
      'Vénus representa como amas, o que valorizas, a tua estética e a forma como te relacionas, dás valor e atrais harmonia.';

  @override
  String get astroMarsDefDesc =>
      'Marte simboliza a tua ação, o teu impulso, a tua coragem e a forma como persegues os teus desejos e lidas com desafios e conflitos.';

  @override
  String get astroValSignAries =>
      'Energia pioneira, corajosa e cheia de iniciativa. Gosta de liderar e de novos desafios.';

  @override
  String get astroValSignTaurus =>
      'Foco na estabilidade, prazer sensorial e persistência. Valoriza a segurança e o conforto material.';

  @override
  String get astroValSignGemini =>
      'Curiosidade insaciável, comunicação versátil e agilidade mental. Adora trocar ideias e aprender.';

  @override
  String get astroValSignCancer =>
      'Sensibilidade profunda, nutrição emocional e forte ligação às raízes e à família.';

  @override
  String get astroValSignLeo =>
      'Expressão criativa, confiança, calor e brilho pessoal. Procura reconhecimento e ser autêntico.';

  @override
  String get astroValSignVirgo =>
      'Análise detalhada, busca pela perfeição, organização e desejo de ser útil e prático.';

  @override
  String get astroValSignLibra =>
      'Equilíbrio, harmonia nas relações, diplomacia e um forte senso estético e de justiça.';

  @override
  String get astroValSignScorpio =>
      'Intensidade profunda, paixão, transformação e um poderoso magnetismo emocional.';

  @override
  String get astroValSignSagittarius =>
      'Expansão, busca por significado, otimismo e amor pela liberdade e aventura intelectual.';

  @override
  String get astroValSignCapricorn =>
      'Responsabilidade, ambição, disciplina e uma abordagem estruturada para alcançar o sucesso.';

  @override
  String get astroValSignAquarius =>
      'Originalidade, visão humanitária, independência e um pensamento inovador e progressista.';

  @override
  String get astroValSignPisces =>
      'Empatia vasta, intuição aguçada, imaginação e uma forte ligação ao mundo espiritual e emocional.';

  @override
  String get onlyMobile => 'Apenas disponível em dispositivos móveis.';

  @override
  String get downloadApp =>
      'Descarrega a app para acederes a esta funcionalidade:';
}
