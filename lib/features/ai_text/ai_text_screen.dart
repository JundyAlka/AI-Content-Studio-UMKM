import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/ai_text_service.dart';
import '../../models/user_profile.dart'; // Stub - replace with provider
import '../../services/auth_service.dart'; // To get profile
import '../../widgets/app_button.dart';

class AiTextScreen extends ConsumerStatefulWidget {
  const AiTextScreen({super.key});

  @override
  ConsumerState<AiTextScreen> createState() => _AiTextScreenState();
}

class _AiTextScreenState extends ConsumerState<AiTextScreen> {
  final _productController = TextEditingController();
  final _hashtagController = TextEditingController();
  
  String? _selectedPurpose;
  final _purposes = ['Promo Diskon', 'Launching Produk', 'Edukasi', 'Testimoni', 'Reminder', 'Hiburan'];
  
  String? _selectedPlatform;
  final _platforms = ['Instagram Feed', 'Instagram Story', 'TikTok', 'WhatsApp', 'Facebook'];
  
  String _selectedTone = 'Santai';
  final _tones = ['Formal', 'Santai', 'Gen Z', 'Premium', 'Syar\'i', 'Lucu'];
  
  String _selectedLength = 'Sedang';
  final _lengths = ['Pendek', 'Sedang', 'Panjang'];

  bool _useEmoji = true;
  bool _isLoading = false;
  List<String> _results = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final mock = GoRouterState.of(context).uri.queryParameters['mock'] == 'true';
      if (mock && _results.isEmpty) {
        _productController.text = "Kopi Kenangan Mantan";
        _selectedPurpose = "Promo Diskon";
        _selectedPlatform = "Instagram Feed";
        _results = [
          "Siapa yang kangen mantan? 😢 Tenang, ada Kopi Kenangan Mantan yang siap nemenin kamu! Diskon 50% khusus hari ini. Yuk merapat! #KopiKenangan #Diskon #MoveOn",
          "Rasakan pahit manisnya kenangan dalam segelas Kopi Kenangan Mantan. ☕ Beli 1 Gratis 1! Buruan sebelum kehabisan kenangannya.",
          "Mantan boleh lupa, tapi rasa Kopi Kenangan Mantan gak bakal lupa! Promo spesial: Diskon 50% all item. 😉"
        ];
      }
    } catch (_) {}
  }

  Future<void> _generate() async {
    if (_productController.text.isEmpty || _selectedPurpose == null || _selectedPlatform == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon lengkapi form utama')));
      return;
    }

    setState(() {
      _isLoading = true;
      _results = [];
    });

    try {
      final authService = ref.read(authServiceProvider);
      final userProfile = authService.currentUser ?? UserProfile(
          uid: 'demo', email: 'demo@mail.com', businessName: 'Bisnis Demo', targetAudience: 'Umum');

      final service = ref.read(aiTextServiceProvider);
      // Simulate smarter generation with hashtags and emojis
      var promptProduct = _productController.text;
      if (_hashtagController.text.isNotEmpty) {
        promptProduct += " (Hashtags: ${_hashtagController.text})";
      }
      if (_useEmoji) {
        promptProduct += " (Gunakan Emoji)";
      }

      final captions = await service.generateCaptions(
        userProfile: userProfile,
        purpose: _selectedPurpose!,
        platform: _selectedPlatform!,
        productName: promptProduct,
        tone: _selectedTone,
        length: _selectedLength,
      );

      setState(() {
        _results = captions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Caption disalin!')));
  }

  void _shareToSocial(String platform) {
    // In a real app, use url_launcher to open the app
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Membuka $platform... (Simulasi)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Buat Caption AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/banner_ai_text.png',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPoweredByInfo(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Detail Konten'),
                  const SizedBox(height: 12),
                  _buildDetailForm(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Preferensi & Gaya'),
                  const SizedBox(height: 12),
                  _buildPreferenceForm(),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: AppButton(
                      label: 'Generate Caption Ajaib ✨',
                      icon: Icons.auto_awesome,
                      onPressed: _generate,
                      isLoading: _isLoading,
                    ),
                  ),
                  
                  if (_results.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Hasil Caption Kamu'),
                    const SizedBox(height: 16),
                    ..._results.map((caption) => _buildResultCard(caption)),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPoweredByInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.2), // Dark Blue background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Powered by Gemini & Stability AI. Ketik ide simpel, AI akan mempercantiknya!',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              decoration: _inputDecoration('Tujuan Konten', Icons.flag),
              items: _purposes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedPurpose = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              decoration: _inputDecoration('Platform Target', Icons.share),
              items: _platforms.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedPlatform = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productController,
              maxLines: 3,
              decoration: _inputDecoration('Produk / Topik Utama', Icons.topic).copyWith(
                hintText: 'Jelaskan produk atau topik yang ingin dibahas...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gaya Bahasa (Tone)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _tones.map((tone) {
                final isSelected = _selectedTone == tone;
                return ChoiceChip(
                  label: Text(tone),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _selectedTone = tone),
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hashtagController,
                    decoration: _inputDecoration('Hashtags (Opsional)', Icons.tag),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Gunakan Emoji Otomatis'),
              secondary: const Icon(Icons.emoji_emotions_outlined),
              value: _useEmoji,
              onChanged: (val) => setState(() => _useEmoji = val),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildResultCard(String caption) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text('Caption Generated', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SelectableText(caption, style: const TextStyle(fontSize: 15, height: 1.5)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.copy, 'Salin', () => _copyToClipboard(caption)),
                _actionButton(Icons.edit, 'Edit', () { /* TODO */ }),
                _actionButton(Icons.share, 'Share', () {
                   // Show share modal
                   showModalBottomSheet(
                     context: context, 
                     builder: (c) => Container(
                       padding: const EdgeInsets.all(24),
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           const Text('Bagikan ke Media Sosial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                           const SizedBox(height: 24),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               _socialButton('Instagram', Colors.purple, () => _shareToSocial('Instagram')),
                               _socialButton('TikTok', Colors.black, () => _shareToSocial('TikTok')),
                               _socialButton('Facebook', Colors.blue, () => _shareToSocial('Facebook')),
                             ],
                           )
                         ],
                       ),
                     )
                   );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
  
  Widget _socialButton(String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.share, color: color), // Placeholder icon, realistically use branding assets
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
