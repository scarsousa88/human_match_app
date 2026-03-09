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
    Locale('pt'),
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
  /// **'Política de Privacidade - Human Match\n\nEsta Política de Privacidade descreve como a Human Match, uma aplicação móvel que gera relatórios personalizados de Human Design, Astrologia e Numerologia com base no nome completo, data e local de nascimento dos utilizadores, recolhe, utiliza e protege os seus dados pessoais. Estamos comprometidos com a proteção da sua privacidade em conformidade com o Regulamento Geral de Proteção de Dados (RGPD) da União Europeia e legislação aplicável em Portugal.\n\nDados Recolhidos\nRecolhemos apenas os dados estritamente necessários para fornecer o serviço:\n\nNome completo;\n\nData de nascimento;\n\nLocal de nascimento.\n\nEstes dados são usados exclusivamente para calcular e gerar os seus relatórios personalizados de Human Design, Astrologia e Numerologia. Não recolhemos dados sensíveis adicionais, como endereço de email ou informações financeiras, a menos que sejam voluntariamente fornecidos para suporte ou registo de conta.\n\nFinalidades do Tratamento\nOs dados são tratados para:\n\nGerar relatórios precisos baseados nos inputs fornecidos;\n\nMelhorar a precisão dos cálculos astrológicos e de design humano;\n\nPermitir o armazenamento opcional de relatórios para acesso futuro (com o seu consentimento explícito).\n\nO tratamento é lícito com base no seu consentimento livre e informado, obtido no momento da submissão dos dados.\n\nPartilha de Dados\nNão partilhamos os seus dados pessoais com terceiros, exceto:\n\nPrestadores de serviços técnicos essenciais (ex.: servidores de cloud seguros na UE) sob acordos de processamento de dados que garantem confidencialidade;\n\nQuando exigido por lei ou autoridades competentes.\n\nOs relatórios gerados são privados e não são vendidos ou usados para marketing.\n​\n\nArmazenamento e Segurança\nOs dados são armazenados em servidores seguros localizados na União Europeia, com medidas técnicas como encriptação (AES-256), pseudonimização e controlos de acesso. Retemos os dados apenas pelo tempo necessário para o serviço (geralmente até 30 dias após o último acesso, salvo consentimento para armazenamento prolongado). Procedemos à eliminação segura automática após esse período.\n\nOs Seus Direitos\nPode exercer os seus direitos RGPD a qualquer momento:\n\nAcesso aos dados;\n\nRectificação ou correção;\n\nApagamento (\"direito ao esquecimento\");\n\nOposição ao tratamento;\n\nLimitação do tratamento;\n\nPortabilidade dos dados.\n\nPara solicitar a eliminação da sua conta e de todos os dados associados, poderá fazê-lo através do seguinte link: https://humanmatch.app/delete-account ou enviando um email para support@humanmatch.app.\n\nConsentimento e Alterações\nAo usar a app, você consente com esta política. Pode revogar o consentimento a qualquer momento, o que impedirá o acesso a relatórios existentes. Atualizaremos esta política conforme necessário, notificando os utilizadores via app.'**
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
  /// **'Erro ao guardar/calcular: {error}'**
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
  /// **'Encarnação'**
  String get hdIncarnationCross;

  /// No description provided for @hdEnergyCenters.
  ///
  /// In pt, this message translates to:
  /// **'Centros energéticos'**
  String get hdEnergyCenters;

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

  /// No description provided for @hdPlanets.
  ///
  /// In pt, this message translates to:
  /// **'Astros'**
  String get hdPlanets;

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

  /// No description provided for @hdStrInf.
  ///
  /// In pt, this message translates to:
  /// **'Informar'**
  String get hdStrInf;

  /// No description provided for @hdStrResp.
  ///
  /// In pt, this message translates to:
  /// **'Esperar para responder'**
  String get hdStrResp;

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
  /// **'Coração'**
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
  /// **'Este email já está registado. Tente fazer LOGIN em vez de criar conta.'**
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
  /// **'Bloqueado temporariamente por excesso de tentativas.'**
  String get errorTooManyRequests;

  /// No description provided for @errorAccountExistsGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Já existe uma conta com este email vinculada ao Google. Use \"Continuar com Google\".'**
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
  /// **'Erro ao resetar: {error}'**
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
  String loadProfileError(Object error);

  /// No description provided for @logoutAndTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Sair e Tentar Novamente'**
  String get logoutAndTryAgain;
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
    'that was used.',
  );
}
