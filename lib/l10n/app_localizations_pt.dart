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
  String get acceptTerms => 'Aceito os Termos e Condições';

  @override
  String get termsTitle => 'Termos e Condições';

  @override
  String get termsContent =>
      'Política de Privacidade - Human Match\n\nEsta Política de Privacidade descreve como a Human Match, uma aplicação móvel que gera relatórios personalizados de Human Design, Astrologia e Numerologia com base no nome completo, data e local de nascimento dos utilizadores, recolhe, utiliza e protege os seus dados pessoais. Estamos comprometidos com a proteção da sua privacidade em conformidade com o Regulamento Geral de Proteção de Dados (RGPD) de União Europeia e legislação aplicável em Portugal.\n\nDados Recolhidos\nRecolhemos apenas os dados estritamente necessários para fornecer o serviço:\n\nNome completo;\n\nData de nascimento;\n\nLocal de nascimento.\n\nEstes dados são usados exclusivamente para calcular e gerar os seus relatórios personalizados de Human Design, Astrologia e Numerologia. Não recolhemos dados sensíveis adicionais, como endereço de email ou informações financeiras, a menos que sejam voluntariamente fornecidos para suporte ou registo de conta.\n\nFinalidades do Tratamento\nOs dados são tratados para:\n\nGerar relatórios precisos baseados nos inputs fornecidos;\n\nMelhorar a precisão dos cálculos astrológicos e de design humano;\n\nPermitir o armazenamento opcional de relatórios para acesso futuro (com o seu consentimento explícito).\n\nO tratamento é lícito com base no seu consentimento livre e informado, obtido no momento da submissão dos dados.\n\nPartilha de Dados\nNão partilhamos os seus dados pessoais com terceiros, exceto:\n\nPrestadores de serviços técnicos essenciais (ex.: servidores de cloud seguros na UE) sob acordos de processamento de dados que garantem confidencialidade;\n\nQuando exigido por lei ou autoridades competentes.\n\nOs relatórios gerados são privados e não são vendidos ou usados para marketing.\n​\n\nArmazenamento e Segurança\nOs dados são armazenados em servidores seguros localizados na União Europeia, com medidas técnicas como encriptação (AES-256), pseudonimização e controlos de acesso. Retemos os dados apenas pelo tempo necessário para o serviço (geralmente até 30 dias após o último acesso, salvo consentimento para armazenamento prolongado). Procedemos à eliminação segura automática após esse período.\n\nOs Seus Direitos\nPode exercer os seus direitos RGPD a qualquer momento:\n\nAcesso aos dados;\n\nRetificação ou correção;\n\nApagamento (\"direito ao esquecimento\");\n\nOposição ao tratamento;\n\nLimitação do tratamento;\n\nPortabilidade dos dados.\n\nConsentimento e Alterações\nAo usar a app, consente com esta política. Pode revogar o consentimento a qualquer momento, o que impedirá o acesso a relatórios existentes. Atualizaremos esta política conforme necessário, notificando os utilizadores via app.';

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
  String get baseData => 'Dados base';

  @override
  String get baseDataDesc => 'Isto permite calcular Human Design + ascendente.';

  @override
  String get name => 'Nome';

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
  String get getDailyTip => 'Obter dica diária (Anúncio)';

  @override
  String get watchAdForTip => 'Vê o anúncio para obteres a tua dica diária';

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
  String get hdIncarnationCross => 'Cruz';

  @override
  String get hdEnergyCenters => 'Centros energéticos';

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
  String get hdPlanets => 'Astros';

  @override
  String get hdPersonality => 'Personalidade';

  @override
  String get hdConscious => '(Consciente)';

  @override
  String get hdGen => 'Gerador';

  @override
  String get hdMG => 'Gerador Manifestante';

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
  String get hdStrInf => 'Informar';

  @override
  String get hdStrResp => 'Esperar para responder';

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
  String get hdCenterEgo => 'Coração';

  @override
  String get hdCenterSpleen => 'Baço';

  @override
  String get hdCenterSolar => 'Plexo Solar';

  @override
  String get hdCenterSacral => 'Sacro';

  @override
  String get hdCenterRoot => 'Raiz';

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
}
