import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecommendationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RecommendationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildAiAnalysisCard(context).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  _buildActionableSteps(context).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF1E1E2C),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'rec_img_${data['title']}',
              child: Image.asset(
                data['image'],
                fit: BoxFit.cover,
              ),
            ),
            Container( // Gradient overlay for text readability
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    const Color(0xFF1E1E2C).withOpacity(0.9), // Match scaffold dark theme if needed, or just black
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getTypeColor(data['type']).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getTypeColor(data['type']).withOpacity(0.5)),
          ),
          child: Text(
            data['type'],
            style: TextStyle(
              color: _getTypeColor(data['type']),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          data['title'],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data['desc'],
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAiAnalysisCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900.withOpacity(0.3), Colors.purple.shade900.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/ai_mascot.png', width: 24, height: 24, errorBuilder: (_,__,___) => const Icon(Icons.auto_awesome, color: Colors.blue)),
              const SizedBox(width: 12),
              const Text(
                'Mengapa ide ini bagus?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBenefitRow(Icons.check_circle_outline, 'Meningkatkan interaksi dengan pelanggan'),
          _buildBenefitRow(Icons.trending_up, 'Potensi viral tinggi di jam makan siang'),
          _buildBenefitRow(Icons.psychology, 'Membangun koneksi emosional brand'),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[300]))),
        ],
      ),
    );
  }

  Widget _buildActionableSteps(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Langkah Eksekusi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildStepItem(1, 'Siapkan foto makanan terbaikmu, pastikan pencahayaan cukup.'),
        _buildStepItem(2, 'Gunakan fitur AI Caption kami untuk membuat kata-kata menarik.'),
        _buildStepItem(3, 'Posting di Instagram Story dan Feed secara bersamaan.'),
      ],
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey[300], fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF0072FF).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Smart navigation based on type
            if (data['type'] == 'Visual' || data['image'].toString().contains('food')) {
               context.push('/dashboard/ai_image'); // Use push to allow back nav
            } else {
               context.push('/dashboard/ai_text');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: const Text('Buat Konten Sekarang', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Engagement': return Colors.orange;
      case 'Sales': return Colors.redAccent;
      case 'Value': return Colors.green;
      default: return Colors.blue;
    }
  }
}
