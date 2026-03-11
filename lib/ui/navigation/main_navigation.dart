import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../l10n/app_localizations.dart';
import '../profile/profile_summary_screen.dart';
import '../profile/profile_input_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const ProfileSummaryScreen(),
    const _PlaceholderTab(textKey: 'communitySoon'),
    const _PlaceholderTab(textKey: 'compareSoon'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Cor Cosmic
    const cosmicBg = Color(0xFF0F0B1E);
    const goldColor = Color(0xFFE6B325);

    return Scaffold(
      backgroundColor: cosmicBg,
      appBar: AppBar(
        backgroundColor: cosmicBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: _currentIndex == 0 ? const _CosmicDNABadge() : Text(_currentIndex == 1 ? l10n.tabCommunity : l10n.tabCompare, style: const TextStyle(color: Colors.white)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A162B),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0F0B1E)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E1E4F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/icon/icon.png', width: 44),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerTile(Icons.edit_outlined, l10n.editProfile, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInputScreen()));
                  }),
                  
                  const Divider(color: Colors.white10),
                  
                  // Novos Menus solicitados
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(Icons.auto_awesome, color: goldColor),
                      title: Text(l10n.menuCosmicDNA, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      children: [
                        _subTile(l10n.menuHumanDesign),
                        _subTile(l10n.menuAstrology),
                        _subTile(l10n.menuNumerology),
                        _subTile(l10n.menuChineseSign),
                      ],
                    ),
                  ),
                  
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(Icons.favorite_border, color: goldColor),
                      title: Text(l10n.menuBondConnections, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      children: [
                        _subTile(l10n.menuFriendship),
                        _subTile(l10n.menuCasualMeetings),
                        _subTile(l10n.menuPartnerForLife),
                      ],
                    ),
                  ),

                  _drawerTile(Icons.tips_and_updates, l10n.menuRelateBetter, () {}, color: Colors.white),

                  const Divider(color: Colors.white10),

                  _drawerTile(Icons.description_outlined, l10n.termsTitle, () {
                    Navigator.pop(context);
                    launchUrl(Uri.parse('https://humanmatch.app/Privacy-policy/'), mode: LaunchMode.externalApplication);
                  }),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            _drawerTile(Icons.logout, l10n.logout, () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            }, color: Colors.redAccent),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        backgroundColor: const Color(0xFF120E22),
        selectedItemColor: goldColor,
        unselectedItemColor: Colors.white38,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: l10n.tabProfile),
          BottomNavigationBarItem(icon: const Icon(Icons.people_outline), activeIcon: const Icon(Icons.people), label: l10n.tabCommunity),
          BottomNavigationBarItem(icon: const Icon(Icons.compare_arrows), activeIcon: const Icon(Icons.compare_arrows), label: l10n.tabCompare),
        ],
      ),
    );
  }

  Widget _subTile(String label) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72),
      title: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
      onTap: () {},
    );
  }

  Widget _drawerTile(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(label, style: TextStyle(color: color ?? Colors.white70, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

class _CosmicDNABadge extends StatelessWidget {
  const _CosmicDNABadge();
  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: goldColor, width: 1.2),
        color: goldColor.withOpacity(0.05),
      ),
      child: const Text(
        'DISCOVER YOUR COSMIC DNA',
        style: TextStyle(color: goldColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.4),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String textKey;
  const _PlaceholderTab({required this.textKey});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String getMsg() {
      if (textKey == 'communitySoon') return l10n.communitySoon;
      if (textKey == 'compareSoon') return l10n.compareSoon;
      return '';
    }
    return Container(
      color: const Color(0xFF0F0B1E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/compare.png', width: 250, color: Colors.white10, colorBlendMode: BlendMode.modulate),
            const SizedBox(height: 24),
            Text('${getMsg()}\n(${l10n.soonMessage})', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
