import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_title.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final Booking booking;

  Future<void> _cancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Huỷ lịch hẹn?'),
        content: const Text('Bạn có chắc muốn huỷ lịch hẹn này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Huỷ lịch')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final userId = context.read<AuthProvider>().currentUser!.id;
    await context.read<BookingProvider>().cancelBooking(booking.id, userId);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canCancel =
        booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết lịch hẹn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Chip(label: Text(booking.status.label)),
          const SectionTitle('Chi nhánh'),
          Text(booking.salonName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SectionTitle('Dịch vụ'),
          ...booking.services.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(s.name)),
                  Text(Formatters.currency(s.priceVnd)),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(Formatters.currency(booking.totalPriceVnd),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SectionTitle('Thợ cắt'),
          Text(booking.stylistName),
          const SectionTitle('Thời gian'),
          Text('${Formatters.date(booking.date)} · ${booking.timeSlot}'),
          if (booking.note != null) ...[
            const SectionTitle('Ghi chú'),
            Text(booking.note!),
          ],
          const SizedBox(height: 24),
          if (canCancel)
            PrimaryButton(label: 'Huỷ lịch hẹn', onPressed: () => _cancel(context)),
        ],
      ),
    );
  }
}
