import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/booking_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_title.dart';
import 'booking_review_screen.dart';

class BookingScheduleScreen extends StatefulWidget {
  const BookingScheduleScreen({super.key});

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  final List<DateTime> _nextDays = List.generate(
    14,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().selectDate(_nextDays.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn thợ & thời gian')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SectionTitle('Chọn thợ cắt'),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _StylistChip(
                  label: 'Bất kỳ',
                  selected: booking.selectedStylist == null,
                  onTap: () => context.read<BookingProvider>().selectStylist(null),
                ),
                ...booking.stylists.map(
                  (s) => _StylistChip(
                    label: '${s.name} (${s.level})',
                    selected: booking.selectedStylist?.id == s.id,
                    onTap: () => context.read<BookingProvider>().selectStylist(s),
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle('Chọn ngày'),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _nextDays.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final day = _nextDays[i];
                final selected = booking.selectedDate != null &&
                    _isSameDay(day, booking.selectedDate!);
                return _DateChip(
                  date: day,
                  selected: selected,
                  onTap: () => context.read<BookingProvider>().selectDate(day),
                );
              },
            ),
          ),
          const SectionTitle('Chọn khung giờ'),
          if (booking.isLoadingSlots)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (booking.availableSlots.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Không còn khung giờ trống trong ngày này')),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: booking.availableSlots
                  .map((slot) => ChoiceChip(
                        label: Text(slot),
                        selected: booking.selectedTimeSlot == slot,
                        onSelected: (_) => context.read<BookingProvider>().selectTimeSlot(slot),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Xem lại đơn đặt lịch',
            onPressed: booking.canReview
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BookingReviewScreen()),
                    )
                : null,
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _StylistChip extends StatelessWidget {
  const _StylistChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date, required this.selected, required this.onTap});

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final label = weekdays[date.weekday - 1];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : null, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('${date.day}',
                style: TextStyle(
                    color: selected ? Colors.white : null, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
