import 'package:flutter/material.dart';

import '../../models/salon.dart';
import '../../widgets/primary_button.dart';
import '../booking/service_selection_screen.dart';

class SalonDetailScreen extends StatelessWidget {
  const SalonDetailScreen({super.key, required this.salon});

  final Salon salon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(salon.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.storefront,
                  size: 56, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 20),
            Text(salon.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.location_on_outlined, text: salon.address),
            _InfoRow(icon: Icons.access_time, text: 'Giờ mở cửa: ${salon.openHours}'),
            _InfoRow(icon: Icons.star, text: '${salon.rating} / 5.0'),
            const Spacer(),
            PrimaryButton(
              label: 'Đặt lịch tại chi nhánh này',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ServiceSelectionScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
