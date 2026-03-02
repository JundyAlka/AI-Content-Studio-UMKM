import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/stability_ai_service.dart';
import '../../services/gemini_service.dart';
import '../../services/auth_service.dart';
import '../../models/user_profile.dart';
import '../../widgets/app_button.dart';

class AiImageScreen extends ConsumerStatefulWidget {
  const AiImageScreen({super.key});

  @override
  ConsumerState<AiImageScreen> createState() => _AiImageScreenState();
}

class _AiImageScreenState extends ConsumerState<AiImageScreen> {
  final _promptController = TextEditingController();
  
  String _selectedType = 'Square Post (1:1)';
  final _types = ['Square Post (1:1)', 'Story (9:16)', 'Banner (16:9)'];
  
  String? _selectedPurpose;
  final _purposes = ['Promo Diskon', 'Pengumuman', 'Testimoni', 'Produk Showcase', 'Quotes'];
  
  String _selectedMood = 'Minimalis';
  final _moods = ['Minimalis', 'Playful/Ceria', 'Elegan/Mewah', 'Vintage', 'Futuristic', '3D Render'];

  bool _isLoading = false;
  String _loadingMessage = '';
  String? _resultImageBase64;
  double _creditBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
       final mock = GoRouterState.of(context).uri.queryParameters['mock'] == 'true';
       if (mock && _resultImageBase64 == null) {
         _promptController.text = "Secangkir kopi latte art dengan background cafe aesthetic, pencahayaan warm, 8k render.";
         _selectedPurpose = "Produk Showcase";
         _resultImageBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="; 
       }
    } catch (_) {}
  }

  Future<void> _fetchBalance() async {
    try {
      final balance = await ref.read(stabilityAiServiceProvider).getBalance();
      if (mounted) setState(() => _creditBalance = balance);
    } catch (e) {
      print('Failed to load credits: $e');
    }
  }

  Future<void> _generate() async {
    if (_promptController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jelaskan desain yang kamu inginkan')));
       return;
    }

    if (_creditBalance < 2) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credit tidak mencukupi (Butuh min. 2 credit)')));
       return;
    }

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Meracik prompt ajaib dengan Gemini AI... ✨';
      _resultImageBase64 = null;
    });

    try {
      // 0. Mock / Demo Logic Checks
      final lowerPrompt = _promptController.text.toLowerCase();
      if (lowerPrompt.contains('nasi goreng') || lowerPrompt.contains('es kopi')) {
        await Future.delayed(const Duration(seconds: 2)); // Fake loading delay
        
        String assetPath;
        if (lowerPrompt.contains('nasi goreng')) {
          assetPath = 'assets/images/mock_nasi_goreng.png';
        } else {
          assetPath = 'assets/images/mock_es_kopi.png';
        }

        final bytes = await DefaultAssetBundle.of(context).load(assetPath);
        final base64Image = base64Encode(bytes.buffer.asUint8List());

        setState(() {
          _resultImageBase64 = base64Image;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selesai! Gambar professional telah dibuat (Demo).')));
        return;
      }

      // 0. Get User Profile for Context
      final authState = ref.read(authStateProvider);
      final profile = authState.asData?.value ?? UserProfile(uid: 'guest', email: '', businessName: 'Restaurant 99', businessType: 'Makanan & Minuman');

      // 1. Optimize Prompt with Gemini
      final geminiService = ref.read(geminiServiceProvider);
      final enhancedPrompt = await geminiService.enhancePrompt(
        originalPrompt: _promptController.text,
        purpose: _selectedPurpose ?? 'General',
        mood: _selectedMood,
        businessName: profile.businessName,
        businessType: profile.businessType,
        businessDescription: profile.businessDescription,
      );

      // Show the enhanced prompt to the user
      if (mounted) {
        setState(() {
          _promptController.text = enhancedPrompt;
          _loadingMessage = 'Generating gambar (Stability AI)... 🎨';
        });
      }

      // 2. Generate Image with Stability AI
      String aspectRatio = '1:1';
      if (_selectedType.contains('16:9')) aspectRatio = '16:9';
      if (_selectedType.contains('9:16')) aspectRatio = '9:16';

      final service = ref.read(stabilityAiServiceProvider);
      final base64Image = await service.generateImage(
        prompt: enhancedPrompt,
        aspectRatio: aspectRatio,
        stylePreset: _selectedMood,
      );

      setState(() {
        _resultImageBase64 = base64Image;
      });
      
      _fetchBalance();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selesai! Gambar professional telah dibuat.')));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('Credits: ${_creditBalance.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Studio Desain AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/banner_ai_image.png',
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
                   Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3))
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(child: Text('Powered by Gemini & Stability AI. Ketik ide simpel, AI akan mempercantiknya!', style: TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Konsep Visual'),
                  const SizedBox(height: 12),
                  _buildConceptForm(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Format & Gaya'),
                  const SizedBox(height: 12),
                  _buildStyleForm(),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: AppButton(
                      label: _isLoading ? 'Sedang memproses...' : 'Generate Desain',
                      icon: Icons.palette,
                      onPressed: _generate,
                      isLoading: _isLoading,
                    ),
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_loadingMessage, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  
                  if (_resultImageBase64 != null) ...[
                     const SizedBox(height: 32),
                     _buildSectionTitle('Hasil Desain'),
                     const SizedBox(height: 16),
                     _buildResultCard(),
                  ]
                ],
              ),
            ),
          )
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

  Widget _buildConceptForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
               value: _selectedPurpose,
               decoration: _inputDecoration('Tujuan Visual', Icons.assignment),
               items: _purposes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
               onChanged: (v) => setState(() => _selectedPurpose = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _promptController,
              decoration: _inputDecoration('Deskripsi Visual (Prompt)', Icons.image).copyWith(
                hintText: 'Misal: Kopi latte hangat di meja kayu rustic, pencahayaan pagi yang lembut...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStyleForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text('Ukuran / Rasio', style: TextStyle(fontWeight: FontWeight.w600)),
             const SizedBox(height: 12),
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: _types.map((type) {
                   final isSelected = _selectedType == type;
                   IconData icon;
                   if (type.contains('1:1')) icon = Icons.square_outlined;
                   else if (type.contains('9:16')) icon = Icons.stay_current_portrait;
                   else icon = Icons.crop_landscape;
                   
                   return Padding(
                     padding: const EdgeInsets.only(right: 8),
                     child: ChoiceChip(
                       avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : null),
                       label: Text(type),
                       selected: isSelected,
                       onSelected: (selected) => setState(() => _selectedType = type),
                       selectedColor: Theme.of(context).primaryColor,
                       labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                     ),
                   );
                 }).toList(),
               ),
             ),
             const SizedBox(height: 20),
             const Text('Mood & Style', style: TextStyle(fontWeight: FontWeight.w600)),
             const SizedBox(height: 12),
             Wrap(
               spacing: 8,
               children: _moods.map((mood) {
                 final isSelected = _selectedMood == mood;
                 return ChoiceChip(
                   label: Text(mood),
                   selected: isSelected,
                   onSelected: (selected) => setState(() => _selectedMood = mood),
                   selectedColor: Theme.of(context).primaryColor,
                   labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                 );
               }).toList(),
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

  Widget _buildResultCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            width: double.infinity,
            child: Image.memory(
              base64Decode(_resultImageBase64!),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (){}, 
                    icon: const Icon(Icons.download), 
                    label: const Text('Download')
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (){}, 
                    icon: const Icon(Icons.share), 
                    label: const Text('Bagikan')
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
