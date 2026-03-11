import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/common_ui.dart';
import '../../ai_actions.dart';

class EssenceScreen extends StatefulWidget {
  const EssenceScreen({super.key});

  @override
  State<EssenceScreen> createState() => _EssenceScreenState();
}

class _EssenceScreenState extends State<EssenceScreen> {
  late AiActions _ai;
  bool _loadingAd = false;

  @override
  void initState() {
    super.initState();
    _ai = AiActions(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Not logged in')));

    final l10n = AppLocalizations.of(context)!;
    const goldColor = Color(0xFFE6B325);
    const appPurple = Color(0xFF3E1E4F);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.essenceName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final balance = data['essenceBalance'] ?? 0;
          final adStats = data['essenceAdStats'] as Map? ?? {};
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: appPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: goldColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/icon/essence.svg', width: 60, height: 60),
                        const SizedBox(height: 12),
                        Text(
                          l10n.essenceCount(balance),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Free Essences Section
                _SectionHeader(title: l10n.essenceAdsTitle),
                const SizedBox(height: 12),
                PrimaryCard(
                  child: Column(
                    children: [
                      Text(
                        l10n.essenceAdsDesc,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      _buildAdProgress(adStats, l10n),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loadingAd ? null : () => _watchAdForEssence(adStats),
                          icon: _loadingAd 
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : const Icon(Icons.play_circle_outline),
                          label: Text(l10n.essenceWatchAd.toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Store Section
                _SectionHeader(title: l10n.essenceStoreTitle),
                const SizedBox(height: 12),
                _buildStoreItem(
                  title: l10n.essencePackStarter,
                  amount: 10,
                  price: '€1.99',
                  description: 'Ideal para os primeiros passos',
                  l10n: l10n,
                ),
                _buildStoreItem(
                  title: l10n.essencePackCosmic,
                  amount: 50,
                  price: '€7.99',
                  description: 'O pack mais equilibrado',
                  isPopular: true,
                  l10n: l10n,
                ),
                _buildStoreItem(
                  title: l10n.essencePackInfinite,
                  amount: 150,
                  price: '€19.99',
                  description: 'Exploração sem limites',
                  l10n: l10n,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdProgress(Map adStats, AppLocalizations l10n) {
    final List timestamps = adStats['timestamps'] as List? ?? [];
    final now = DateTime.now();
    final eightHoursAgo = now.subtract(const Duration(hours: 8));
    
    final validRecent = timestamps.where((ts) {
      if (ts is Timestamp) return ts.toDate().isAfter(eightHoursAgo);
      return false;
    }).toList();

    int count = validRecent.length;
    bool isLimitReached = count >= 3;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            bool active = index < count;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? const Color(0xFFE6B325) : Colors.white10,
                border: Border.all(color: active ? Colors.transparent : Colors.white24),
              ),
            );
          }),
        ),
        if (isLimitReached) ...[
          const SizedBox(height: 12),
          Text(
            l10n.essenceAdLimit('8h'),
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ]
      ],
    );
  }

  Widget _buildStoreItem({
    required String title,
    required int amount,
    required String price,
    required String description,
    bool isPopular = false,
    required AppLocalizations l10n,
  }) {
    const goldColor = Color(0xFFE6B325);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: PrimaryCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset('assets/icon/essence.svg', width: 32, height: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: goldColor, borderRadius: BorderRadius.circular(4)),
                          child: const Text('POPULAR', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ],
                  ),
                  Text(description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamentos em implementação.'))
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: goldColor.withOpacity(0.1),
                foregroundColor: goldColor,
                side: const BorderSide(color: goldColor),
              ),
              child: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _watchAdForEssence(Map adStats) async {
    final List timestamps = adStats['timestamps'] as List? ?? [];
    final eightHoursAgo = DateTime.now().subtract(const Duration(hours: 8));
    final validRecent = timestamps.where((ts) => ts is Timestamp && ts.toDate().isAfter(eightHoursAgo)).toList();

    if (validRecent.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.essenceAdLimit('8h')))
      );
      return;
    }

    setState(() => _loadingAd = true);
    try {
      await _ai.watchAdForEssence();
    } finally {
      if (mounted) setState(() => _loadingAd = false);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: Colors.white10)),
      ],
    );
  }
}
