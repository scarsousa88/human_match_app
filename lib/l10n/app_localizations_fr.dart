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
      'Bem-vindo ao Human Match.\n\n1. Proteção de Dados: Ao utilizar esta aplicação, concorda com o processamento dos seus dados de nascimento (data, hora e local) para o cálculo do seu perfil de Human Design, Astrologia e Numerologia.\n\n2. Inteligência Artificial: Os insights e dicas gerados são produzidos por modelos de IA e devem ser interpretados como sugestões de autoconhecimento, não como aconselhamento profissional ou médico.\n\n3. Anúncios: A aplicação utiliza anúncios premiados para desbloquear conteúdos gratuitos. Dados anónimos de publicidade podem ser processados pela Google AdMob.\n\n4. Privacidade: Não partilhamos os seus dados pessoais com terceiros. Pode apagar a sua conta a qualquer momento nas definições.\n\nAo aceitar, confirma que tem mais de 18 anos ou autorização parental.';

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
}
