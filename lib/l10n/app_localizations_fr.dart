// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Human Match';

  @override
  String get tabProfile => 'Mon Profil';

  @override
  String get tabCommunity => 'Communauté';

  @override
  String get tabCompare => 'Comparer';

  @override
  String get welcomeMessage => 'Connais-toi bien, relie-toi mieux !';

  @override
  String get soonMessage => 'Bientôt';

  @override
  String get communitySoon => 'Explorez des profils proches et compatibles';

  @override
  String get compareSoon => 'Comparez les profils manuellement';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get hasAccount => 'Déjà un compte ? Connexion';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get acceptTerms => 'J\'accepte les Conditions Générales';

  @override
  String get termsTitle => 'Conditions Générales';

  @override
  String get termsContent =>
      'Politique de confidentialité - Human Match\n\nCette politique de confidentialité décrit comment Human Match, une application mobile qui génère des rapports personnalisés de Human Design, d\'astrologie et de numérologie basés sur le nom complet, la date et le lieu de naissance des utilisateurs, collecte, utilise et protège vos données personnelles. Nous nous engageons à protéger votre vie privée conformément au Règlement général sur la protection des données (RGPD) de l\'Union européenne et à la législation applicable au Portugal.\n\nDonnées collectées\nNous collectons uniquement les données strictly nécessaires à la fourniture du service :\n- Nom complet ;\n- Date de naissance ;\n- Lieu de naissance.\n\nCes données sont utilisées exclusivement pour calculer et générer vos rapports personnalisés de Human Design, d\'astrologie et de numérologie. Nous ne collectons pas de données sensibles supplémentaires, telles que l\'adresse e-mail ou les informations financières, a moins qu\'elles ne soient fournies volontairement pour l\'assistance ou l\'enregistrement d\'un compte.\n\nFinalités du traitement\nLes données sont traitées pour :\n- Générer des rapports précis basés sur les données fournies ;\n- Améliorer la précision des calculs astrologiques et de design humain ;\n- Permettre le stockage facultatif des rapports pour un accès futur (avec votre consentement explicite).\n\nLe traitement est licite sur la base de votre consentement libre et éclairé, obtenu au moment de la soumission des données.\n\nPartage de données\nNous ne partageons pas vos données personnelles with tiers, sauf :\n- Prestataires de services techniques essentiels (par exemple, serveurs cloud sécurisés dans l\'UE) dans le cadre d\'accords de traitement de données garantissant la confidentialité ;\n- Lorsque la loi ou les autorités compétentes l\'exigent.\n\nLes rapports générés sont privés et ne sont pas vendus ni utilisés à des fins de marketing.\n\nStockage et sécurité\nLes données sont stockées sur des serveurs sécurisés situés dans l\'Union européenne, avec des mesures techniques telles que le cryptage (AES-256), la pseudonymisation et les contrôles d\'accès. Nous ne conservons les données que pendant la durée nécessaire au service (généralement jusqu\'à 30 jours après le dernier accès, sauf consentement pour un stockage prolongé). Nous procédons à une suppression sécurisée automatique après cette période.\n\nvos droits\nVous pouvez exercer vos droits RGPD à tout moment :\n- Accès aux données ;\n- Rectification ou correction ;\n- Effacement (\"droit à l\'oubli\") ;\n- Opposition au traitement ;\n- Limitation du traitement ;\n- Portabilidade des données.\n\nPour demander la suppression de votre compte et de toutes les données associées, vous pouvez le faire via le lien suivant : https://humanmatch.app/delete-account ou en envoyant un e-mail à support@humanmatch.app.\n\nConsentement et modifications\nEn utilisant l\'application, vous consentez à cette politique. Vous pouvez révoquer votre consentement à tout moment, ce qui empêchera l\'accès aux rapports existants. Nous mettrons à jour cette politique si nécessaire, en informant les utilisateurs via l\'application.';

  @override
  String get processing => 'Traitement...';

  @override
  String get acceptAndContinue => 'Accepter et continuer';

  @override
  String get cancelAndExit => 'Annuler et quitter';

  @override
  String get loading => 'Attendez...';

  @override
  String get createProfile => 'Créer un profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get baseData => 'Données de l\'utilisateur';

  @override
  String get baseDataDesc =>
      'Cela permet de calculer le Human Design + l\'ascendant.';

  @override
  String get name => 'Nom Complet';

  @override
  String get nameNumerologyInfo =>
      'Ce champ sera utilisé pour déterminer les variables de la Numérologie. Les caractères spéciaux ou les accents ne doivent pas être utilisés.';

  @override
  String get country => 'Pays';

  @override
  String get city => 'Ville';

  @override
  String get saveProfile => 'Enregistrer le profil';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get birthPlace => 'Lieu de naissance';

  @override
  String get selectDate => 'Choisir une date';

  @override
  String get selectTime => 'Choisir l\'heure';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String greeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String get greetingEmpty => 'Bonjour !';

  @override
  String get hdTitle => 'Human Design';

  @override
  String get hdCalculating => 'Calcul du Human Design en cours...';

  @override
  String get astroTitle => 'Astrologie';

  @override
  String get zodiacSign => 'Signe';

  @override
  String get ascendant => 'Ascendant';

  @override
  String get numTitle => 'Numérologie';

  @override
  String get lifePath => 'Chemin de Vie';

  @override
  String get expression => 'Expression';

  @override
  String get soul => 'Âme';

  @override
  String get personality => 'Personnalité';

  @override
  String get profileInsights => 'Aperçus du profil';

  @override
  String get noInsights => 'Vous n\'avez pas encore d\'insights générés.';

  @override
  String get generateInsights => 'Générer des Insights (Publicité)';

  @override
  String get update => 'Mettre à jour';

  @override
  String get profilePillars => 'Piliers de votre Profil';

  @override
  String get dailyTip => 'Conseil Quotidien';

  @override
  String get getDailyTip => 'Obtenir un conseil (Publicité)';

  @override
  String get watchAdForTip =>
      'Regardez la publicité pour obtenir votre conseil';

  @override
  String get errorFillEmailPassword =>
      'Veuillez saisir votre e-mail et votre mot de passe.';

  @override
  String get errorAcceptTerms =>
      'Vous devez accepter les conditions générales.';

  @override
  String get resetEmailSent => 'E-mail envoyé. (Vérifiez également vos spams)';

  @override
  String get resetEmailError =>
      'Saisissez votre e-mail ci-dessus et réessayez.';

  @override
  String get errorUserNotFound => 'Utilisateur non trouvé.';

  @override
  String get errorWrongPassword => 'Mot de passe incorrect.';

  @override
  String get errorInvalidEmail => 'E-mail invalide.';

  @override
  String get errorEmailAlreadyInUse => 'Cet e-mail est déjà utilisé.';

  @override
  String get errorWeakPassword =>
      'Mot de passe trop court (min. 6 caractères).';

  @override
  String errorGeneral(String error) {
    return 'Erreur : $error';
  }

  @override
  String get errorFillProfile =>
      'Veuillez renseigner votre nom, date, heure et ville.';

  @override
  String errorSavingProfile(String error) {
    return 'Erreur lors de l\'enregistrement/calcul : $error';
  }

  @override
  String get signAries => 'Bélier';

  @override
  String get signTaurus => 'Taureau';

  @override
  String get signGemini => 'Gémeaux';

  @override
  String get signCancer => 'Cancer';

  @override
  String get signLeo => 'Lion';

  @override
  String get signVirgo => 'Vierge';

  @override
  String get signLibra => 'Balance';

  @override
  String get signScorpio => 'Scorpion';

  @override
  String get signSagittarius => 'Sagittaire';

  @override
  String get signCapricorn => 'Capricorne';

  @override
  String get signAquarius => 'Verseau';

  @override
  String get signPisces => 'Poissons';

  @override
  String get hdType => 'Type';

  @override
  String get hdAuthority => 'Autorité';

  @override
  String get hdStrategy => 'Stratégie';

  @override
  String get hdProfile => 'Profil';

  @override
  String get hdSignature => 'Signature';

  @override
  String get hdNotSelf => 'Non-soi';

  @override
  String get hdDefinition => 'Définition';

  @override
  String get hdIncarnationCross => 'Croix';

  @override
  String get hdEnergyCenters => 'Centres énergétiques';

  @override
  String get hdDefinedCenters => 'Centres définis';

  @override
  String get hdChannels => 'Canaux';

  @override
  String get hdNoData => 'Aucune donnée disponible.';

  @override
  String hdAuthorityNotice(String center) {
    return '* $center est le centre d\'autorité';
  }

  @override
  String get hdDesign => 'Design';

  @override
  String get hdUnconscious => '(Inconscient)';

  @override
  String get hdPlanets => 'Planètes';

  @override
  String get hdPersonality => 'Personnalité';

  @override
  String get hdConscious => '(Conscient)';

  @override
  String get hdGen => 'Générateur';

  @override
  String get hdMG => 'Générateur Manifesteur';

  @override
  String get hdMan => 'Manifesteur';

  @override
  String get hdProj => 'Projecteur';

  @override
  String get hdRef => 'Réflecteur';

  @override
  String get hdAuthEmo => 'Émotionnelle';

  @override
  String get hdAuthSac => 'Sacrale';

  @override
  String get hdAuthSpl => 'Splénique';

  @override
  String get hdAuthEgo => 'Ego';

  @override
  String get hdAuthSelf => 'Auto-projetée';

  @override
  String get hdAuthMen => 'Mentale';

  @override
  String get hdAuthLun => 'Lunaire';

  @override
  String get hdStrInf => 'Informer';

  @override
  String get hdStrResp => 'Attendre pour répondre';

  @override
  String get hdStrRespInf => 'Répondre et informer';

  @override
  String get hdStrInv => 'Attendre l\'invitation';

  @override
  String get hdStrLun => 'Attendre un cycle lunaire';

  @override
  String get hdSigSat => 'Satisfaction';

  @override
  String get hdSigSuc => 'Succès';

  @override
  String get hdSigPea => 'Paix';

  @override
  String get hdSigSur => 'Surprise';

  @override
  String get hdNotFru => 'Frustration';

  @override
  String get hdNotBit => 'Amertume';

  @override
  String get hdNotAng => 'Colère';

  @override
  String get hdNotDis => 'Déception';

  @override
  String get hdDefSin => 'Définition Simple';

  @override
  String get hdDefSpl => 'Définition Partagée';

  @override
  String get hdDefTri => 'Triple Définition';

  @override
  String get hdDefQua => 'Quadruple Définition';

  @override
  String get hdCrossRight => 'Angle Droit';

  @override
  String get hdCrossLeft => 'Angle Gauche';

  @override
  String get hdCrossJuxta => 'Juxtaposition';

  @override
  String get hdCrossOf => 'Croix de';

  @override
  String get hdCenterHead => 'Tête';

  @override
  String get hdCenterAjna => 'Ajna';

  @override
  String get hdCenterThroat => 'Gorge';

  @override
  String get hdCenterG => 'Centre G';

  @override
  String get hdCenterEgo => 'Ego (Cœur)';

  @override
  String get hdCenterSpleen => 'Rate';

  @override
  String get hdCenterSolar => 'Plexus Solaire';

  @override
  String get hdCenterSacral => 'Sacrum';

  @override
  String get hdCenterRoot => 'Racine';

  @override
  String get hdPlanetSun => 'Soleil';

  @override
  String get hdPlanetEarth => 'Terre';

  @override
  String get hdPlanetMoon => 'Lune';

  @override
  String get hdPlanetMercury => 'Mercure';

  @override
  String get hdPlanetVenus => 'Vénus';

  @override
  String get hdPlanetMars => 'Mars';

  @override
  String get hdPlanetJupiter => 'Jupiter';

  @override
  String get hdPlanetSaturn => 'Saturne';

  @override
  String get hdPlanetUranus => 'Uranus';

  @override
  String get hdPlanetNeptune => 'Neptune';

  @override
  String get hdPlanetPluto => 'Pluton';

  @override
  String get legalInfo => 'Informations Légales';

  @override
  String get deleteAccountData => 'Suppression de Compte et Données';

  @override
  String get verifyEmailTitle => 'Vérifiez votre e-mail';

  @override
  String verifyEmailSent(String email) {
    return 'Nous avons envoyé un e-mail de confirmation à $email. Veuillez vérifier votre boîte de réception (et votre dossier de spam).';
  }

  @override
  String get checkVerification => 'J\'ai vérifié';

  @override
  String get resendVerification => 'Renvoyer l\'e-mail';

  @override
  String get verificationResent => 'E-mail de vérification renvoyé.';

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
}
