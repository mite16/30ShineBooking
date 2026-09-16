import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/salon_card.dart';
import '../../widgets/section_title.dart';
import 'salon_detail_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('30Shine'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<BookingProvider>().loadCatalog(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào ${user?.fullName ?? "bạn"}! ✂️',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Chọn chi nhánh gần bạn để đặt lịch cắt tóc ngay hôm nay',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            SectionTitle('Chi nhánh gần bạn (${booking.salons.length})'),
            if (booking.isLoadingCatalog)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (booking.salons.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('Chưa có chi nhánh nào')),
              )
            else
              ...booking.salons.map(
                (salon) => SalonCard(
                  salon: salon,
                  onTap: () async {
                    await context.read<BookingProvider>().selectSalon(salon);
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SalonDetailScreen(salon: salon)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
