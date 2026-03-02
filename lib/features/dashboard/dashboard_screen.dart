import 'dart:async'; // Add this for Timer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/auth_service.dart';
import '../../models/user_profile.dart';
import '../../models/content_item.dart';
import './widgets/analytics_section.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late List<ContentItem> _recentItems;
  late PageController _pageController;
  late ScrollController _recController;
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _recentItems =
        List.generate(3, (index) => ContentItem.demo(index.toString()));
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
    _recController = ScrollController();

    // Auto Scroll Recommendation
    _recController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_pageController.page?.round() ?? 0) + 1;
          if (nextPage > 1) nextPage = 0;
          _pageController.animateToPage(nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }

        if (_recController.hasClients) {
          final maxScroll = _recController.position.maxScrollExtent;
          final currentScroll = _recController.offset;
          double target = currentScroll + 240.0;
          if (target > maxScroll) target = 0;
          _recController.animateTo(target,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut);
        }
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    _recController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (userProfile) {
        // Fallback if null (shouldn't happen in authenticated route)
        final profile = userProfile ??
            UserProfile(
                uid: 'guest',
                email: '',
                businessName: 'Tamu',
                businessType: 'Umum');

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, ${profile.businessName} 👋',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(_getCategoryIcon(profile.businessType),
                        size: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color),
                    const SizedBox(width: 4),
                    Text(profile.businessType,
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: _showNotifications,
              ),
              IconButton(
                icon: const Icon(Icons.diamond_outlined, color: Colors.amber),
                onPressed: () => _showPremiumModal(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Banner
                _buildHeroBanner(context)
                    .animate()
                    .fade(duration: 600.ms)
                    .slideY(begin: -0.1, end: 0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // 2. Main Stats
                      _buildStatsCard(context)
                          .animate()
                          .fade(delay: 200.ms)
                          .scale(),

                      const SizedBox(height: 24),
                      const AnalyticsSection()
                          .animate()
                          .fade(delay: 250.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),
                      const Text(
                        'Rekomendasi Hari Ini 🔥',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ).animate().fade(delay: 300.ms),
                      const Text(
                        'Ide konten siap pakai, tinggal sesuaikan!',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),

                      // 3. Daily Recommendations (Horizontal List)
                      _buildDailyRecommendations(context)
                          .animate()
                          .fade(delay: 400.ms)
                          .slideX(),

                      const SizedBox(height: 24),
                      const Text(
                        'Tools Kreator',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ).animate().fade(delay: 500.ms),
                      const SizedBox(height: 12),

                      // 4. Shortcuts Grid
                      _buildShortcuts(context).animate().fade(delay: 600.ms),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Konten Terakhir',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => context.go('/library'),
                            child: const Text('Lihat Semua'),
                          ),
                        ],
                      ).animate().fade(delay: 700.ms),
                      const SizedBox(height: 8),

                      // 5. Recent List
                      _buildRecentList().animate().fade(delay: 800.ms),

                      const SizedBox(height: 24),
                      // 6. Education / Tips Section
                      _buildEducationSection(context)
                          .animate()
                          .fade(delay: 900.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) =>
          Scaffold(body: Center(child: Text('Error load profile: $e'))),
    );
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'Makanan & Minuman':
        return Icons.restaurant;
      case 'Fashion':
        return Icons.checkroom;
      case 'Jasa':
        return Icons.work;
      case 'Elektronik':
        return Icons.electrical_services;
      case 'Kesehatan':
        return Icons.health_and_safety;
      default:
        return Icons.store;
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Notifikasi',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _notifItem(
                    'Jadwal Post',
                    'Konten "Promo Imlek" dijadwalkan besok jam 10:00.',
                    Icons.calendar_today,
                    Colors.blue),
                _notifItem('Tips', 'Cek tren musik TikTok terbaru minggu ini!',
                    Icons.lightbulb, Colors.orange),
                _notifItem('System', 'Selamat datang di versi Beta!',
                    Icons.info, Colors.grey),
              ],
            ));
  }

  Widget _notifItem(String title, String body, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(body, style: const TextStyle(fontSize: 12)),
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
                gradient: LinearGradient(colors: [
                  Colors.amber,
                  Colors.orangeAccent
                ]), // Gold gradient for dashboard
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(Icons.diamond,
                          size: 150, color: Colors.white.withOpacity(0.2))),
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PREMIUM',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2)),
                        Text('Unlock Everything.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context)))
                ],
              ),
            ),
            // ... (Rest of content similar to settings, strictly visual for now)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _benefitItem(
                      Icons.auto_awesome,
                      'Unlimited AI Content',
                      'Buat caption & gambar tanpa batas harian.',
                      Colors.purple),
                  _benefitItem(Icons.water_drop_outlined, 'Hapus Watermark',
                      'Hasil export bersih tanpa logo aplikasi.', Colors.blue),
                  _benefitItem(Icons.schedule, 'Smart Scheduler',
                      'Posting otomatis di jam audiens aktif.', Colors.orange),
                  _benefitItem(Icons.analytics, 'Analytics Pro',
                      'Lihat performa konten detail & insight.', Colors.green),
                  _benefitItem(Icons.star, 'Template Premium',
                      'Akes desain eksklusif para pro.', Colors.pink),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.amber.withOpacity(0.1)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Langganan Bulanan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Rp 49.000',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.amber)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Pembayaran berhasil! (Simulasi)')));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text('Upgrade Pro Sekarang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                      child: Text('Syarat & Ketentuan berlaku',
                          style: TextStyle(fontSize: 10, color: Colors.grey))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        padEnds: false,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        children: [
          _BannerCard(
            imagePath: 'assets/images/banner_sales.png',
            title: 'Tingkatkan Penjualan!',
            subtitle: 'Gunakan AI untuk membuat caption promo Imlek.',
            onTap: () {},
          ),
          _BannerCard(
            imagePath: 'assets/images/banner_design.png',
            title: 'Desain Story Baru',
            subtitle: 'Template story kekinian sudah tersedia.',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRecommendations(BuildContext context) {
    final ideas = [
      {
        'title': 'Sapa Follower',
        'type': 'Engagement',
        'desc': 'Tanya kabar dan suasana hati followers.',
        'image': 'assets/images/card_engagement.png'
      },
      {
        'title': 'Promo Flash Sale',
        'type': 'Sales',
        'desc': 'Diskon 50% hanya untuk 2 jam.',
        'image': 'assets/images/card_sales.png'
      },
      {
        'title': 'Edukasi Produk',
        'type': 'Value',
        'desc': 'Jelaskan manfaat bahan utama produkmu.',
        'image': 'assets/images/card_value.png'
      },
    ];

    return SizedBox(
      height: 280, // Increased height to prevent layout clipping
      child: ListView.separated(
        controller: _recController,
        scrollDirection: Axis.horizontal,
        itemCount: ideas.length,
        padding: const EdgeInsets.only(bottom: 8), // Add padding for shadow
        separatorBuilder: (c, i) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final idea = ideas[index];
          return Container(
            width: 220,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.push('/dashboard/recommendation', extra: idea);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Header
                    SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Image.asset(
                            idea['image']!,
                            width: double.infinity,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                Container(color: Colors.grey.shade300),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Text(
                                idea['type']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Body
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              idea['title']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              idea['desc']!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.7)
                                ]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push('/dashboard/recommendation',
                                      extra: idea);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text('Buat Sekarang',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.2),
      color:
          isDark ? const Color(0xFF2C2C2C) : theme.colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total Konten',
                '12',
                onTap: () => context.go('/library'),
              ),
            ),
            VerticalDivider(
                width: 1, color: theme.dividerColor, indent: 12, endIndent: 12),
            Expanded(
              child: _buildStatItem(
                'Terjadwal',
                '3',
                onTap: () => context.go('/schedule'),
              ),
            ),
            VerticalDivider(
                width: 1, color: theme.dividerColor, indent: 12, endIndent: 12),
            Expanded(
              child: _buildStatItem(
                'Draft',
                '5',
                onTap: () => context.go('/library'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcuts(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ShortcutCard(
            label: 'Buat Caption',
            icon: Icons.auto_awesome, // More modern icon
            imagePath: 'assets/images/tool_caption.png',
            onTap: () => context.push('/dashboard/ai_text'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ShortcutCard(
            label: 'Desain AI',
            icon: Icons.palette_outlined, // More modern icon
            imagePath: 'assets/images/tool_design.png',
            onTap: () => context.push('/dashboard/ai_image'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentList() {
    // Mock images using the newly generated assets
    final images = [
      'assets/images/thumb_food.png',
      'assets/images/thumb_drink.png',
      'assets/images/thumb_food.png', // Replaced fashion with food
    ];

    // Improved titles matching the images
    final titles = [
      'Paket Dimsum Spesial Imlek',
      'Menu Baru: Iced Coffee Gula Aren',
      'Promo Makan Siang Hemat',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentItems.length,
      itemBuilder: (context, index) {
        final item = _recentItems[index];
        // Cycle through images if we have more items than images
        final imagePath = images[index % images.length];
        final title = titles[index % titles.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navigate to detail
                context.go('/library/detail', extra: item);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              // Gradient Icon
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.blue.shade400,
                                      Colors.purple.shade400
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: Icon(
                                  item.type == ContentType.text
                                      ? Icons.article_outlined
                                      : Icons.image_outlined,
                                  size: 16,
                                  color: Colors
                                      .white, // Color must be white for ShaderMask to work
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.platform.name} • ${item.createdAt.day}/${item.createdAt.month}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.2)
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_forward_ios,
                          size: 12, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2C3E50),
              const Color(0xFF4CA1AF)
            ], // Premium teal-dark gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF4CA1AF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6))
          ]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb,
                color: Colors.amberAccent, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tips Sukses',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16)),
              SizedBox(height: 4),
              Text(
                'Posting minimal 3x seminggu meningkatkan engagement sebesar 40%.',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _benefitItem(
      IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BannerCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String imagePath;
  final VoidCallback onTap;

  const _ShortcutCard({
    required this.label,
    required this.icon,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 140, // Increased height for better visual
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.white70, size: 14)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
