import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/content_item.dart';
import '../../repositories/content_repository.dart';

// Controller/Provider
final contentStreamProvider = StreamProvider.autoDispose<List<ContentItem>>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  // Hardcoded user for demo
  return repo.watchContent('demo-user');
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  final _filters = ['Semua', 'Instagram', 'TikTok', 'Draft', 'Favorit'];

  @override
  Widget build(BuildContext context) {
    final mock = GoRouterState.of(context).uri.queryParameters['mock'] == 'true';
    final contentAsync = mock 
      ? AsyncValue.data(List.generate(5, (i) => ContentItem.demo(i.toString()))) 
      : ref.watch(contentStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Library Konten', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/banner_library.png',
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
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 140.0,
              maxHeight: 140.0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Cari konten lama...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) => setState(() => _selectedFilter = filter),
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          contentAsync.when(
            data: (items) {
               // Mock filtering logic since we don't have real backend filtering yet
               final filteredItems = items.where((item) {
                 final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                       item.body.toLowerCase().contains(_searchQuery.toLowerCase());
                 final matchesFilter = _selectedFilter == 'Semua' || 
                                       item.platform.name.contains(_selectedFilter) ||
                                       (_selectedFilter == 'Draft' && false); // Mock
                 return matchesSearch && matchesFilter;
               }).toList();

              if (filteredItems.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Tidak ada konten ditemukan', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }
              
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filteredItems[index];

                      return _ContentCard(item: item);
                    },
                    childCount: filteredItems.length,
                  ),
                ),
              );
            },
            error: (e, st) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => 
      maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
}

class _ContentCard extends StatelessWidget {
  final ContentItem item;

  const _ContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Generate a random-ish color based on platform
    Color tagColor = Colors.blue;
    IconData icon = Icons.article;
    if (item.platform.name.toLowerCase().contains('instagram')) {
       tagColor = Colors.purple;
       icon = Icons.camera_alt;
    } else if (item.platform.name.toLowerCase().contains('tiktok')) {
       tagColor = Colors.black;
       icon = Icons.music_note;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.go('/library/detail', extra: item);
        }, // Open detail
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.type == ContentType.image && item.imageUrl != null)
              Stack(
                children: [
                  if (item.imageUrl!.startsWith('http'))
                    Image.network(
                      item.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    )
                  else
                    Image.asset(
                      item.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                      child: Text(item.platform.name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: tagColor.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(icon, size: 16, color: tagColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title, 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                         padding: EdgeInsets.zero,
                         constraints: const BoxConstraints(),
                         onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${item.createdAt.day} ${_getMonthName(item.createdAt.month)} ${item.createdAt.year}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        onPressed: (){}, 
                        icon: const Icon(Icons.share, size: 14), 
                        label: const Text('Share', style: TextStyle(fontSize: 12))
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', ' Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
