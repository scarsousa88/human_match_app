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
      'Politique de confidentialité - Human Match\n\nCette politique de confidentialité décrit comment Human Match, une application mobile qui génère des rapports personnalisés de Human Design, d\'astrologie et de numérologie basés sur le nom complet, la date et le lieu de naissance des utilisateurs, collecte, utilise et protège vos données personnelles. Nous nous engageons à protéger votre vie privée conformément au Règlement général sur la protection des données (RGPD) de l\'Union européenne et à la législation applicable au Portugal.\n\nDonnées collectées\nNous collectons uniquement les données strictement nécessaires à la fourniture du service :\n\nNom complet ;\n\nDate de naissance ;\n\nLieu de naissance.\n\nCes données sont utilisées exclusivement pour calculer et générer vos rapports personnalisés de Human Design, d\'astrologie et de numérologie. Nous ne collectons pas de données sensibles supplémentaires, telles que l\'adresse e-mail ou les informations financières, à moins qu\'elles ne soient fournies volontairement pour l\'assistance ou l\'enregistrement d\'un compte.\n\nFinalités du traitement\nLes données sont traitées pour :\n\nGénérer des rapports précis basés sur les données fournies ;\n\nAméliorer la précision des calculs astrologiques et de design humain ;\n\nPermettre le stockage facultatif des rapports pour un accès futur (avec votre consentement explicite).\n\nLe traitement est licite sur la base de votre consentement libre et éclairé, obtenu au moment de la soumission des données.\n\nPartage de données\nNous ne partageons pas vos données personnelles avec des tiers, sauf :\n\nPrestataires de services techniques essentiels (par exemple, serveurs cloud sécurisés dans l\'UE) dans le cadre d\'accords de traitement de données garantissant la confidentialité ;\n\nLorsque la loi ou les autorités compétentes l\'exigent.\n\nLes rapports générés sont privés et ne sont pas vendus ni utilisés à des fins de marketing.\n\nStockage et sécurité\nLes données sont stockées sur des serveurs sécurisés situés dans l\'Union européenne, avec des mesures techniques telles que le cryptage (AES-256), la pseudonymisation et les contrôles d\'accès. Nous ne conservons les données que pendant la durée nécessaire au service (généralement jusqu\'à 30 jours après le dernier accès, sauf consentement pour un stockage prolongé). Nous procédons à une suppression sécurisée automatique après cette période.\n\nVos droits\nVous pouvez exercer vos droits RGPD à tout moment :\n\nAccès aux données ;\n\nRectification ou correction ;\n\nEffacement (\"droit à l\'oubli\") ;\n\nOpposition au traitement ;\n\nLimitation du traitement ;\n\nPortabilité des données.\n\nPour demander la suppression de votre compte et de toutes les données associadas, vous pouvez le faire via le lien suivant : https://humanmatch.app/delete-account ou en envoyant un e-mail à support@humanmatch.app.\n\nConsentement et modifications\nEn utilisant l\'application, vous consentez à cette politique. Vous pouvez révoquer votre consentement à tout moment, ce qui empêchera l\'accès aux rapports existants. Nous mettrons à jour cette politique si nécessaire, en informant les utilisateurs via l\'application.';

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
  String get hdIncarnationCross => 'Croix d\'Incarnation';

  @override
  String get hdEnergyCenters => 'Centres';

  @override
  String get hdEnergyCentersChannels => 'Centres, canaux et portes';

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
  String get hdUnconscious => '(Inconsciente)';

  @override
  String get hdPlanetaryActivation => 'Activation Planétaire';

  @override
  String get hdPlanets => 'Astres';

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
  String get hdStrResp => 'Répondre';

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
  String get hdCenterEgo => 'Cœur (Ego)';

  @override
  String get hdCenterSpleen => 'Rate';

  @override
  String get hdCenterSolar => 'Plexus Solaire';

  @override
  String get hdCenterSacral => 'Sacrum';

  @override
  String get hdCenterRoot => 'Racine';

  @override
  String get hdCenterNameHead => 'Tête';

  @override
  String get hdCenterNameAjna => 'Ajna';

  @override
  String get hdCenterNameThroat => 'Gorge';

  @override
  String get hdCenterNameG => 'Centre G';

  @override
  String get hdCenterNameHeart => 'Cœur';

  @override
  String get hdCenterNameSpleen => 'Rate';

  @override
  String get hdCenterNameSolar => 'Plexus Solaire';

  @override
  String get hdCenterNameSacral => 'Sacrum';

  @override
  String get hdCenterNameRoot => 'Racine';

  @override
  String get hdTypeDefDesc =>
      'Le Type définit la manière dont votre énergie interagit avec le monde.';

  @override
  String get hdAuthorityDefDesc =>
      'Votre Autorité est votre système interne de prise de décision.';

  @override
  String get hdStrategyDefDesc =>
      'La Stratégie est la méthode pour naviguer dans la vie avec moins de résistance.';

  @override
  String get hdProfileDefDesc =>
      'Le Profil décrit votre rôle et la manière dont vous apprenez et évoluez.';

  @override
  String get hdSignatureDefDesc =>
      'La Signature est le sentiment d\'être en phase avec votre design.';

  @override
  String get hdNotSelfDefDesc =>
      'Le Non-soi est le signe que vous vous éloignez de votre vérité.';

  @override
  String get hdDefinitionDefDesc =>
      'La Définition montre comment l\'énergie circule entre vos centres.';

  @override
  String get hdIncarnationCrossDefDesc =>
      'Votre Croix d\'Incarnation représente le but de votre vie.';

  @override
  String get hdValTypeGenerator =>
      'En tant que Générateur, votre énergie est conçue pour répondre à ce que la vie vous apporte, plutôt que d\'initier.';

  @override
  String get hdValTypeManifestingGenerator =>
      'Vous avez la rapidité du Manifesteur et la durabilité du Générateur. Répondez avant d\'agir.';

  @override
  String get hdValTypeManifestor =>
      'Vous êtes venu pour initier et impacter. Informez les autres avant d\'agir pour réduire la résistance.';

  @override
  String get hdValTypeProjector =>
      'Vous êtes ici pour guider les autres. Votre succès vient de l\'attente de la reconnaissance et de l\'invitation.';

  @override
  String get hdValTypeReflector =>
      'Vous êtes un miroir de la communauté. Attendez un cycle lunaire complet avant de prendre des décisions majeures.';

  @override
  String get hdValAuthEmotional =>
      'La clarté n\'arrive pas dans l\'instant. Attendez que votre vague émotionnelle se stabilise avant de décider.';

  @override
  String get hdValAuthSacral =>
      'Faites confiance à votre réponse viscérale immédiate (sons sacraux ou inclinaison physique) dans l\'instant présent.';

  @override
  String get hdValAuthSplenic =>
      'Faites confiance à votre intuition instinctive et spontanée qui vous avertit de ce qui est sûr et sain.';

  @override
  String get hdValAuthEgo =>
      'Votre volonté est votre guide. Qu\'est-ce que vous voulez vraiment et avez la volonté de faire ?';

  @override
  String get hdValAuthSelfProjected =>
      'Votre vérité sort de votre bouche. Écoutez ce que vous dites quand vous parlez sans penser à votre futur.';

  @override
  String get hdValAuthMental =>
      'Vous devez utiliser les autres comme une caisse de résonance pour entendre votre propre vérité en parlant.';

  @override
  String get hdValAuthLunar =>
      'En tant que Réflecteur, votre décision mûrit sur 28 jours en phase avec le cycle de la Lune.';

  @override
  String get hdValStrRespond =>
      'Votre meilleure façon d\'agir est de répondre aux opportunités qui se présentent, au lieu d\'essayer de forcer de nouvelles choses.';

  @override
  String get hdValStrInform =>
      'Pour réduire la résistance des autres, informez les personnes concernées par vos actions avant de les entreprendre.';

  @override
  String get hdValStrRespondInform =>
      'En tant que MG, vous devez d\'abord répondre, puis informer votre entourage avant de passer à l\'action rapide.';

  @override
  String get hdValStrInvite =>
      'Vous devez attendre une reconnaissance formelle et une invitation avant de partager votre sagesse ou vos conseils.';

  @override
  String get hdValStrLunar =>
      'Les décisions importantes ne doivent être prises qu\'après un cycle lunaire complet (environ 28 jours).';

  @override
  String get hdValSigSatisfaction =>
      'Vous ressentez de la satisfaction lorsque vous utilisez votre énergie de manière productive dans quelque chose qui vous plaît.';

  @override
  String get hdValSigSuccess =>
      'Le succès pour vous est d\'être reconnu pour ce que vous êtes et de voir les autres prospérer grâce à vos conseils.';

  @override
  String get hdValSigPeace =>
      'Vous ressentirez la paix lorsque vous pourrez agir librement et sans résistance après avoir informé les autres.';

  @override
  String get hdValSigSurprise =>
      'La surprise est le signe que vous voyez la vie avec un regard neuf, comme un miroir pur de l\'environnement.';

  @override
  String get hdValNotFrustration =>
      'La frustration surgit lorsque vous tentez d\'initier des choses sans attendre la réponse appropriée.';

  @override
  String get hdValNotBitterness =>
      'L\'amertume apparaît lorsque vous vous surmenez sans être invité ou reconnu.';

  @override
  String get hdValNotAnger =>
      'La colère est le résultat d\'une résistance ressentie parce que vous n\'avez pas informé les autres de vos intentions.';

  @override
  String get hdValNotDisappointment =>
      'La déception survient lorsque vous n\'êtes pas dans un environnement sain ou que vous tentez de décider trop vite.';

  @override
  String get hdValProf13 =>
      'Enquêteur/Martyr : Apprend par l\'expérimentation, des bases solides et la profondeur.';

  @override
  String get hdValProf14 =>
      'Enquêteur/Opportuniste : Influence son réseau proche en partageant son étude approfondie.';

  @override
  String get hdValProf24 =>
      'Ermite/Opportuniste : Un talent naturel qui a besoin de temps seul, mas qui s\'épanouit dans son réseau.';

  @override
  String get hdValProf25 =>
      'Eremite/Hérétique : Talent naturel conçu pour être un guide ou un sauveur pour les autres.';

  @override
  String get hdValProf35 =>
      'Martyr/Hérétique : Apprend par essais et erreurs et partage ce qui fonctionne pour défier le statu quo.';

  @override
  String get hdValProf36 =>
      'Martyr/Observateur : Expérimente dans la première phase de la vie pour devenir un guide sage et objectif.';

  @override
  String get hdValProf46 =>
      'Opportuniste/Observateur : Influence par le réseau et l\'objectivité, devenant un modèle.';

  @override
  String get hdValProf41 =>
      'Opportuniste/Enquêteur : Suit un chemin fixe et unique basé sur des fondations très solides.';

  @override
  String get hdValProf51 =>
      'Hérétique/Enquêteur : Le maître qui résout les problèmes pratiques par l\'étude et l\'autorité.';

  @override
  String get hdValProf52 =>
      'Hérétique/Ermite : Motivé par l\'autoréflexion, mais vu par les autres comme un guide naturel.';

  @override
  String get hdValProf62 =>
      'Observateur/Ermite : Modèle qui vit avec objectivité et détachement après une vie d\'expérience.';

  @override
  String get hdValProf63 =>
      'Observateur/Martyr : Modèle qui continue d\'évoluer par une expérimentation constante.';

  @override
  String get hdCenterHeadDefDesc =>
      'Vous traitez les pensées de manière cohérente et vous vous inspirez de vos propres idées.';

  @override
  String get hdCenterHeadUndDesc =>
      'Vous êtes ouvert aux idées nouvelles et avez la souplesse nécessaire pour voir différentes perspectives.';

  @override
  String get hdCenterAjnaDefDesc =>
      'Vous avez une façon fixe et organisée de penser et de traiter l\'information.';

  @override
  String get hdCenterAjnaUndDesc =>
      'Vous pouvez adapter votre façon de penser à n\'importe quelle situation sans opinions rigides.';

  @override
  String get hdCenterThroatDefDesc =>
      'Communication et action fiables et constantes par votre voix et vos actes.';

  @override
  String get hdCenterThroatUndDesc =>
      'Communication variable, selon l\'environnement et ceux qui vous entourent.';

  @override
  String get hdCenterGDefDesc =>
      'Vous avez un sens fixe et clair de qui vous êtes, de votre but et de votre direction dans la vie.';

  @override
  String get hdCenterGUndDesc =>
      'Votre identité est fluide et vous pouvez vous adapter et vous retrouver dans divers environnements.';

  @override
  String get hdCenterEgoDefDesc =>
      'Vous avez de la volonté et un engagement naturel pour atteindre vos objectifs.';

  @override
  String get hdCenterEgoUndDesc =>
      'Vous n\'avez rien à prouver à personne ; votre volonté est flexible.';

  @override
  String get hdCenterSpleenDefDesc =>
      'Intuition aiguisée et un instinct de survie fort et constant.';

  @override
  String get hdCenterSpleenUndDesc =>
      'Saisir la santé et le bien-être des autres de manière sensible et intuitive.';

  @override
  String get hdCenterSolarDefDesc =>
      'Vous vivez une vague émotionnelle profonde et cyclique ; la clarté vient avec le temps.';

  @override
  String get hdCenterSolarUndDesc =>
      'Vous êtes sensible aux émotions des autres, vous les captez et les amplifiez.';

  @override
  String get hdCenterSacralDefDesc =>
      'Source inépuisable d\'énergie vitale et de persévérance pour le travail que vous aimez.';

  @override
  String get hdCenterSacralUndDesc =>
      'Vous avez besoin de vous reposer quand l\'énergie vient à manquer ; vous n\'avez pas de moteur vital constant.';

  @override
  String get hdCenterRootDefDesc =>
      'Vous gérez bien la pression et avez un moteur interne pour stimuler l\'action.';

  @override
  String get hdCenterRootUndDesc =>
      'Vous pouvez ressentir la pression extérieure mais préférez agir à votre propre rythme.';

  @override
  String get hdDefined => 'Défini';

  @override
  String get hdUndefined => 'Indéfini';

  @override
  String get hdGates => 'Portes';

  @override
  String get hdGatesUser => 'Portes de l\'utilisateur';

  @override
  String get hdChannelsUser => 'Canaux de l\'utilisateur';

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
      'Cet e-mail est déjà utilisé. Veuillez essayer de vous connecter au lieu de créer un compte.';

  @override
  String get errorInvalidCredentials =>
      'Identifiants incorrects ou compte inexistant.';

  @override
  String get errorUserDisabled => 'Compte désactivé.';

  @override
  String get errorTooManyRequests =>
      'Bloqué temporairement par excès de tentatives.';

  @override
  String get errorAccountExistsGoogle =>
      'Un compte avec cet e-mail existe déjà via Google. Utilisez \"Continuer avec Google\".';

  @override
  String errorUnexpected(Object error) {
    return 'Erreur inattendue : $error';
  }

  @override
  String errorGoogle(Object error) {
    return 'Erreur Google : $error';
  }

  @override
  String errorResetPassword(Object error) {
    return 'Erreur lors de la réinitialisation : $error';
  }

  @override
  String get close => 'Fermer';

  @override
  String authError(Object error) {
    return 'Erreur d\'authentification : $error';
  }

  @override
  String get tryAgain => 'Réessayer';

  @override
  String loadProfileError(String error) {
    return 'Erreur lors du chargement du profil : $error';
  }

  @override
  String get logoutAndTryAgain => 'Se déconnecter et réessayer';

  @override
  String get astroMoonSign => 'Signe Lunaire';

  @override
  String get astroMercurySign => 'Mercure';

  @override
  String get astroVenusSign => 'Vénus';

  @override
  String get astroMarsSign => 'Mars';

  @override
  String get astroMC => 'Milieu du Ciel (MC)';

  @override
  String get astroNorthNode => 'Nœud Nord';

  @override
  String get astroSouthNode => 'Nœud Sud';

  @override
  String get astroHouses => 'Maisons Astrologiques';

  @override
  String astroHouseN(int n) {
    return 'Maison $n';
  }

  @override
  String get astroAspects => 'Aspects Planétaires';

  @override
  String get astroBig3 => '🌟 Big 3';

  @override
  String get astroPersonalPlanets => '🪐 Planètes Personnelles';

  @override
  String get astroSocialGenerationalPlanets =>
      '🪐 Planètes Sociales et Générationnelles';

  @override
  String get astroMCNodes => '🎯 MC et Nœuds Lunares';

  @override
  String get hdIndicators => 'Indicateurs principaux';

  @override
  String get hdBodygraph => 'Carte du corps';

  @override
  String get astroSunDefDesc =>
      'Le Soleil représente votre essence, votre identité centrale, votre ego et la manière dont vous brillez dans le monde. C\'est le cœur de votre personnalité.';

  @override
  String get astroMoonDefDesc =>
      'La Lune régit vos émotions, votre monde intérieur, vos besoins subconscients et comment vous vous sentez en sécurité et nourri.';

  @override
  String get astroAscendantDefDesc =>
      'L\'Ascendant est votre masque social, la première impression que vous donnez et comment vous initiez les choses.';

  @override
  String get astroMercuryDefDesc =>
      'Mercure régit votre esprit, votre façon de communiquer, de traiter l\'information, votre curiosité intellectuelle et votre apprentissage.';

  @override
  String get astroVenusDefDesc =>
      'Vénus représente comment vous aimez, ce que vous appréciez, votre esthétique et la façon dont vous vous liez, donnez de la valeur et attirez l\'harmonie.';

  @override
  String get astroMarsDefDesc =>
      'Mars symbolise votre action, votre dynamisme, votre courage et la façon dont vous poursuivez vos désirs et gérez les défis et les conflits.';

  @override
  String get astroValSignAries =>
      'Énergie pionnière, courageuse et pleine d\'initiative. Aime diriger et relever de nouveaux défis.';

  @override
  String get astroValSignTaurus =>
      'Focus sur la stabilité, le plaisir sensoriel et la persévérance. Valorise la sécurité et le confort matériel.';

  @override
  String get astroValSignGemini =>
      'Curiosité insatiable, communication polyvalente et agilité mentale. Adore échanger des idées et apprendre.';

  @override
  String get astroValSignCancer =>
      'Sensibilité profonde, soutien émotionnel et lien fort avec les racines et la famille.';

  @override
  String get astroValSignLeo =>
      'Expression créative, confiance, chaleur et éclat personnel. Recherche la reconnaissance et l\'authenticité.';

  @override
  String get astroValSignVirgo =>
      'Analyse détaillée, recherche de perfection, organisation et désir d\'être utile et pratique.';

  @override
  String get astroValSignLibra =>
      'Équilibre, harmonie dans les relations, diplomatie et un sens aigu de l\'esthétique et de la justice.';

  @override
  String get astroValSignScorpio =>
      'Intensité profonde, passion, transformation et un puissant magnétisme émotionnel.';

  @override
  String get astroValSignSagittarius =>
      'Expansion, recherche de sens, optimisme et amour pour la liberté et l\'aventure intellectuelle.';

  @override
  String get astroValSignCapricorn =>
      'Responsabilité, ambition, discipline et une approche structurée pour réussir.';

  @override
  String get astroValSignAquarius =>
      'Originalité, vision humanitaire, indépendance et pensée innovante et progressiste.';

  @override
  String get astroValSignPisces =>
      'Vaste empathie, intuition aiguisée, imagination et lien fort avec le monde spirituel et émotionnel.';
}
