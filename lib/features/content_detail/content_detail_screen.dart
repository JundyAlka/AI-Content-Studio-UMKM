import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/content_item.dart';

class ContentDetailScreen extends StatelessWidget {
  final ContentItem item;

  const ContentDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTitleSection(context),
              _buildPlatformPreview(context),
              _buildAiInsights(context),
              _buildActionButtons(context),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: item.imageUrl != null ? 300.0 : 120.0,
      pinned: true,
      leading: IconButton(
        icon: const ContainerWithBackground(child: Icon(Icons.arrow_back, color: Colors.white)),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const ContainerWithBackground(child: Icon(Icons.edit, color: Colors.white)),
          onPressed: () {
            // Mock Edit Action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Masuk ke mode edit...')),
            );
          },
        ),
        IconButton(
          icon: const ContainerWithBackground(child: Icon(Icons.more_vert, color: Colors.white)),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: item.imageUrl != null
            ? (item.imageUrl!.startsWith('http')
                ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                : Image.asset(item.imageUrl!, fit: BoxFit.cover))
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    item.type == ContentType.text ? Icons.article : Icons.image,
                    size: 64,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getPlatformColor(item.platform).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(_getPlatformIcon(item.platform), size: 14, color: _getPlatformColor(item.platform)),
                    const SizedBox(width: 6),
                    Text(
                      item.platform.name,
                      style: TextStyle(
                        color: _getPlatformColor(item.platform),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM yyyy • HH:mm').format(item.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformPreview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getPlatformIcon(item.platform), size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Preview Konten', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),

          
          // Post Image
          if (item.type == ContentType.image && item.imageUrl != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              height: 250, // Square-ish aspect ratio for feed
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: item.imageUrl!.startsWith('http') 
                      ? NetworkImage(item.imageUrl!) 
                      : AssetImage(item.imageUrl!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Text(
            item.body,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 8),
          // Hashtags mock - extracted from body or fixed
          Text(
             '#Restaurant99 #KulinerEnak #PromoSpesial',
             style: TextStyle(color: Colors.blue[800], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsights(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_analisis.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    // Main Icon / Image
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/icon_analisis.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Analisis AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent.shade700,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
                        ]
                      ),
                      child: const Text('Excellent', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                _buildInsightRow(Icons.mood, 'Sentimen', 'Positif & Antusias', isDark: true),
                _buildInsightRow(Icons.offline_bolt, 'Power Words', 'Promo, Spesial, Terbatas', isDark: true),
                _buildInsightRow(Icons.access_time_filled, 'Waktu Post', '12:00 - 13:00 WIB', isDark: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String label, String value, {bool isDark = false}) {
    final textColor = isDark ? Colors.white : Colors.grey[600]!;
    final valueColor = isDark ? Colors.white.withOpacity(0.9) : Colors.black;
    final iconColor = isDark ? Colors.white70 : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCircleAction(context, Icons.copy, 'Copy', () {
            Clipboard.setData(ClipboardData(text: item.body));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Caption disalin!')));
          }),
          _buildCircleAction(context, Icons.share, 'Share', () => _handleShare(context)),
          _buildCircleAction(context, Icons.schedule, 'Jadwal', () => _handleSchedule(context)),
          _buildCircleAction(context, Icons.delete, 'Hapus', () => _handleDelete(context), isDestructive: true),
        ],
      ),
    );
  }

  void _handleShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bagikan Konten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _shareOption(context, Icons.camera_alt, 'Instagram', Colors.purple),
                _shareOption(context, Icons.facebook, 'Facebook', const Color(0xFF1877F2)), // FB Blue
                _shareOption(context, Icons.chat_bubble, 'WhatsApp', const Color(0xFF25D366)), // WA Green
                _shareOption(context, Icons.copy, 'Salin Link', Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(BuildContext context, IconData icon, String label, Color color) {
    final isIg = label == 'Instagram';
    
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sharing to $label...')));
      },
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isIg ? null : color.withOpacity(0.1),
              gradient: isIg ? const LinearGradient(
                colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
                begin: Alignment.bottomLeft, end: Alignment.topRight,
              ) : null,
            ),
            child: Icon(icon, color: isIg ? Colors.white : color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _handleSchedule(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null && context.mounted) {
        final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jadwal disimpan: ${DateFormat('dd MMM HH:mm').format(dateTime)}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Konten?'),
        content: const Text('Konten ini akan dihapus permanen dari library Anda.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.pop(); // Back to library
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Konten berhasil dihapus'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    // Gradient definitions
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xFFDA4453), Color(0xFF89216B)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    
    final primaryGradient = const LinearGradient(
      colors: <Color>[Color(0xFF12c2e9), Color(0xFFc471ed), Color(0xFFf64f59)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => isDestructive ? linearGradient : primaryGradient,
              child: Icon(icon, color: Colors.white), // Color is ignored by shader
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple-Blue Gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
               color: const Color(0xFF4A00E0).withOpacity(0.3),
               blurRadius: 8,
               offset: const Offset(0, 4),
            )
          ]
        ),
        child: ElevatedButton.icon(
          onPressed: () {
               // Mock Posting
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Membuka ${item.platform.name} untuk posting...')),
              );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.transparent, // Make transparent for gradient
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.send),
          label: const Text('Posting Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Color _getPlatformColor(ContentPlatform platform) {
    switch (platform) {
      case ContentPlatform.instagramFeed:
      case ContentPlatform.instagramStory:
        return Colors.purple;
      case ContentPlatform.tiktok:
        return Colors.black;
      case ContentPlatform.facebook:
        return Colors.blue[800]!;
      case ContentPlatform.whatsapp:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  IconData _getPlatformIcon(ContentPlatform platform) {
     switch (platform) {
      case ContentPlatform.instagramFeed: return Icons.camera_alt;
      case ContentPlatform.tiktok: return Icons.music_note;
      case ContentPlatform.facebook: return Icons.facebook;
      case ContentPlatform.whatsapp: return Icons.chat;
      default: return Icons.article;
    }
  }
}

// Helper for AppBar icon backgrounds
class ContainerWithBackground extends StatelessWidget {
  final Widget child;
  const ContainerWithBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
      child: child,
    );
  }
}
