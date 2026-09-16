import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/booking_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/service_tile.dart';
import 'booking_schedule_screen.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn dịch vụ')),
      body: booking.services.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: booking.services
                  .map((service) => ServiceTile(
                        service: service,
                        selected: booking.selectedServices.contains(service),
                        onChanged: (_) => context.read<BookingProvider>().toggleService(service),
                      ))
                  .toList(),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  booking.selectedServices.isEmpty
                      ? 'Chưa chọn dịch vụ'
                      : 'Tổng: ${Formatters.currency(booking.selectedTotalPrice)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Tiếp tục',
                  onPressed: booking.selectedServices.isEmpty
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BookingScheduleScreen()),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
