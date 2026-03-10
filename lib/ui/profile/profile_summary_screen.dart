import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../calc/numerology.dart';
import '../../hd/human_design_section.dart';
import '../../ai_actions.dart';
import '../../utils/astro_utils.dart';
import '../../utils/astro_data_utils.dart';
import '../loading_widget.dart';
import '../widgets/common_ui.dart';

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({super.key});
  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  late AiActions _ai;

  bool _loadingInsights = false;
  bool _loadingTip = false;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userStream;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _insightsStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _tipsStream;

  @override
  void initState() {
    super.initState();
    _ai = AiActions(context: context);
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      _userStream = userRef.snapshots();
      _insightsStream = userRef.collection('aiInsights').doc('latest').snapshots();
      _tipsStream = userRef.collection('dailyTips')
          .orderBy('dateKey', descending: true)
          .limit(1)
          .snapshots();
    }
  }

  String _formatDateStr(String? key, String defaultTitle) {
    if (key == null || !key.contains('-')) return defaultTitle;
    final parts = key.split('-');
    if (parts.length != 3) return key;
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  Widget _sectionHeader(String title, {bool isFirst = false}) {
    return Padding(
      padding: EdgeInsets.only(left: 12, bottom: 8, top: isFirst ? 4 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE6B325),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebAppStoreButtons(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.onlyMobile,
          style: const TextStyle(color: Color(0xFFE6B325), fontWeight: FontWeight.bold, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.downloadApp,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.opinto.humanmatch')),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg',
                  height: 36,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white24)),
                    child: const Text('Google Play', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('https://apps.apple.com/app/human-match/id6740638510')),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg',
                  height: 36,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white24)),
                    child: const Text('App Store', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Not logged in', style: TextStyle(color: Colors.white)));

    final l10n = AppLocalizations.of(context)!;
    const goldColor = Color(0xFFE6B325);

    final mainButtonStyle = FilledButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.05),
      foregroundColor: goldColor,
      side: BorderSide(color: goldColor.withOpacity(0.4)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );

    return Container(
      color: const Color(0xFF0F0B1E),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userStream,
        builder: (context, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting && !userSnap.hasData) {
            return const Center(child: LoadingWidget());
          }

          final u = userSnap.data?.data() ?? {};
          final hdBase = (u['humanDesignBase'] as Map?)?.cast<String, dynamic>();
          final astro = (u['astro'] as Map?)?.cast<String, dynamic>() ?? {};

          // Helper to get sign name from stored map or compute if missing
          String getSign(dynamic data, String? fallback) {
            if (data is Map && data['sign'] != null) return data['sign'];
            if (fallback != null) return fallback;
            return '—';
          }

          final sunSign = AstroDataUtils.localizeSignName(context, getSign(astro['sun'], astro['sunSign']));
          final moonSign = AstroDataUtils.localizeSignName(context, getSign(astro['moon'], null));
          final mercurySign = AstroDataUtils.localizeSignName(context, getSign(astro['mercury'], null));
          final venusSign = AstroDataUtils.localizeSignName(context, getSign(astro['venus'], null));
          final marsSign = AstroDataUtils.localizeSignName(context, getSign(astro['mars'], null));
          final jupiterSign = AstroDataUtils.localizeSignName(context, getSign(astro['jupiter'], null));
          final saturnSign = AstroDataUtils.localizeSignName(context, getSign(astro['saturn'], null));
          final uranusSign = AstroDataUtils.localizeSignName(context, getSign(astro['uranus'], null));
          final neptuneSign = AstroDataUtils.localizeSignName(context, getSign(astro['neptune'], null));
          final plutoSign = AstroDataUtils.localizeSignName(context, getSign(astro['pluto'], null));
          final ascSign = AstroDataUtils.localizeSignName(context, astro['ascSign'] ?? astro['ascendantSign'] ?? '—');
          final mcSign = AstroDataUtils.localizeSignName(context, astro['mcSign'] ?? '—');
          final northNodeSign = AstroDataUtils.localizeSignName(context, getSign(astro['northNode'], null));
          final southNodeSign = AstroDataUtils.localizeSignName(context, getSign(astro['southNode'], null));
          
          final housesList = (astro['houses'] as List?)?.cast<num>();
          final aspectsList = (astro['aspects'] as List?)?.cast<Map>();

          final storedNum = u['numerology'] as Map?;
          final numerology = storedNum != null ? NumerologyResult(lifePath: storedNum['lifePath'], expression: storedNum['expression'], soul: storedNum['soul'], personality: storedNum['personality']) : null;

          return ListView(
            key: const PageStorageKey('profile_summary_list'),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            children: [
              _sectionHeader(l10n.hdTitle, isFirst: true),
              PrimaryCard(
                child: hdBase == null ? Text(l10n.hdCalculating, style: const TextStyle(color: Colors.white70)) : HumanDesignSection(hd: hdBase),
              ),
              const SizedBox(height: 12),
              
              _sectionHeader(l10n.astroTitle),
              PrimaryCard(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- BIG 3 ---
                      Text(l10n.astroBig3, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _AstroIndicatorsTable(
                        items: [
                          {'key': 'sun', 'label': l10n.zodiacSign, 'value': sunSign, 'symbol': '☉'},
                          {'key': 'moon', 'label': l10n.astroMoonSign, 'value': moonSign, 'symbol': '☾'},
                          {'key': 'ascendant', 'label': l10n.ascendant, 'value': ascSign, 'symbol': '⬆️'},
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),

                      // --- PLANETAS PESSOAIS ---
                      Text(l10n.astroPersonalPlanets, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _AstroIndicatorsTable(
                        items: [
                          {'key': 'mercury', 'label': l10n.astroMercurySign, 'value': mercurySign, 'symbol': '☿'},
                          {'key': 'venus', 'label': l10n.astroVenusSign, 'value': venusSign, 'symbol': '♀'},
                          {'key': 'mars', 'label': l10n.astroMarsSign, 'value': marsSign, 'symbol': '♂'},
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),

                      // --- PLANETAS SOCIAIS E GERACIONAIS ---
                      Text(l10n.astroSocialGenerationalPlanets, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _AstroRow(symbol: '♃', label: l10n.hdPlanetJupiter, value: jupiterSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '♄', label: l10n.hdPlanetSaturn, value: saturnSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '♅', label: l10n.hdPlanetUranus, value: uranusSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '♆', label: l10n.hdPlanetNeptune, value: neptuneSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '♇', label: l10n.hdPlanetPluto, value: plutoSign),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),

                      // --- MC E NODOS LUNARES ---
                      Text(l10n.astroMCNodes, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      _AstroRow(symbol: '🎯', label: l10n.astroMC, value: mcSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '☊', label: l10n.astroNorthNode, value: northNodeSign),
                      const SizedBox(height: 10),
                      _AstroRow(symbol: '☋', label: l10n.astroSouthNode, value: southNodeSign),
                      
                      if (housesList != null && housesList.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.home_outlined, color: goldColor, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.astroHouses, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: housesList.length,
                          itemBuilder: (context, index) {
                            final houseNum = index + 1;
                            final sign = getZodiacSign(context, housesList[index].toDouble());
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '$houseNum',
                                    style: const TextStyle(color: goldColor, fontWeight: FontWeight.w900, fontSize: 11),
                                  ),
                                  const VerticalDivider(color: Colors.white12, indent: 4, endIndent: 4, width: 16),
                                  Expanded(
                                    child: Text(
                                      sign,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],

                      if (aspectsList != null && aspectsList.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.link, color: goldColor, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.astroAspects, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: aspectsList.map((a) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      a['p1Name'].toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      a['type'].toString(),
                                      style: const TextStyle(color: goldColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      a['p2Name'].toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _sectionHeader(l10n.numTitle),
              PrimaryCard(
                child: numerology == null ? const Text('—', style: TextStyle(color: Colors.white70)) :
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        KeyValueRow(icon: Icons.tag_outlined, label: l10n.lifePath, value: numerology.lifePath.toString()),
                        const SizedBox(height: 10),
                        KeyValueRow(icon: Icons.tag_outlined, label: l10n.expression, value: numerology.expression.toString()),
                        const SizedBox(height: 10),
                        KeyValueRow(icon: Icons.tag_outlined, label: l10n.soul, value: numerology.soul.toString()),
                        const SizedBox(height: 10),
                        KeyValueRow(icon: Icons.tag_outlined, label: l10n.personality, value: numerology.personality.toString()),
                      ],
                    ),
                  ),
              ),
              const SizedBox(height: 12),

              _sectionHeader(l10n.profileInsights),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _insightsStream,
                builder: (context, insSnap) {
                  final isLoading = _loadingInsights || (insSnap.connectionState == ConnectionState.waiting && !insSnap.hasData);
                  final ins = insSnap.data?.data();
                  final exists = insSnap.data?.exists ?? false;

                  Widget inner;
                  if (!exists) {
                    inner = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.noInsights, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 12),
                        if (kIsWeb)
                          _buildWebAppStoreButtons(l10n)
                        else
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: mainButtonStyle,
                              onPressed: isLoading ? null : () async {
                                setState(() => _loadingInsights = true);
                                await _ai.runInsightsBehindRewardedAd();
                                if (mounted) setState(() => _loadingInsights = false);
                              },
                              icon: const Icon(Icons.auto_awesome_outlined),
                              label: Text(l10n.generateInsights.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                  } else {
                    final data = ins ?? {};
                    inner = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            if (kIsWeb)
                              const SizedBox.shrink()
                            else
                              TextButton.icon(
                                onPressed: isLoading ? null : () async {
                                  setState(() => _loadingInsights = true);
                                  await _ai.runInsightsBehindRewardedAd();
                                  if (mounted) setState(() => _loadingInsights = false);
                                },
                                icon: const Icon(Icons.auto_awesome_outlined, color: goldColor),
                                label: Text(l10n.update, style: const TextStyle(color: goldColor)),
                              ),
                          ],
                        ),
                        Text(data['summary']?.toString() ?? '—', style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 12),
                        Text(l10n.profilePillars, style: const TextStyle(fontWeight: FontWeight.w900, color: goldColor)),
                        _bullets(data['insights'] ?? []),
                        if (kIsWeb) ...[
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white12),
                          _buildWebAppStoreButtons(l10n),
                        ],
                      ],
                    );
                  }

                  return PrimaryCard(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(opacity: isLoading ? 0.4 : 1.0, child: inner),
                        if (isLoading) const LoadingWidget(),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _sectionHeader(l10n.dailyTip),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _tipsStream,
                builder: (context, tipsSnap) {
                  final isLoading = _loadingTip || (tipsSnap.connectionState == ConnectionState.waiting && !tipsSnap.hasData);

                  final tips = tipsSnap.data?.docs ?? [];
                  final hasTodayTip = tips.isNotEmpty && tips.first.id == _ai.todayKeyLocal();
                  final lastTipDoc = tips.isNotEmpty ? tips.first : null;
                  final lastTipData = lastTipDoc?.data() ?? {};

                  final formattedDate = lastTipDoc != null
                      ? _formatDateStr(lastTipDoc.id, l10n.dailyTip)
                      : _formatDateStr(_ai.todayKeyLocal(), l10n.dailyTip);

                  final inner = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w900, color: goldColor)),
                      const SizedBox(height: 8),

                      if (!hasTodayTip) ...[
                        if (kIsWeb)
                          _buildWebAppStoreButtons(l10n)
                        else
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: mainButtonStyle,
                              onPressed: isLoading ? null : () async {
                                setState(() => _loadingTip = true);
                                await _ai.runTipsBehindRewardedAd();
                                if (mounted) setState(() => _loadingTip = false);
                              },
                              icon: const Icon(Icons.auto_awesome_outlined),
                              label: Text(l10n.getDailyTip.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        const SizedBox(height: 14),
                      ],

                      if (lastTipDoc != null)
                        Text(lastTipData['text']?.toString() ?? '—', style: const TextStyle(color: Colors.white)),
                      
                      if (hasTodayTip && kIsWeb) ...[
                         const SizedBox(height: 16),
                         const Divider(color: Colors.white12),
                         _buildWebAppStoreButtons(l10n),
                      ],
                    ],
                  );

                  return PrimaryCard(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(opacity: isLoading ? 0.4 : 1.0, child: inner),
                        if (isLoading) const LoadingWidget(),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _bullets(List items) {
    if (items.isEmpty) return const Text('—', style: TextStyle(color: Colors.white70));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('• ', style: TextStyle(color: Color(0xFFE6B325))), Expanded(child: Text(t.toString(), style: const TextStyle(color: Colors.white)))]))).toList(),
    );
  }
}

class _AstroRow extends StatelessWidget {
  const _AstroRow({required this.symbol, required this.label, required this.value});
  final String symbol;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    );
    final valueStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(symbol, style: const TextStyle(fontSize: 18, color: goldColor), textAlign: TextAlign.center),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: labelStyle)),
            ],
          ),
        ),
        Expanded(
          flex: 1,
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

class _AstroIndicatorsTable extends StatelessWidget {
  const _AstroIndicatorsTable({required this.items});
  final List<Map<String, String>> items;

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);

    return Column(
      children: items.map((item) {
        final desc = AstroDataUtils.getAstroDescription(context, item['key']!);
        final valDesc = AstroDataUtils.getAstroValueDescription(context, item['value']!);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(item['symbol']!, style: const TextStyle(fontSize: 18, color: goldColor), textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 8),
                  Text(item['label']!, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(item['value']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: goldColor, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
              if (valDesc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(valDesc, style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
