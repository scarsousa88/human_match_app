import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Human Match'**
  String get appTitle;

  /// No description provided for @tabProfile.
  ///
  /// In pt, this message translates to:
  /// **'O meu Perfil'**
  String get tabProfile;

  /// No description provided for @tabCommunity.
  ///
  /// In pt, this message translates to:
  /// **'Comunidade'**
  String get tabCommunity;

  /// No description provided for @tabCompare.
  ///
  /// In pt, this message translates to:
  /// **'Comparar'**
  String get tabCompare;

  /// No description provided for @welcomeMessage.
  ///
  /// In pt, this message translates to:
  /// **'Conhece-te bem, relaciona-te melhor!'**
  String get welcomeMessage;

  /// No description provided for @soonMessage.
  ///
  /// In pt, this message translates to:
  /// **'Brevemente'**
  String get soonMessage;

  /// No description provided for @communitySoon.
  ///
  /// In pt, this message translates to:
  /// **'Explora perfis próximos e compatíveis'**
  String get communitySoon;

  /// No description provided for @compareSoon.
  ///
  /// In pt, this message translates to:
  /// **'Compara perfis manualmente'**
  String get compareSoon;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get login;

  /// No description provided for @register.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci-me da password'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tens conta? Criar'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já tens conta? Entrar'**
  String get hasAccount;

  /// No description provided for @continueWithGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Continuar com Google'**
  String get continueWithGoogle;

  /// No description provided for @acceptTerms.
  ///
  /// In pt, this message translates to:
  /// **'Aceito os Termos e Condições'**
  String get acceptTerms;

  /// No description provided for @termsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Termos e Condições'**
  String get termsTitle;

  /// No description provided for @termsContent.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade - Human Match\n\nEsta Política de Privacidade descreve como a Human Match, uma aplicação móvel que gera relatórios personalizados de Human Design, Astrologia e Numerologia com base no nome completo, data e local de nascimento dos utilizadores, recolhe, utiliza e protege os seus dados pessoais. Estamos comprometidos com a proteção da sua privacidade em conformidade com o Regulamento Geral de Proteção de Dados (RGPD) da União Europeia e legislação aplicável em Portugal.\n\nDados Recolhidos\nRecolhemos apenas os dados estritamente necessários para fornecer o serviço:\n\nNome completo;\n\nData de nascimento;\n\nLocal de nascimento.\n\nEstes dados são usados exclusivamente para calcular e gerar os seus relatórios personalizados de Human Design, Astrologia e Numerologia. Não recolhemos dados sensíveis adicionais, como endereço de email ou informações financeiras, a menos que se forneçam voluntariamente para suporte ou registo de conta.\n\nFinalidades do Tratamento\nOs dados são tratados para:\n\nGerar relatórios precisos baseados nos inputs fornecidos;\n\nMelhorar a precisão dos cálculos astrológicos e de design humano;\n\nPermitir o armazenamento opcional de relatórios para acesso futuro (com o seu consentimento explícito).\n\nO tratamento é lícito com base no seu consentimento livre e informado, obtido no momento da submissão dos dados.\n\nPartilha de Dados\nNão partilhamos os seus dados pessoais com terceiros, exceto:\n\nPrestadores de serviços técnicos essenciais (ex.: servidores de cloud seguros na UE) sob acordos de processamento de dados que garantisent confidencialidade;\n\nQuando exigido por lei ou autoridades competentes.\n\nOs relatórios gerados são privados e não são vendidos ou usados para marketing.\n​\n\nArmazenamento e Segurança\nDados são armazenados em servidores seguros localizados na União Europeia, com medidas técnicas como encriptação (AES-256), pseudonimização e controlos de acesso. Retemos os dados apenas pelo tempo necessário para o serviço (geralmente até 30 dias após o último acesso, salvo consentimento para armazenamento prolongado). Procedemos à eliminação segura automática após esse período.\n\nOs Seus Direitos\nPode exercer os seus direitos RGPD a qualquer momento:\n\nAcesso aos dados;\n\nRectificação ou correção;\n\nApagamento (\"direito ao esquecimento\");\n\nOposição ao tratamento;\n\nLimitação do tratamento;\n\nPortabilidade dos dados.\n\nPara solicitar a eliminação da sua conta e de todos os dados associados, poderá fazê-lo através do seguinte link: https://humanmatch.app/delete-account ou enviando um email para support@humanmatch.app.\n\nConsentement e Alterações\nAo usar a app, você consente com esta política. Pode revogar o consentimento a qualquer momento, o que impedirá o acesso a relatórios existentes. Atualizaremos esta política conforme necessário, notificando os utilizadores via app.'**
  String get termsContent;

  /// No description provided for @processing.
  ///
  /// In pt, this message translates to:
  /// **'A processar...'**
  String get processing;

  /// No description provided for @acceptAndContinue.
  ///
  /// In pt, this message translates to:
  /// **'Aceito e desejo continuar'**
  String get acceptAndContinue;

  /// No description provided for @cancelAndExit.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar e sair'**
  String get cancelAndExit;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Aguarda...'**
  String get loading;

  /// No description provided for @createProfile.
  ///
  /// In pt, this message translates to:
  /// **'Criar perfil'**
  String get createProfile;

  /// No description provided for @editProfile.
  ///
  /// In pt, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @baseData.
  ///
  /// In pt, this message translates to:
  /// **'Dados do utilizador'**
  String get baseData;

  /// No description provided for @baseDataDesc.
  ///
  /// In pt, this message translates to:
  /// **'Isto permite calcular Human Design + ascendente.'**
  String get baseDataDesc;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo'**
  String get name;

  /// No description provided for @nameNumerologyInfo.
  ///
  /// In pt, this message translates to:
  /// **'Este campo será usado para determinar as variáveis da Numerologia. Não deves usar caracteres especiais ou acentuação.'**
  String get nameNumerologyInfo;

  /// No description provided for @country.
  ///
  /// In pt, this message translates to:
  /// **'País'**
  String get country;

  /// No description provided for @city.
  ///
  /// In pt, this message translates to:
  /// **'Cidade'**
  String get city;

  /// No description provided for @saveProfile.
  ///
  /// In pt, this message translates to:
  /// **'Guardar perfil'**
  String get saveProfile;

  /// No description provided for @birthDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get birthDate;

  /// No description provided for @birthPlace.
  ///
  /// In pt, this message translates to:
  /// **'Local de nascimento'**
  String get birthPlace;

  /// No description provided for @selectDate.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar data'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar hora'**
  String get selectTime;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @greeting.
  ///
  /// In pt, this message translates to:
  /// **'Olá {name}'**
  String greeting(String name);

  /// No description provided for @greetingEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Olá!'**
  String get greetingEmpty;

  /// No description provided for @profileSummaryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Resumo do Perfil'**
  String get profileSummaryTitle;

  /// No description provided for @profileSummaryDesc.
  ///
  /// In pt, this message translates to:
  /// **'O teu perfil é uma combinação única de Human Design, Astrologia e Numerologia. A Human Match ajuda-te a decifrar o teu \'ADN Cósmico\' para que possas compreender melhor a tua essência, os teus talentos naturais e como podes evoluir nos teus relacionamentos através do autoconhecimento.'**
  String get profileSummaryDesc;

  /// No description provided for @hdTitle.
  ///
  /// In pt, this message translates to:
  /// **'Human Design'**
  String get hdTitle;

  /// No description provided for @hdCalculating.
  ///
  /// In pt, this message translates to:
  /// **'Ainda a calcular Human Design...'**
  String get hdCalculating;

  /// No description provided for @astroTitle.
  ///
  /// In pt, this message translates to:
  /// **'Astrologia'**
  String get astroTitle;

  /// No description provided for @zodiacSign.
  ///
  /// In pt, this message translates to:
  /// **'Signo'**
  String get zodiacSign;

  /// No description provided for @ascendant.
  ///
  /// In pt, this message translates to:
  /// **'Ascendente'**
  String get ascendant;

  /// No description provided for @numTitle.
  ///
  /// In pt, this message translates to:
  /// **'Numerologia'**
  String get numTitle;

  /// No description provided for @lifePath.
  ///
  /// In pt, this message translates to:
  /// **'Caminho de Vida'**
  String get lifePath;

  /// No description provided for @expression.
  ///
  /// In pt, this message translates to:
  /// **'Expressão'**
  String get expression;

  /// No description provided for @soul.
  ///
  /// In pt, this message translates to:
  /// **'Alma'**
  String get soul;

  /// No description provided for @personality.
  ///
  /// In pt, this message translates to:
  /// **'Personalidade'**
  String get personality;

  /// No description provided for @chineseSignTitle.
  ///
  /// In pt, this message translates to:
  /// **'Signo Chinês'**
  String get chineseSignTitle;

  /// No description provided for @profileInsights.
  ///
  /// In pt, this message translates to:
  /// **'Insights de Perfil'**
  String get profileInsights;

  /// No description provided for @noInsights.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não tens insights gerados.'**
  String get noInsights;

  /// No description provided for @generateInsights.
  ///
  /// In pt, this message translates to:
  /// **'Gerar Insights (Anúncio)'**
  String get generateInsights;

  /// No description provided for @update.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get update;

  /// No description provided for @profilePillars.
  ///
  /// In pt, this message translates to:
  /// **'Pilares do teu Perfil'**
  String get profilePillars;

  /// No description provided for @dailyTip.
  ///
  /// In pt, this message translates to:
  /// **'Dica Diária'**
  String get dailyTip;

  /// No description provided for @getDailyTip.
  ///
  /// In pt, this message translates to:
  /// **'Obter dica diária'**
  String get getDailyTip;

  /// No description provided for @watchAdForTip.
  ///
  /// In pt, this message translates to:
  /// **'Vê o vídeo para obteres a tua dica diária'**
  String get watchAdForTip;

  /// No description provided for @essenceName.
  ///
  /// In pt, this message translates to:
  /// **'Essência'**
  String get essenceName;

  /// No description provided for @essenceCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} {count, plural, one{Essência} other{Essências}}'**
  String essenceCount(int count);

  /// No description provided for @getMoreEssence.
  ///
  /// In pt, this message translates to:
  /// **'Obter mais Essências'**
  String get getMoreEssence;

  /// No description provided for @unlockWithEssence.
  ///
  /// In pt, this message translates to:
  /// **'Desbloquear com {price} ✧'**
  String unlockWithEssence(int price);

  /// No description provided for @essenceAdsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Essências Gratuitas'**
  String get essenceAdsTitle;

  /// No description provided for @essenceAdsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vê um anúncio para ganhares 1 Essência. Limite de 3 anúncios a cada 8 horas.'**
  String get essenceAdsDesc;

  /// No description provided for @essenceWatchAd.
  ///
  /// In pt, this message translates to:
  /// **'Ver Anúncio (+1 ✧)'**
  String get essenceWatchAd;

  /// No description provided for @essenceAdLimit.
  ///
  /// In pt, this message translates to:
  /// **'Limite atingido. Disponível em {time}'**
  String essenceAdLimit(String time);

  /// No description provided for @essenceStoreTitle.
  ///
  /// In pt, this message translates to:
  /// **'Loja de Essências'**
  String get essenceStoreTitle;

  /// No description provided for @essenceStoreDesc.
  ///
  /// In pt, this message translates to:
  /// **'Adquire packs de Essências para desbloqueares conteúdo instantaneamente.'**
  String get essenceStoreDesc;

  /// No description provided for @essencePackStarter.
  ///
  /// In pt, this message translates to:
  /// **'Pack Iniciante'**
  String get essencePackStarter;

  /// No description provided for @essencePackStarterDesc.
  ///
  /// In pt, this message translates to:
  /// **'Ideal para os primeiros passos'**
  String get essencePackStarterDesc;

  /// No description provided for @essencePackCosmic.
  ///
  /// In pt, this message translates to:
  /// **'Pack Cósmico'**
  String get essencePackCosmic;

  /// No description provided for @essencePackCosmicDesc.
  ///
  /// In pt, this message translates to:
  /// **'O pack mais equilibrado'**
  String get essencePackCosmicDesc;

  /// No description provided for @essencePackInfinite.
  ///
  /// In pt, this message translates to:
  /// **'Pack Infinito'**
  String get essencePackInfinite;

  /// No description provided for @essencePackInfiniteDesc.
  ///
  /// In pt, this message translates to:
  /// **'Exploração sem limites'**
  String get essencePackInfiniteDesc;

  /// No description provided for @learnMore.
  ///
  /// In pt, this message translates to:
  /// **'Saber mais'**
  String get learnMore;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @support.
  ///
  /// In pt, this message translates to:
  /// **'Suporte'**
  String get support;

  /// No description provided for @errorFillEmailPassword.
  ///
  /// In pt, this message translates to:
  /// **'Preenche email e password.'**
  String get errorFillEmailPassword;

  /// No description provided for @errorAcceptTerms.
  ///
  /// In pt, this message translates to:
  /// **'Precisas de aceitar os Termos e Condições.'**
  String get errorAcceptTerms;

  /// No description provided for @resetEmailSent.
  ///
  /// In pt, this message translates to:
  /// **'Email enviado. (Vê spam também)'**
  String get resetEmailSent;

  /// No description provided for @resetEmailError.
  ///
  /// In pt, this message translates to:
  /// **'Escreve o email acima e tenta novamente.'**
  String get resetEmailError;

  /// No description provided for @errorUserNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Utilizador não encontrado.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In pt, this message translates to:
  /// **'Password incorreta.'**
  String get errorWrongPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email inválido.'**
  String get errorInvalidEmail;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In pt, this message translates to:
  /// **'Este email já está a ser usado.'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In pt, this message translates to:
  /// **'Password fraca (mín. 6 caracteres).'**
  String get errorWeakPassword;

  /// No description provided for @errorGeneral.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String errorGeneral(String error);

  /// No description provided for @errorFillProfile.
  ///
  /// In pt, this message translates to:
  /// **'Preenche nome, data, hora e cidade.'**
  String get errorFillProfile;

  /// No description provided for @errorSavingProfile.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao guardar/calculando: {error}'**
  String errorSavingProfile(String error);

  /// No description provided for @signAries.
  ///
  /// In pt, this message translates to:
  /// **'Carneiro'**
  String get signAries;

  /// No description provided for @signTaurus.
  ///
  /// In pt, this message translates to:
  /// **'Touro'**
  String get signTaurus;

  /// No description provided for @signGemini.
  ///
  /// In pt, this message translates to:
  /// **'Gémeos'**
  String get signGemini;

  /// No description provided for @signCancer.
  ///
  /// In pt, this message translates to:
  /// **'Caranguejo'**
  String get signCancer;

  /// No description provided for @signLeo.
  ///
  /// In pt, this message translates to:
  /// **'Leão'**
  String get signLeo;

  /// No description provided for @signVirgo.
  ///
  /// In pt, this message translates to:
  /// **'Virgem'**
  String get signVirgo;

  /// No description provided for @signLibra.
  ///
  /// In pt, this message translates to:
  /// **'Balança'**
  String get signLibra;

  /// No description provided for @signScorpio.
  ///
  /// In pt, this message translates to:
  /// **'Escorpião'**
  String get signScorpio;

  /// No description provided for @signSagittarius.
  ///
  /// In pt, this message translates to:
  /// **'Sagitário'**
  String get signSagittarius;

  /// No description provided for @signCapricorn.
  ///
  /// In pt, this message translates to:
  /// **'Capricórnio'**
  String get signCapricorn;

  /// No description provided for @signAquarius.
  ///
  /// In pt, this message translates to:
  /// **'Aquário'**
  String get signAquarius;

  /// No description provided for @signPisces.
  ///
  /// In pt, this message translates to:
  /// **'Peixes'**
  String get signPisces;

  /// No description provided for @hdType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get hdType;

  /// No description provided for @hdAuthority.
  ///
  /// In pt, this message translates to:
  /// **'Autoridade'**
  String get hdAuthority;

  /// No description provided for @hdStrategy.
  ///
  /// In pt, this message translates to:
  /// **'Estratégia'**
  String get hdStrategy;

  /// No description provided for @hdProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get hdProfile;

  /// No description provided for @hdSignature.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura'**
  String get hdSignature;

  /// No description provided for @hdNotSelf.
  ///
  /// In pt, this message translates to:
  /// **'Não-ser'**
  String get hdNotSelf;

  /// No description provided for @hdDefinition.
  ///
  /// In pt, this message translates to:
  /// **'Definição'**
  String get hdDefinition;

  /// No description provided for @hdIncarnationCross.
  ///
  /// In pt, this message translates to:
  /// **'Cruz de Encarnação'**
  String get hdIncarnationCross;

  /// No description provided for @hdEnergyCenters.
  ///
  /// In pt, this message translates to:
  /// **'Centros'**
  String get hdEnergyCenters;

  /// No description provided for @hdEnergyCentersChannels.
  ///
  /// In pt, this message translates to:
  /// **'Centros, canais e portas'**
  String get hdEnergyCentersChannels;

  /// No description provided for @hdDefinedCenters.
  ///
  /// In pt, this message translates to:
  /// **'Centros Definidos'**
  String get hdDefinedCenters;

  /// No description provided for @hdChannels.
  ///
  /// In pt, this message translates to:
  /// **'Canais'**
  String get hdChannels;

  /// No description provided for @hdNoData.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum dado disponível.'**
  String get hdNoData;

  /// No description provided for @hdAuthorityNotice.
  ///
  /// In pt, this message translates to:
  /// **'* {center} é o centro autoritário (Autoridade)'**
  String hdAuthorityNotice(String center);

  /// No description provided for @hdDesign.
  ///
  /// In pt, this message translates to:
  /// **'Design'**
  String get hdDesign;

  /// No description provided for @hdUnconscious.
  ///
  /// In pt, this message translates to:
  /// **'(Inconsciente)'**
  String get hdUnconscious;

  /// No description provided for @hdPlanetaryActivation.
  ///
  /// In pt, this message translates to:
  /// **'Ativação Planetária'**
  String get hdPlanetaryActivation;

  /// No description provided for @hdPlanets.
  ///
  /// In pt, this message translates to:
  /// **'Astros'**
  String get hdPlanets;

  /// No description provided for @hdPlanetSun.
  ///
  /// In pt, this message translates to:
  /// **'Sol'**
  String get hdPlanetSun;

  /// No description provided for @hdPlanetEarth.
  ///
  /// In pt, this message translates to:
  /// **'Terra'**
  String get hdPlanetEarth;

  /// No description provided for @hdPlanetMoon.
  ///
  /// In pt, this message translates to:
  /// **'Lua'**
  String get hdPlanetMoon;

  /// No description provided for @hdPlanetMercury.
  ///
  /// In pt, this message translates to:
  /// **'Mercúrio'**
  String get hdPlanetMercury;

  /// No description provided for @hdPlanetVenus.
  ///
  /// In pt, this message translates to:
  /// **'Vénus'**
  String get hdPlanetVenus;

  /// No description provided for @hdPlanetMars.
  ///
  /// In pt, this message translates to:
  /// **'Marte'**
  String get hdPlanetMars;

  /// No description provided for @hdPlanetJupiter.
  ///
  /// In pt, this message translates to:
  /// **'Júpiter'**
  String get hdPlanetJupiter;

  /// No description provided for @hdPlanetSaturn.
  ///
  /// In pt, this message translates to:
  /// **'Saturno'**
  String get hdPlanetSaturn;

  /// No description provided for @hdPlanetUranus.
  ///
  /// In pt, this message translates to:
  /// **'Urano'**
  String get hdPlanetUranus;

  /// No description provided for @hdPlanetNeptune.
  ///
  /// In pt, this message translates to:
  /// **'Neptuno'**
  String get hdPlanetNeptune;

  /// No description provided for @hdPlanetPluto.
  ///
  /// In pt, this message translates to:
  /// **'Plutão'**
  String get hdPlanetPluto;

  /// No description provided for @hdPersonality.
  ///
  /// In pt, this message translates to:
  /// **'Personalidade'**
  String get hdPersonality;

  /// No description provided for @hdConscious.
  ///
  /// In pt, this message translates to:
  /// **'(Consciente)'**
  String get hdConscious;

  /// No description provided for @hdGen.
  ///
  /// In pt, this message translates to:
  /// **'Gerador'**
  String get hdGen;

  /// No description provided for @hdMG.
  ///
  /// In pt, this message translates to:
  /// **'Gerador Manifestador'**
  String get hdMG;

  /// No description provided for @hdMan.
  ///
  /// In pt, this message translates to:
  /// **'Manifestador'**
  String get hdMan;

  /// No description provided for @hdProj.
  ///
  /// In pt, this message translates to:
  /// **'Projetor'**
  String get hdProj;

  /// No description provided for @hdRef.
  ///
  /// In pt, this message translates to:
  /// **'Refletor'**
  String get hdRef;

  /// No description provided for @hdAuthEmo.
  ///
  /// In pt, this message translates to:
  /// **'Emocional'**
  String get hdAuthEmo;

  /// No description provided for @hdAuthSac.
  ///
  /// In pt, this message translates to:
  /// **'Sacral'**
  String get hdAuthSac;

  /// No description provided for @hdAuthSpl.
  ///
  /// In pt, this message translates to:
  /// **'Esplénica'**
  String get hdAuthSpl;

  /// No description provided for @hdAuthEgo.
  ///
  /// In pt, this message translates to:
  /// **'Ego'**
  String get hdAuthEgo;

  /// No description provided for @hdAuthSelf.
  ///
  /// In pt, this message translates to:
  /// **'Auto-projetada'**
  String get hdAuthSelf;

  /// No description provided for @hdAuthMen.
  ///
  /// In pt, this message translates to:
  /// **'Mental'**
  String get hdAuthMen;

  /// No description provided for @hdAuthLun.
  ///
  /// In pt, this message translates to:
  /// **'Lunar'**
  String get hdAuthLun;

  /// No description provided for @hdStrInf.
  ///
  /// In pt, this message translates to:
  /// **'Informar'**
  String get hdStrInf;

  /// No description provided for @hdStrResp.
  ///
  /// In pt, this message translates to:
  /// **'Responder'**
  String get hdStrResp;

  /// No description provided for @hdStrRespInf.
  ///
  /// In pt, this message translates to:
  /// **'Responder e informar'**
  String get hdStrRespInf;

  /// No description provided for @hdStrInv.
  ///
  /// In pt, this message translates to:
  /// **'Esperar pelo convite'**
  String get hdStrInv;

  /// No description provided for @hdStrLun.
  ///
  /// In pt, this message translates to:
  /// **'Esperar ciclo lunar'**
  String get hdStrLun;

  /// No description provided for @hdSigSat.
  ///
  /// In pt, this message translates to:
  /// **'Satisfação'**
  String get hdSigSat;

  /// No description provided for @hdSigSuc.
  ///
  /// In pt, this message translates to:
  /// **'Sucesso'**
  String get hdSigSuc;

  /// No description provided for @hdSigPea.
  ///
  /// In pt, this message translates to:
  /// **'Paz'**
  String get hdSigPea;

  /// No description provided for @hdSigSur.
  ///
  /// In pt, this message translates to:
  /// **'Surpresa'**
  String get hdSigSur;

  /// No description provided for @hdNotFru.
  ///
  /// In pt, this message translates to:
  /// **'Frustração'**
  String get hdNotFru;

  /// No description provided for @hdNotBit.
  ///
  /// In pt, this message translates to:
  /// **'Amargura'**
  String get hdNotBit;

  /// No description provided for @hdNotAng.
  ///
  /// In pt, this message translates to:
  /// **'Raiva'**
  String get hdNotAng;

  /// No description provided for @hdNotDis.
  ///
  /// In pt, this message translates to:
  /// **'Desilusão'**
  String get hdNotDis;

  /// No description provided for @hdDefSin.
  ///
  /// In pt, this message translates to:
  /// **'Definição Única'**
  String get hdDefSin;

  /// No description provided for @hdDefSpl.
  ///
  /// In pt, this message translates to:
  /// **'Definição Partida'**
  String get hdDefSpl;

  /// No description provided for @hdDefTri.
  ///
  /// In pt, this message translates to:
  /// **'Definição Tripla'**
  String get hdDefTri;

  /// No description provided for @hdDefQua.
  ///
  /// In pt, this message translates to:
  /// **'Definição Quádrupla'**
  String get hdDefQua;

  /// No description provided for @hdCrossRight.
  ///
  /// In pt, this message translates to:
  /// **'Ângulo Direito'**
  String get hdCrossRight;

  /// No description provided for @hdCrossLeft.
  ///
  /// In pt, this message translates to:
  /// **'Ângulo Esquerdo'**
  String get hdCrossLeft;

  /// No description provided for @hdCrossJuxta.
  ///
  /// In pt, this message translates to:
  /// **'Justaposição'**
  String get hdCrossJuxta;

  /// No description provided for @hdCrossOf.
  ///
  /// In pt, this message translates to:
  /// **'Cruz de'**
  String get hdCrossOf;

  /// No description provided for @hdCenterHead.
  ///
  /// In pt, this message translates to:
  /// **'Cabeça'**
  String get hdCenterHead;

  /// No description provided for @hdCenterAjna.
  ///
  /// In pt, this message translates to:
  /// **'Ajna'**
  String get hdCenterAjna;

  /// No description provided for @hdCenterThroat.
  ///
  /// In pt, this message translates to:
  /// **'Garganta'**
  String get hdCenterThroat;

  /// No description provided for @hdCenterG.
  ///
  /// In pt, this message translates to:
  /// **'Centro G'**
  String get hdCenterG;

  /// No description provided for @hdCenterEgo.
  ///
  /// In pt, this message translates to:
  /// **'Coração (Ego)'**
  String get hdCenterEgo;

  /// No description provided for @hdCenterSpleen.
  ///
  /// In pt, this message translates to:
  /// **'Baço'**
  String get hdCenterSpleen;

  /// No description provided for @hdCenterSolar.
  ///
  /// In pt, this message translates to:
  /// **'Plexo Solar'**
  String get hdCenterSolar;

  /// No description provided for @hdCenterSacral.
  ///
  /// In pt, this message translates to:
  /// **'Sacral'**
  String get hdCenterSacral;

  /// No description provided for @hdCenterRoot.
  ///
  /// In pt, this message translates to:
  /// **'Raiz'**
  String get hdCenterRoot;

  /// No description provided for @hdCenterNameHead.
  ///
  /// In pt, this message translates to:
  /// **'Cabeça'**
  String get hdCenterNameHead;

  /// No description provided for @hdCenterNameAjna.
  ///
  /// In pt, this message translates to:
  /// **'Ajna'**
  String get hdCenterNameAjna;

  /// No description provided for @hdCenterNameThroat.
  ///
  /// In pt, this message translates to:
  /// **'Garganta'**
  String get hdCenterNameThroat;

  /// No description provided for @hdCenterNameG.
  ///
  /// In pt, this message translates to:
  /// **'Centro G'**
  String get hdCenterNameG;

  /// No description provided for @hdCenterNameHeart.
  ///
  /// In pt, this message translates to:
  /// **'Coração'**
  String get hdCenterNameHeart;

  /// No description provided for @hdCenterNameSpleen.
  ///
  /// In pt, this message translates to:
  /// **'Baço'**
  String get hdCenterNameSpleen;

  /// No description provided for @hdCenterNameSolar.
  ///
  /// In pt, this message translates to:
  /// **'Plexo Solar'**
  String get hdCenterNameSolar;

  /// No description provided for @hdCenterNameSacral.
  ///
  /// In pt, this message translates to:
  /// **'Sacral'**
  String get hdCenterNameSacral;

  /// No description provided for @hdCenterNameRoot.
  ///
  /// In pt, this message translates to:
  /// **'Raiz'**
  String get hdCenterNameRoot;

  /// No description provided for @hdTypeDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'O Tipo define a forma como a tua energia interage com o mundo.'**
  String get hdTypeDefDesc;

  /// No description provided for @hdAuthorityDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A tua Autoridade é o teu sistema interno de tomada de decisão.'**
  String get hdAuthorityDefDesc;

  /// No description provided for @hdStrategyDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A Estratégia é o método para navegar na vida com menos resistência.'**
  String get hdStrategyDefDesc;

  /// No description provided for @hdProfileDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'O Perfil descreve o teu papel e a forma como aprendes e evoluis.'**
  String get hdProfileDefDesc;

  /// No description provided for @hdSignatureDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A Assinatura é a sensação de estar alinhado com o teu design.'**
  String get hdSignatureDefDesc;

  /// No description provided for @hdNotSelfDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'O Não-ser é o sinal de que te estás a desviar da tua verdade.'**
  String get hdNotSelfDefDesc;

  /// No description provided for @hdDefinitionDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A Definição mostra como a energia flui entre os teus centros.'**
  String get hdDefinitionDefDesc;

  /// No description provided for @hdIncarnationCrossDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A tua Cruz de Encarnação representa o teu propósito de vida.'**
  String get hdIncarnationCrossDefDesc;

  /// No description provided for @hdValTypeGenerator.
  ///
  /// In pt, this message translates to:
  /// **'Como Gerador, a tua energia é desenhada para responder ao que a vida te traz, em vez de iniciares.'**
  String get hdValTypeGenerator;

  /// No description provided for @hdValTypeManifestingGenerator.
  ///
  /// In pt, this message translates to:
  /// **'Tens a rapidez do Manifestador e a sustentabilidade do Gerador. Responde antes de agir.'**
  String get hdValTypeManifestingGenerator;

  /// No description provided for @hdValTypeManifestor.
  ///
  /// In pt, this message translates to:
  /// **'Vieste para iniciar e impactar. Informa os outros antes de agires para reduzir a resistência.'**
  String get hdValTypeManifestor;

  /// No description provided for @hdValTypeProjector.
  ///
  /// In pt, this message translates to:
  /// **'Estás aqui para guiar os outros. O teu sucesso vem ao esperares pelo reconhecimento e convite.'**
  String get hdValTypeProjector;

  /// No description provided for @hdValTypeReflector.
  ///
  /// In pt, this message translates to:
  /// **'És um espelho da comunidade. Espera um ciclo lunar completo antes de tomares decisões importantes.'**
  String get hdValTypeReflector;

  /// No description provided for @hdValAuthEmotional.
  ///
  /// In pt, this message translates to:
  /// **'A claridade não acontece no agora. Espera que a tua onda emocional estabilize antes de decidires.'**
  String get hdValAuthEmotional;

  /// No description provided for @hdValAuthSacral.
  ///
  /// In pt, this message translates to:
  /// **'Confia na tua resposta visceral imediata (sons sacrais ou inclinação física) no momento presente.'**
  String get hdValAuthSacral;

  /// No description provided for @hdValAuthSplenic.
  ///
  /// In pt, this message translates to:
  /// **'Confia na tua intuição instintiva e espontânea que te avisa sobre o que é seguro e saudável.'**
  String get hdValAuthSplenic;

  /// No description provided for @hdValAuthEgo.
  ///
  /// In pt, this message translates to:
  /// **'A tua vontade é o teu guia. O que é que tu realmente queres e tens vontade de fazer?'**
  String get hdValAuthEgo;

  /// No description provided for @hdValAuthSelfProjected.
  ///
  /// In pt, this message translates to:
  /// **'A tua verdade sai pela tua boca. Ouve o que dizes quando falas sem pensar sobre o teu futuro.'**
  String get hdValAuthSelfProjected;

  /// No description provided for @hdValAuthMental.
  ///
  /// In pt, this message translates to:
  /// **'Precisas de usar os outros como caixa de ressonância para ouvires a tua própria verdade ao falar.'**
  String get hdValAuthMental;

  /// No description provided for @hdValAuthLunar.
  ///
  /// In pt, this message translates to:
  /// **'Como Reflector, a tua decisão amadurece ao longo de 28 dias em sintonia com o ciclo da Lua.'**
  String get hdValAuthLunar;

  /// No description provided for @hdValStrRespond.
  ///
  /// In pt, this message translates to:
  /// **'A tua melhor forma de agir é responder às oportunidades que aparecem, em vez de tentar forçar coisas novas.'**
  String get hdValStrRespond;

  /// No description provided for @hdValStrInform.
  ///
  /// In pt, this message translates to:
  /// **'Para reduzir a resistência dos outros, informa as pessoas afetadas pelas tuas ações antes de as tomares.'**
  String get hdValStrInform;

  /// No description provided for @hdValStrRespondInform.
  ///
  /// In pt, this message translates to:
  /// **'Como MG, deves responder primeiro e depois informar quem te rodeia antes de entrares em ação rápida.'**
  String get hdValStrRespondInform;

  /// No description provided for @hdValStrInvite.
  ///
  /// In pt, this message translates to:
  /// **'Deves esperar por reconhecimento formal e um convite antes de partilhares a tua sabedoria ou orientação.'**
  String get hdValStrInvite;

  /// No description provided for @hdValStrLunar.
  ///
  /// In pt, this message translates to:
  /// **'Decisões importantes devem ser tomadas apenas após um ciclo lunar completo (aproximadamente 28 dias).'**
  String get hdValStrLunar;

  /// No description provided for @hdValSigSatisfaction.
  ///
  /// In pt, this message translates to:
  /// **'Sentes satisfação quando usas a tua energia de forma produtiva em algo que te dá prazer.'**
  String get hdValSigSatisfaction;

  /// No description provided for @hdValSigSuccess.
  ///
  /// In pt, this message translates to:
  /// **'O sucesso para ti é ser reconhecido pelo que és e ver os outros prosperarem com a tua guia.'**
  String get hdValSigSuccess;

  /// No description provided for @hdValSigPeace.
  ///
  /// In pt, this message translates to:
  /// **'Sentirás paz quando puderes agir livremente e sem resistência após informares os outros.'**
  String get hdValSigPeace;

  /// No description provided for @hdValSigSurprise.
  ///
  /// In pt, this message translates to:
  /// **'A surpresa é o sinal de que estás a ver a vida com olhos novos, como um espelho puro do ambiente.'**
  String get hdValSigSurprise;

  /// No description provided for @hdValNotFrustration.
  ///
  /// In pt, this message translates to:
  /// **'A frustração surge quando tentas iniciar coisas sem esperar pela resposta certa.'**
  String get hdValNotFrustration;

  /// No description provided for @hdValNotBitterness.
  ///
  /// In pt, this message translates to:
  /// **'A amargura aparece quando te esforças demais sem ser convidado ou reconhecido.'**
  String get hdValNotBitterness;

  /// No description provided for @hdValNotAnger.
  ///
  /// In pt, this message translates to:
  /// **'A raiva é o resultado de sentires resistência por não informares os outros sobre as tuas intenções.'**
  String get hdValNotAnger;

  /// No description provided for @hdValNotDisappointment.
  ///
  /// In pt, this message translates to:
  /// **'A desilusão ocorre quando não estás num ambiente saudável ou tentas decidir depressa demais.'**
  String get hdValNotDisappointment;

  /// No description provided for @hdValProf13.
  ///
  /// In pt, this message translates to:
  /// **'Investigador/Mártir: Aprende através da experimentação, fundações sólidas e profundidade.'**
  String get hdValProf13;

  /// No description provided for @hdValProf14.
  ///
  /// In pt, this message translates to:
  /// **'Investigador/Oportunista: Influencia a sua rede próxima partilhando o seu estudo profundo.'**
  String get hdValProf14;

  /// No description provided for @hdValProf24.
  ///
  /// In pt, this message translates to:
  /// **'Eremita/Oportunista: Um talento natural que precisa de tempo sozinho, mas que florece na sua rede.'**
  String get hdValProf24;

  /// No description provided for @hdValProf25.
  ///
  /// In pt, this message translates to:
  /// **'Eremita/Herege: Talento natural projetado para ser um guia ou salvador para os outros.'**
  String get hdValProf25;

  /// No description provided for @hdValProf35.
  ///
  /// In pt, this message translates to:
  /// **'Mártir/Herege: Aprende por tentativa e erro e partilha o que funciona para desafiar o status quo.'**
  String get hdValProf35;

  /// No description provided for @hdValProf36.
  ///
  /// In pt, this message translates to:
  /// **'Mártir/Observador: Experimenta na primeira fase da vida para se tornar um guia sábio e objetivo.'**
  String get hdValProf36;

  /// No description provided for @hdValProf46.
  ///
  /// In pt, this message translates to:
  /// **'Oportunista/Observador: Influencia através da rede e objetividade, tornando-se um modelo de papel.'**
  String get hdValProf46;

  /// No description provided for @hdValProf41.
  ///
  /// In pt, this message translates to:
  /// **'Oportunista/Investigador: Segue um caminho fixo e único com base em fundações muito sólidas.'**
  String get hdValProf41;

  /// No description provided for @hdValProf51.
  ///
  /// In pt, this message translates to:
  /// **'Herege/Investigador: O mestre que resolve problemas práticos através de estudo e autoridade.'**
  String get hdValProf51;

  /// No description provided for @hdValProf52.
  ///
  /// In pt, this message translates to:
  /// **'Herege/Eremita: Motivado pela autorreflexão, mas visto pelos outros como um guia natural.'**
  String get hdValProf52;

  /// No description provided for @hdValProf62.
  ///
  /// In pt, this message translates to:
  /// **'Observador/Eremita: Modelo de papel que vive with objetividade e desapego após uma vida de experiência.'**
  String get hdValProf62;

  /// No description provided for @hdValProf63.
  ///
  /// In pt, this message translates to:
  /// **'Observador/Mártir: Modelo de papel que continua a evoluir através da experimentação constante.'**
  String get hdValProf63;

  /// No description provided for @hdCenterHeadDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Processas pensamentos de forma constante e inspiras-te nas tuas próprias ideias.'**
  String get hdCenterHeadDefDesc;

  /// No description provided for @hdCenterHeadUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'És aberto a novas ideias e tens flexibilidade para ver diferentes perspetivas.'**
  String get hdCenterHeadUndDesc;

  /// No description provided for @hdCenterAjnaDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Tens uma forma fixa e organizada de pensar e processar informação.'**
  String get hdCenterAjnaDefDesc;

  /// No description provided for @hdCenterAjnaUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Podes adaptar a tua forma de pensar a qualquer situação sem opiniões rígidas.'**
  String get hdCenterAjnaUndDesc;

  /// No description provided for @hdCenterThroatDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Comunicação e ação constantes e fiáveis através da tua velocidade e feitos.'**
  String get hdCenterThroatDefDesc;

  /// No description provided for @hdCenterThroatUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Comunicação variável, dependendo do ambiente e de quem te rodeia.'**
  String get hdCenterThroatUndDesc;

  /// No description provided for @hdCenterGDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Tens um sentido fixo e claro de quem és, do teu propósito e direção na vida.'**
  String get hdCenterGDefDesc;

  /// No description provided for @hdCenterGUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'A tua identidade é fluida e podes adaptar-te e encontrar-te em diversos ambientes.'**
  String get hdCenterGUndDesc;

  /// No description provided for @hdCenterEgoDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Tens força de vontade e um compromisso natural para alcançar os teus objetivos.'**
  String get hdCenterEgoDefDesc;

  /// No description provided for @hdCenterEgoUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Não precisas de provar nada a ninguém; a tua vontade é flexível.'**
  String get hdCenterEgoUndDesc;

  /// No description provided for @hdCenterSpleenDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Intuição aguçada e instinto de sobrevivência forte e constante.'**
  String get hdCenterSpleenDefDesc;

  /// No description provided for @hdCenterSpleenUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Captação da saúde e bem-estar dos outros de forma sensível e intuitiva.'**
  String get hdCenterSpleenUndDesc;

  /// No description provided for @hdCenterSolarDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vives uma onda emocional cíclica e profunda; a claridade vem com o tempo.'**
  String get hdCenterSolarDefDesc;

  /// No description provided for @hdCenterSolarUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'És sensível às emoções dos outros, captando-as e amplificando-as.'**
  String get hdCenterSolarUndDesc;

  /// No description provided for @hdCenterSacralDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Fonte inesgotável de energia vital e persistência para o trabalho que amas.'**
  String get hdCenterSacralDefDesc;

  /// No description provided for @hdCenterSacralUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Precisas de descansar quando a energia acaba; não tens um motor vital constante.'**
  String get hdCenterSacralUndDesc;

  /// No description provided for @hdCenterRootDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Lidas bem com a pressão e tens um motor interno para impulsionar a ação.'**
  String get hdCenterRootDefDesc;

  /// No description provided for @hdCenterRootUndDesc.
  ///
  /// In pt, this message translates to:
  /// **'Podes sentir a pressão externa mas preferes agir ao teu próprio ritmo.'**
  String get hdCenterRootUndDesc;

  /// No description provided for @hdDefined.
  ///
  /// In pt, this message translates to:
  /// **'Definido'**
  String get hdDefined;

  /// No description provided for @hdUndefined.
  ///
  /// In pt, this message translates to:
  /// **'Indefinido'**
  String get hdUndefined;

  /// No description provided for @hdGates.
  ///
  /// In pt, this message translates to:
  /// **'Portas'**
  String get hdGates;

  /// No description provided for @hdGatesUser.
  ///
  /// In pt, this message translates to:
  /// **'Portas do utilizador'**
  String get hdGatesUser;

  /// No description provided for @hdChannelsUser.
  ///
  /// In pt, this message translates to:
  /// **'Canais do utilizador'**
  String get hdChannelsUser;

  /// No description provided for @legalInfo.
  ///
  /// In pt, this message translates to:
  /// **'Informações Legais'**
  String get legalInfo;

  /// No description provided for @deleteAccountData.
  ///
  /// In pt, this message translates to:
  /// **'Eliminação de Conta e Dados'**
  String get deleteAccountData;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In pt, this message translates to:
  /// **'Verifica o teu Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSent.
  ///
  /// In pt, this message translates to:
  /// **'Enviámos um email de confirmação para {email}. Por favor, verifica a tua caixa de entrada (e pasta de spam).'**
  String verifyEmailSent(String email);

  /// No description provided for @checkVerification.
  ///
  /// In pt, this message translates to:
  /// **'Já verifiquei'**
  String get checkVerification;

  /// No description provided for @resendVerification.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar email'**
  String get resendVerification;

  /// No description provided for @verificationResent.
  ///
  /// In pt, this message translates to:
  /// **'Email de verificação reenviado.'**
  String get verificationResent;

  /// No description provided for @orDivider.
  ///
  /// In pt, this message translates to:
  /// **'OU'**
  String get orDivider;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Este email já está registado. Tenta fazer login em vez de criar conta.'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'Credenciais incorretas ou conta inexistente.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUserDisabled.
  ///
  /// In pt, this message translates to:
  /// **'Conta desativada.'**
  String get errorUserDisabled;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Temporariamente bloqueado por excesso de tentativas.'**
  String get errorTooManyRequests;

  /// No description provided for @errorAccountExistsGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Já existe uma conta com este email associada ao Google. Usa \"Continuar com Google\".'**
  String get errorAccountExistsGoogle;

  /// No description provided for @errorUnexpected.
  ///
  /// In pt, this message translates to:
  /// **'Erro inesperado: {error}'**
  String errorUnexpected(Object error);

  /// No description provided for @errorGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Erro Google: {error}'**
  String errorGoogle(Object error);

  /// No description provided for @errorResetPassword.
  ///
  /// In pt, this message translates to:
  /// **'Erro no reset: {error}'**
  String errorResetPassword(Object error);

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @authError.
  ///
  /// In pt, this message translates to:
  /// **'Erro de Autenticação: {error}'**
  String authError(Object error);

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// No description provided for @loadProfileError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perfil: {error}'**
  String loadProfileError(String error);

  /// No description provided for @logoutAndTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Sair e Tentar Novamente'**
  String get logoutAndTryAgain;

  /// No description provided for @astroMoonSign.
  ///
  /// In pt, this message translates to:
  /// **'Signo Lunar'**
  String get astroMoonSign;

  /// No description provided for @astroMercurySign.
  ///
  /// In pt, this message translates to:
  /// **'Mercúrio'**
  String get astroMercurySign;

  /// No description provided for @astroVenusSign.
  ///
  /// In pt, this message translates to:
  /// **'Vénus'**
  String get astroVenusSign;

  /// No description provided for @astroMarsSign.
  ///
  /// In pt, this message translates to:
  /// **'Marte'**
  String get astroMarsSign;

  /// No description provided for @astroMC.
  ///
  /// In pt, this message translates to:
  /// **'Meio do Céu (MC)'**
  String get astroMC;

  /// No description provided for @astroNorthNode.
  ///
  /// In pt, this message translates to:
  /// **'Nodo Norte'**
  String get astroNorthNode;

  /// No description provided for @astroSouthNode.
  ///
  /// In pt, this message translates to:
  /// **'Nodo Sul'**
  String get astroSouthNode;

  /// No description provided for @astroHouses.
  ///
  /// In pt, this message translates to:
  /// **'Casas Astrológicas'**
  String get astroHouses;

  /// No description provided for @astroHouseN.
  ///
  /// In pt, this message translates to:
  /// **'Casa {n}'**
  String astroHouseN(int n);

  /// No description provided for @astroAspects.
  ///
  /// In pt, this message translates to:
  /// **'Aspetos Astrológicos'**
  String get astroAspects;

  /// No description provided for @astroBig3.
  ///
  /// In pt, this message translates to:
  /// **'🌟 Big 3'**
  String get astroBig3;

  /// No description provided for @astroPersonalPlanets.
  ///
  /// In pt, this message translates to:
  /// **'🪐 Planetas Pessoais'**
  String get astroPersonalPlanets;

  /// No description provided for @astroSocialGenerationalPlanets.
  ///
  /// In pt, this message translates to:
  /// **'🪐 Planetas Sociais e Geracionais'**
  String get astroSocialGenerationalPlanets;

  /// No description provided for @astroMCNodes.
  ///
  /// In pt, this message translates to:
  /// **'🎯 MC e Nodos Lunares'**
  String get astroMCNodes;

  /// No description provided for @hdIndicators.
  ///
  /// In pt, this message translates to:
  /// **'Principais Indicadores'**
  String get hdIndicators;

  /// No description provided for @hdBodygraph.
  ///
  /// In pt, this message translates to:
  /// **'Bodygraph'**
  String get hdBodygraph;

  /// No description provided for @astroSunDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'O Sol representa a tua essência, a tua identidade central, o teu ego e como brilhas no mundo. É o núcleo da tua personalidade.'**
  String get astroSunDefDesc;

  /// No description provided for @astroMoonDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'A Lua rege as tuas emoções, o teu mundo interior, as tuas necessidades subconscientes e a forma como te sentes seguro e nutrido.'**
  String get astroMoonDefDesc;

  /// No description provided for @astroAscendantDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'O Ascendente é a tua máscara social, a primeira impressão que causas nos outros e a forma como inicias novas etapas na vida.'**
  String get astroAscendantDefDesc;

  /// No description provided for @astroMercuryDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Mercúrio rege a tua mente, a tua forma de comunicar, processar informação, a tua curiosidade intelectual e a aprendizagem.'**
  String get astroMercuryDefDesc;

  /// No description provided for @astroVenusDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vénus representa a forma como amas, o que valorizas, a tua estética e a forma como te relacionas, dás valor e atrais harmonia.'**
  String get astroVenusDefDesc;

  /// No description provided for @astroMarsDefDesc.
  ///
  /// In pt, this message translates to:
  /// **'Marte simboliza a tua ação, o teu impulso, a tua coragem e a forma como persegues os teus desejos e lidas com desafios e conflitos.'**
  String get astroMarsDefDesc;

  /// No description provided for @astroValSignAries.
  ///
  /// In pt, this message translates to:
  /// **'Energia pioneira, corajosa e cheia de iniciativa. Gosta de liderar e assumir novos desafios.'**
  String get astroValSignAries;

  /// No description provided for @astroValSignTaurus.
  ///
  /// In pt, this message translates to:
  /// **'Foco na estabilidade, prazer sensorial e persistência. Valoriza a segurança e o conforto material.'**
  String get astroValSignTaurus;

  /// No description provided for @astroValSignGemini.
  ///
  /// In pt, this message translates to:
  /// **'Curiosidade insaciável, comunicação versátil e agilidade mental. Adora trocar ideias e aprender.'**
  String get astroValSignGemini;

  /// No description provided for @astroValSignCancer.
  ///
  /// In pt, this message translates to:
  /// **'Sensibilidade profunda, nutrição emocional e uma forte ligação às raízes e à família.'**
  String get astroValSignCancer;

  /// No description provided for @astroValSignLeo.
  ///
  /// In pt, this message translates to:
  /// **'Expressão criativa, confiança, calorosidade e brilho pessoal. Procura reconhecimento e autenticidade.'**
  String get astroValSignLeo;

  /// No description provided for @astroValSignVirgo.
  ///
  /// In pt, this message translates to:
  /// **'Análise detalhada, busca pela perfeição, organização e desejo de ser útil e prático.'**
  String get astroValSignVirgo;

  /// No description provided for @astroValSignLibra.
  ///
  /// In pt, this message translates to:
  /// **'Equilíbrio, harmonia nos relacionamentos, diplomacia e um forte sentido de estética e justiça.'**
  String get astroValSignLibra;

  /// No description provided for @astroValSignScorpio.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade profunda, paixão, transformação e um poderoso magnetismo emocional.'**
  String get astroValSignScorpio;

  /// No description provided for @astroValSignSagittarius.
  ///
  /// In pt, this message translates to:
  /// **'Expansão, busca por significado, otimismo e um amor pela liberdade e aventura intelectual.'**
  String get astroValSignSagittarius;

  /// No description provided for @astroValSignCapricorn.
  ///
  /// In pt, this message translates to:
  /// **'Responsabilidade, ambição, disciplina e uma abordagem estruturada para alcançar o sucesso.'**
  String get astroValSignCapricorn;

  /// No description provided for @astroValSignAquarius.
  ///
  /// In pt, this message translates to:
  /// **'Originalidade, visão humanitária, independência e pensamento inovador e progressista.'**
  String get astroValSignAquarius;

  /// No description provided for @astroValSignPisces.
  ///
  /// In pt, this message translates to:
  /// **'Empatia vasta, intuição apurada, imaginação e uma forte ligação ao mundo espiritual e emocional.'**
  String get astroValSignPisces;

  /// No description provided for @onlyMobile.
  ///
  /// In pt, this message translates to:
  /// **'Apenas disponível em dispositivos móveis.'**
  String get onlyMobile;

  /// No description provided for @downloadApp.
  ///
  /// In pt, this message translates to:
  /// **'Descarrega a app para acederes a esta funcionalidade:'**
  String get downloadApp;

  /// No description provided for @menuCosmicDNA.
  ///
  /// In pt, this message translates to:
  /// **'ADN CÓSMICO'**
  String get menuCosmicDNA;

  /// No description provided for @menuHumanDesign.
  ///
  /// In pt, this message translates to:
  /// **'Human Design'**
  String get menuHumanDesign;

  /// No description provided for @menuAstrology.
  ///
  /// In pt, this message translates to:
  /// **'Astrologia'**
  String get menuAstrology;

  /// No description provided for @menuNumerology.
  ///
  /// In pt, this message translates to:
  /// **'Numerologia'**
  String get menuNumerology;

  /// No description provided for @menuChineseSign.
  ///
  /// In pt, this message translates to:
  /// **'Signo Chinês'**
  String get menuChineseSign;

  /// No description provided for @menuBondConnections.
  ///
  /// In pt, this message translates to:
  /// **'BOND CONNECTIONS'**
  String get menuBondConnections;

  /// No description provided for @menuFriendship.
  ///
  /// In pt, this message translates to:
  /// **'Amizade'**
  String get menuFriendship;

  /// No description provided for @menuCasualMeetings.
  ///
  /// In pt, this message translates to:
  /// **'Encontros casuais'**
  String get menuCasualMeetings;

  /// No description provided for @menuPartnerForLife.
  ///
  /// In pt, this message translates to:
  /// **'Parceiro para a vida'**
  String get menuPartnerForLife;

  /// No description provided for @menuRelateBetter.
  ///
  /// In pt, this message translates to:
  /// **'RELACIONA-TE MELHOR'**
  String get menuRelateBetter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
