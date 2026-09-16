import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_title.dart';
import 'booking_success_screen.dart';

class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key});

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final auth = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();
    final userId = auth.currentUser!.id;

    final booking = await bookingProvider.confirmBooking(
      userId: userId,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    if (!mounted) return;
    if (booking != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BookingSuccessScreen(booking: booking)),
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookingProvider.errorMessage ?? 'Đặt lịch thất bại, thử lại nhé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final salon = booking.selectedSalon!;

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận đặt lịch')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('Chi nhánh'),
          Text(salon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(salon.address, style: TextStyle(color: Colors.grey.shade600)),
          const SectionTitle('Dịch vụ đã chọn'),
          ...booking.selectedServices.map(
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
              const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                Formatters.currency(booking.selectedTotalPrice),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SectionTitle('Thợ cắt'),
          Text(booking.selectedStylist?.name ?? 'Bất kỳ thợ nào'),
          const SectionTitle('Thời gian'),
          Text('${Formatters.date(booking.selectedDate!)} · ${booking.selectedTimeSlot}'),
          const SectionTitle('Ghi chú (không bắt buộc)'),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'VD: mình muốn cắt ngắn hai bên...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Xác nhận đặt lịch',
            isLoading: booking.isSubmitting,
            onPressed: _confirm,
          ),
        ),
      ),
    );
  }
}
