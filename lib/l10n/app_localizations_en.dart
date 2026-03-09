// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Human Match';

  @override
  String get tabProfile => 'My Profile';

  @override
  String get tabCommunity => 'Community';

  @override
  String get tabCompare => 'Compare';

  @override
  String get welcomeMessage => 'Know yourself, relate better!';

  @override
  String get soonMessage => 'Soon';

  @override
  String get communitySoon => 'Explore nearby and compatible profiles';

  @override
  String get compareSoon => 'Compare profiles manually';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Create account';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get noAccount => 'No account? Register';

  @override
  String get hasAccount => 'Already have an account? Login';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get acceptTerms => 'I accept the Terms and Conditions';

  @override
  String get termsTitle => 'Terms and Conditions';

  @override
  String get termsContent =>
      'Privacy Policy - Human Match\n\nThis Privacy Policy describes how Human Match, a mobile application that generates personalized Human Design, Astrology and Numerology reports based on the user\'s full name, date and place of birth, collects, uses and protects your personal data. We are committed to protecting your privacy in compliance with the General Data Protection Regulation (GDPR) of the European Union and applicable legislation in Portugal.\n\nData Collected\nWe collect only the data strictly necessary to provide the service:\n\nFull name;\n\nDate of birth;\n\nPlace of birth.\n\nThis data is used exclusively to calculate and generate your personalized Human Design, Astrology and Numerology reports. We do not collect additional sensitive data, such as email addresses or financial information, unless voluntarily provided for support or account registration.\n\nPurposes of Processing\nData is processed to:\n\nGenerate accurate reports based on the inputs provided;\n\nImprove the accuracy of astrological and human design calculations;\n\nAllow the optional storage of reports for future access (with your explicit consent).\n\nProcessing is lawful based on your free and informed consent, obtained at the time of data submission.\n\nData Sharing\nWe do not share your personal data with third parties, except:\n\nEssential technical service providers (e.g.: secure cloud servers in the EU) under data processing agreements that guarantee confidentiality;\n\nWhen required by law or competent authorities.\n\nThe generated reports are private and are not sold or used for marketing.\n​\n\nStorage and Security\nData is stored on secure servers located in the European Union, with technical measures such as encryption (AES-256), pseudonymization and access controls. We retain data only for the time necessary for the service (generally up to 30 days after the last access, unless consent for prolonged storage is given). We proceed with automatic secure deletion after this period.\n\nYour Rights\nYou can exercise your GDPR rights at any time:\n\nAccess to data;\n\nRectification or correction;\n\nErasure (\"right to be forgotten\");\n\nObjection to processing;\n\nLimitation of processing;\n\nData portability.\n\nTo request the deletion of your account and all associated data, you can do so through the following link: https://humanmatch.app/delete-account or by sending an email to support@humanmatch.app.\n\nConsent and Changes\nBy using the app, you consent to this policy. You can revoke consent at any time, which will prevent access to existing reports. We will update this policy as necessary, notifying users via the app.';

  @override
  String get processing => 'Processing...';

  @override
  String get acceptAndContinue => 'Accept and continue';

  @override
  String get cancelAndExit => 'Cancel and exit';

  @override
  String get loading => 'Wait...';

  @override
  String get createProfile => 'Create profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get baseData => 'User data';

  @override
  String get baseDataDesc =>
      'This allows calculating Human Design + ascendant.';

  @override
  String get name => 'Full Name';

  @override
  String get nameNumerologyInfo =>
      'This field will be used to determine the Numerology variables. Special characters or accents should not be used.';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get birthDate => 'Birth date';

  @override
  String get birthPlace => 'Birth place';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectTime => 'Select time';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String greeting(String name) {
    return 'Hello $name';
  }

  @override
  String get greetingEmpty => 'Hello!';

  @override
  String get hdTitle => 'Human Design';

  @override
  String get hdCalculating => 'Calculating Human Design...';

  @override
  String get astroTitle => 'Astrology';

  @override
  String get zodiacSign => 'Sign';

  @override
  String get ascendant => 'Ascendant';

  @override
  String get numTitle => 'Numerology';

  @override
  String get lifePath => 'Life Path';

  @override
  String get expression => 'Expression';

  @override
  String get soul => 'Soul';

  @override
  String get personality => 'Personality';

  @override
  String get profileInsights => 'Profile Insights';

  @override
  String get noInsights => 'You don\'t have insights generated yet.';

  @override
  String get generateInsights => 'Generate Insights (Ad)';

  @override
  String get update => 'Update';

  @override
  String get profilePillars => 'Your Profile Pillars';

  @override
  String get dailyTip => 'Daily Tip';

  @override
  String get getDailyTip => 'Get daily tip (Ad)';

  @override
  String get watchAdForTip => 'Watch the ad to get your daily tip';

  @override
  String get errorFillEmailPassword => 'Fill in email and password.';

  @override
  String get errorAcceptTerms => 'You need to accept the Terms and Conditions.';

  @override
  String get resetEmailSent => 'Email sent. (Check spam too)';

  @override
  String get resetEmailError => 'Write your email above and try again.';

  @override
  String get errorUserNotFound => 'User not found.';

  @override
  String get errorWrongPassword => 'Wrong password.';

  @override
  String get errorInvalidEmail => 'Invalid email.';

  @override
  String get errorEmailAlreadyInUse => 'This email is already in use.';

  @override
  String get errorWeakPassword => 'Weak password (min. 6 characters).';

  @override
  String errorGeneral(String error) {
    return 'Error: $error';
  }

  @override
  String get errorFillProfile => 'Fill in name, date, time, and city.';

  @override
  String errorSavingProfile(String error) {
    return 'Error saving/calculating: $error';
  }

  @override
  String get signAries => 'Aries';

  @override
  String get signTaurus => 'Taurus';

  @override
  String get signGemini => 'Gemini';

  @override
  String get signCancer => 'Cancer';

  @override
  String get signLeo => 'Leo';

  @override
  String get signVirgo => 'Virgo';

  @override
  String get signLibra => 'Libra';

  @override
  String get signScorpio => 'Scorpio';

  @override
  String get signSagittarius => 'Sagittarius';

  @override
  String get signCapricorn => 'Capricorn';

  @override
  String get signAquarius => 'Aquarius';

  @override
  String get signPisces => 'Pisces';

  @override
  String get hdType => 'Type';

  @override
  String get hdAuthority => 'Authority';

  @override
  String get hdStrategy => 'Strategy';

  @override
  String get hdProfile => 'Profile';

  @override
  String get hdSignature => 'Signature';

  @override
  String get hdNotSelf => 'Not-Self';

  @override
  String get hdDefinition => 'Definition';

  @override
  String get hdIncarnationCross => 'Incarnation Cross';

  @override
  String get hdEnergyCenters => 'Centers';

  @override
  String get hdEnergyCentersChannels => 'Centers, channels and gates';

  @override
  String get hdDefinedCenters => 'Defined Centers';

  @override
  String get hdChannels => 'Channels';

  @override
  String get hdNoData => 'No data available.';

  @override
  String hdAuthorityNotice(String center) {
    return '* $center is the authority center';
  }

  @override
  String get hdDesign => 'Design';

  @override
  String get hdUnconscious => '(Unconscious)';

  @override
  String get hdPlanetaryActivation => 'Planetary Activation';

  @override
  String get hdPlanets => 'Astros';

  @override
  String get hdPersonality => 'Personality';

  @override
  String get hdConscious => '(Conscious)';

  @override
  String get hdGen => 'Generator';

  @override
  String get hdMG => 'Manifesting Generator';

  @override
  String get hdMan => 'Manifestor';

  @override
  String get hdProj => 'Projector';

  @override
  String get hdRef => 'Reflector';

  @override
  String get hdAuthEmo => 'Emotional';

  @override
  String get hdAuthSac => 'Sacral';

  @override
  String get hdAuthSpl => 'Splenic';

  @override
  String get hdAuthEgo => 'Ego';

  @override
  String get hdAuthSelf => 'Self-projected';

  @override
  String get hdAuthMen => 'Mental';

  @override
  String get hdAuthLun => 'Lunar';

  @override
  String get hdStrInf => 'To inform';

  @override
  String get hdStrResp => 'To respond';

  @override
  String get hdStrRespInf => 'To respond and inform';

  @override
  String get hdStrInv => 'Wait for invitation';

  @override
  String get hdStrLun => 'Wait a lunar cycle';

  @override
  String get hdSigSat => 'Satisfaction';

  @override
  String get hdSigSuc => 'Success';

  @override
  String get hdSigPea => 'Peace';

  @override
  String get hdSigSur => 'Surprise';

  @override
  String get hdNotFru => 'Frustration';

  @override
  String get hdNotBit => 'Bitterness';

  @override
  String get hdNotAng => 'Anger';

  @override
  String get hdNotDis => 'Disappointment';

  @override
  String get hdDefSin => 'Single Definition';

  @override
  String get hdDefSpl => 'Split Definition';

  @override
  String get hdDefTri => 'Triple Split';

  @override
  String get hdDefQua => 'Quadruple Split';

  @override
  String get hdCrossRight => 'Right Angle';

  @override
  String get hdCrossLeft => 'Left Angle';

  @override
  String get hdCrossJuxta => 'Justaposição';

  @override
  String get hdCrossOf => 'Cross of';

  @override
  String get hdCenterHead => 'Head';

  @override
  String get hdCenterAjna => 'Ajna';

  @override
  String get hdCenterThroat => 'Throat';

  @override
  String get hdCenterG => 'G Center';

  @override
  String get hdCenterEgo => 'Ego (Heart)';

  @override
  String get hdCenterSpleen => 'Spleen';

  @override
  String get hdCenterSolar => 'Solar Plexus';

  @override
  String get hdCenterSacral => 'Sacral';

  @override
  String get hdCenterRoot => 'Root';

  @override
  String get hdPlanetSun => 'Sun';

  @override
  String get hdPlanetEarth => 'Earth';

  @override
  String get hdPlanetMoon => 'Moon';

  @override
  String get hdPlanetMercury => 'Mercury';

  @override
  String get hdPlanetVenus => 'Venus';

  @override
  String get hdPlanetMars => 'Mars';

  @override
  String get hdPlanetJupiter => 'Jupiter';

  @override
  String get hdPlanetSaturn => 'Saturn';

  @override
  String get hdPlanetUranus => 'Uranus';

  @override
  String get hdPlanetNeptune => 'Neptune';

  @override
  String get hdPlanetPluto => 'Pluto';

  @override
  String get legalInfo => 'Legal Information';

  @override
  String get deleteAccountData => 'Delete Account and Data';

  @override
  String get verifyEmailTitle => 'Verify your Email';

  @override
  String verifyEmailSent(String email) {
    return 'We sent a verification email to $email. Please check your inbox (and spam folder).';
  }

  @override
  String get checkVerification => 'I\'ve verified';

  @override
  String get resendVerification => 'Resend email';

  @override
  String get verificationResent => 'Verification email resent.';

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
  String get astroMoonSign => 'Moon Sign';

  @override
  String get astroMercurySign => 'Mercury';

  @override
  String get astroVenusSign => 'Venus';

  @override
  String get astroMarsSign => 'Mars';

  @override
  String get astroMC => 'Midheaven (MC)';

  @override
  String get astroNorthNode => 'North Node';

  @override
  String get astroSouthNode => 'South Node';

  @override
  String get astroHouses => 'Astrological Houses';

  @override
  String astroHouseN(int n) {
    return 'House $n';
  }

  @override
  String get astroAspects => 'Astrological Aspects';

  @override
  String get astroBig3 => '🌟 Big 3';

  @override
  String get astroPersonalPlanets => '🪐 Personal Planets';

  @override
  String get astroSocialGenerationalPlanets =>
      '🪐 Social and Generational Planets';

  @override
  String get astroMCNodes => '🎯 MC and Lunar Nodes';

  @override
  String get hdIndicators => 'Main Indicators';

  @override
  String get hdBodygraph => 'Bodygraph';
}
