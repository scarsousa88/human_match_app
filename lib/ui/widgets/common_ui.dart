import 'package:flutter/material.dart';

class Shell extends StatelessWidget {
  final Widget child;
  const Shell({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class PrimaryCard extends StatelessWidget {
  final Widget child;
  const PrimaryCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isRightAligned = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isRightAligned;

  @override
  Widget build(BuildContext context) {
    final textCol = Column(
      crossAxisAlignment: isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodyMedium, textAlign: isRightAligned ? TextAlign.right : TextAlign.left),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        if (isRightAligned) textCol else Expanded(child: textCol),
      ],
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final valueStyle = Theme.of(context).textTheme.titleSmall;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: labelStyle)),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}
