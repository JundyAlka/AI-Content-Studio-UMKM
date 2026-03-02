import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/social_scheduler_service.dart';
import '../../models/content_item.dart';
import '../../widgets/app_button.dart';

class ScheduleContentScreen extends ConsumerStatefulWidget {
  const ScheduleContentScreen({super.key});

  @override
  ConsumerState<ScheduleContentScreen> createState() => _ScheduleContentScreenState();
}

class _ScheduleContentScreenState extends ConsumerState<ScheduleContentScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  bool _isCalendarView = false; // Toggle view mode

  final _contentTitleController = TextEditingController();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)), // Allow looking back slightly
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
             colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Theme.of(context).brightness),
          ),
          child: child!,
        );
      }
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (t != null) setState(() => _selectedTime = t);
  }

  Future<void> _schedule() async {
    if (_selectedDate == null || _selectedTime == null || _contentTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi form jadwal')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dt = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final item = ContentItem.demo('999'); // Mock content
      final service = ref.read(socialSchedulerServiceProvider);
      await service.schedulePost(item, dt);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil dijadwalkan pada $dt')));
        context.pop();
      }
    } catch (e) {
      // Handle error
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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Jadwal Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Image.asset(
                    'assets/images/banner_schedule.png',
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
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // View Toggle
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text('Tampilan Kalender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                       Switch(
                         value: _isCalendarView, 
                         onChanged: (v) => setState(() => _isCalendarView = v),
                         activeColor: Theme.of(context).primaryColor,
                       )
                     ],
                   ),
                   const SizedBox(height: 20),
                   
                   if (_isCalendarView) 
                     _buildCalendarMock()
                   else
                     _buildScheduleForm()
                 ],
               ),
             ),
          )
        ],
      ),
    );
  }
  
  Widget _buildScheduleForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Konten yang akan dijadwalkan', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: _contentTitleController,
              decoration: InputDecoration(
                hintText: 'Pilih Konten (Mock: Masukkan Judul)',
                prefixIcon: const Icon(Icons.article),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedDate == null ? 'Pilih Tanggal' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: _selectedDate == null ? Colors.grey : null),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedTime == null ? 'Pilih Jam' : _selectedTime!.format(context),
                              style: TextStyle(fontWeight: FontWeight.bold, color: _selectedTime == null ? Colors.grey : null),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: AppButton(
                label: 'Simpan Jadwal',
                icon: Icons.schedule_send,
                isLoading: _isLoading,
                onPressed: _schedule,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCalendarMock() {
     return Container(
       height: 300,
       decoration: BoxDecoration(
         color: Theme.of(context).cardColor,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Theme.of(context).dividerColor),
       ),
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.calendar_view_week, size: 48, color: Theme.of(context).primaryColor.withOpacity(0.5)),
             const SizedBox(height: 16),
             const Text('Tampilan Kalender Penuh', style: TextStyle(fontWeight: FontWeight.bold)),
             const Text('(Fitur akan datang)', style: TextStyle(color: Colors.grey)),
           ],
         ),
       ),
     );
  }
}
