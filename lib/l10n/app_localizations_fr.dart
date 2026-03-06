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
  String get acceptTerms => 'J\'accepte les Conditions Générales';

  @override
  String get termsTitle => 'Conditions Générales';

  @override
  String get termsContent =>
      'Bienvenue sur Human Match.\n\n1. Protection des données : En utilisant cette application, vous acceptez le traitement de vos données de naissance (date, heure et lieu) pour le calcul de votre profil Human Design, Astrologie et Numérologie.\n\n2. Intelligence Artificielle : Les insights et conseils générés sont produits par des modèles d\'IA et doivent être interprétés comme des suggestions de connaissance de soi, et non comme des conseils professionnels ou médicaux.\n\n3. Publicité : L\'application utilise des publicités récompensées pour débloquer du contenu gratuit. Des données publicitaires anonymes peuvent être traitées par Google AdMob.\n\n4. Confidentialité : Nous ne partageons pas vos données personnelles avec des tiers. Vous pouvez supprimer votre compte à tout moment dans les paramètres.\n\nEn acceptant, vous confirmez que vous avez plus de 18 ans ou une autorisation parentale.';

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
  String get baseData => 'Données de base';

  @override
  String get baseDataDesc =>
      'Cela permet de calculer le Human Design + l\'ascendant.';

  @override
  String get name => 'Nom';

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
  String get profileInsights => 'Insights de Profil';

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
}
