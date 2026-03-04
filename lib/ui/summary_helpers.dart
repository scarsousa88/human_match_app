import '../calc/numerology.dart';

String firstNameFromFullName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? '' : parts.first;
}

/// Adapta o teu NumerologyResult para algo simples de mostrar.
Map<String, String> numerologyToMap(NumerologyResult n) {
  return {
    'Caminho de Vida': n.lifePath.toString(),
    'Expressão': n.expression.toString(),
    'Alma': n.soul.toString(),
    'Personalidade': n.personality.toString(),
  };
}

/// Um resumo curto para o prompt.
String numerologySummary(NumerologyResult n) {
  return 'Caminho de Vida ${n.lifePath}, Expressão ${n.expression}, Alma ${n.soul}, Personalidade ${n.personality}.';
}