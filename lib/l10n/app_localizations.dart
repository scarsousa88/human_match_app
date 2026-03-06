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
  /// **'Bem-vindo ao Human Match.\n\n1. Proteção de Dados: Ao utilizar esta aplicação, concorda com o processamento dos seus dados de nascimento (data, hora e local) para o cálculo do seu perfil de Human Design, Astrologia e Numerologia.\n\n2. Inteligência Artificial: Os insights e dicas gerados são produzidos por modelos de IA e devem ser interpretados como sugestões de autoconhecimento, não como aconselhamento profissional ou médico.\n\n3. Anúncios: A aplicação utiliza anúncios premiados para desbloquear conteúdos gratuitos. Dados anónimos de publicidade podem ser processados pela Google AdMob.\n\n4. Privacidade: Não partilhamos os seus dados pessoais com terceiros. Pode apagar a sua conta a qualquer momento nas definições.\n\nAo aceitar, confirma que tem mais de 18 anos ou autorização parental.'**
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

  /// No description provided for @baseData.
  ///
  /// In pt, this message translates to:
  /// **'Dados base'**
  String get baseData;

  /// No description provided for @baseDataDesc.
  ///
  /// In pt, this message translates to:
  /// **'Isto permite calcular Human Design + ascendente.'**
  String get baseDataDesc;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

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
  /// **'Obter dica diária (Anúncio)'**
  String get getDailyTip;

  /// No description provided for @watchAdForTip.
  ///
  /// In pt, this message translates to:
  /// **'Vê o anúncio para obteres a tua dica diária'**
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
