import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import '../../models/user_profile.dart';

class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Mock initial data - in real app query from provider
  final _businessNameController = TextEditingController(text: 'Warung Kopi Senja');
  final _descController = TextEditingController(text: 'Menyediakan kopi lokal terbaik dengan suasana nyaman.');
  final _audienceController = TextEditingController(text: 'Mahasiswa & Pekerja WFH');
  
  String? _selectedType = 'Makanan & Minuman';
  final List<String> _businessTypes = ['Makanan & Minuman', 'Fashion', 'Jasa', 'Elektronik', 'Kesehatan', 'Lainnya'];

  String? _selectedTone = 'Santai';
  final List<String> _tones = ['Formal', 'Santai', 'Lucu', 'Elegan', 'Syar\'i', 'Gen Z'];

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null || _selectedTone == null) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon lengkapi semua pilihan')),
        );
        return;
    }

    setState(() => _isLoading = true);

    try {
      final userProfile = UserProfile(
        uid: 'current-uid', // Should be fetched from auth
        email: 'user@example.com',
        businessName: _businessNameController.text,
        businessType: _selectedType!,
        brandTone: _selectedTone!,
        targetAudience: _audienceController.text,
        businessDescription: _descController.text,
        isOnboardingComplete: true,
      );

      final authService = ref.read(authServiceProvider);
      await authService.updateProfile(userProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil Bisnis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perbarui identitas bisnismu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Perubahan akan mempengaruhi gaya konten AI selanjutnya.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Bisnis / Brand',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.store),
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Jenis Usaha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _businessTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedTone,
                decoration: InputDecoration(
                  labelText: 'Tone / Gaya Bahasa',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.record_voice_over),
                ),
                items: _tones.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedTone = v),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _audienceController,
                decoration: InputDecoration(
                  labelText: 'Target Audiens',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.people),
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Singkat Bisnis',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Simpan Perubahan',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
