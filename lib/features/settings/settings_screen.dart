import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  bool _isNotifEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Pengaturan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/banner_settings.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSectionHeader('Akun Bisnis'),
                      _buildSectionCard(context, [
                        _buildSettingsTile(
                            context,
                            Icons.storefront,
                            'Profil Usaha',
                            'Atur informasi bisnis & logo',
                            () => context.go('/settings/business_profile')
                        ),
                        const Divider(height: 1),
                        _buildSettingsTile(
                             context,
                             Icons.star_border,
                             'Langganan Premium',
                             'Upgrade fitur AI unlimited',
                             () => _showPremiumModal(context)
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                      _buildSectionHeader('Integrasi Sosial Media'),
                      _buildSectionCard(context, [
                        _buildSettingsTile(
                            context,
                            Icons.camera_alt,
                            'Instagram',
                            'Terhubung sebagai @demo_user',
                            () {},
                            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20)
                        ),
                        const Divider(height: 1),
                        _buildSettingsTile(
                            context,
                            Icons.music_note,
                            'TikTok',
                            'Belum terhubung',
                            () => _showConnectDialog('TikTok'),
                            trailing: TextButton(onPressed: () => _showConnectDialog('TikTok'), child: const Text('Hubungkan'))
                        ),
                        const Divider(height: 1),
                        _buildSettingsTile(
                            context,
                            Icons.facebook,
                            'Facebook Page',
                            'Belum terhubung',
                            () => _showConnectDialog('Facebook'),
                             trailing: TextButton(onPressed: () => _showConnectDialog('Facebook'), child: const Text('Hubungkan'))
                        ),
                      ]),

                      const SizedBox(height: 24),
                      _buildSectionHeader('Preferensi Aplikasi'),
                      _buildSectionCard(context, [
                        _buildSettingsTile(
                           context,
                           Icons.dark_mode,
                           'Mode Gelap',
                           'Tampilan nyaman di mata',
                           null,
                           trailing: Switch(
                             value: Theme.of(context).brightness == Brightness.dark, 
                             onChanged: (v) {
                               ref.read(themeModeProvider.notifier).toggleTheme(v);
                             }
                           )
                        ),
                        const Divider(height: 1),
                        _buildSettingsTile(
                           context,
                           Icons.language,
                           'Bahasa',
                           'Indonesia (ID)',
                           () {}
                        ),
                         const Divider(height: 1),
                        _buildSettingsTile(
                           context,
                           Icons.notifications_active,
                           'Notifikasi',
                           'Jadwal post & promo',
                           null,
                           trailing: Switch(
                             value: _isNotifEnabled, 
                             onChanged: (v) => setState(() => _isNotifEnabled = v)
                           )
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                       _buildSectionCard(context, [
                         _buildSettingsTile(
                           context,
                           Icons.logout,
                           'Keluar',
                           '',
                           () async {
                             await ref.read(authServiceProvider).signOut();
                             if (context.mounted) {
                               context.go('/login');
                             }
                           },
                           isDestructive: true
                         )
                       ]),
                       const SizedBox(height: 48),
                       const Text('Versi 1.0.0 (Beta)', style: TextStyle(color: Colors.grey)),
                       const SizedBox(height: 16),
                    ],
                  ),
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback? onTap, {Widget? trailing, bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : Theme.of(context).primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : null)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showConnectDialog(String platform) {
    showDialog(
      context: context, 
      builder: (c) => AlertDialog(
        title: Text('Hubungkan $platform'),
        content: Text('Anda akan dialihkan ke halaman login $platform untuk memberikan izin akses posting.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menghubungkan $platform (Simulasi)')));
            }, 
            child: const Text('Lanjutkan')
          ),
        ],
      )
    );
  }

  void _showPremiumModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                   Positioned(
                     right: -20, top: -20,
                     child: Icon(Icons.star, size: 150, color: Colors.white.withOpacity(0.2))
                   ),
                   const Padding(
                     padding: EdgeInsets.all(24),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.end,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('PRO PLAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                         Text('Unlimited Power.', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                       ],
                     ),
                   ),
                   Positioned(
                     top: 16, right: 16,
                     child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))
                   )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _benefitItem(Icons.bolt, 'Unlimited AI Generations', 'Buat konten tanpa batas harian'),
                  _benefitItem(Icons.speed, 'Fast Processing', 'Prioritas antrian server'),
                  _benefitItem(Icons.hd, 'HD Image Downloads', 'Resolusi gambar 4K untuk cetak'),
                  _benefitItem(Icons.auto_fix_high, 'Remove Watermarks', 'Hapus watermark otomatis'),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {}, 
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.purple
                    ),
                    child: const Text('Langganan Sekarang - Rp 49.000/bln', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                  TextButton(onPressed: (){}, child: const Text('Pulihkan Pembelian'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.purple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
