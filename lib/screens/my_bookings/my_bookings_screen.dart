import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import 'booking_detail_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;
    await context.read<BookingProvider>().loadMyBookings(userId);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch hẹn của tôi'), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: booking.isLoadingMyBookings
            ? const Center(child: CircularProgressIndicator())
            : booking.myBookings.isEmpty
                ? ListView(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Center(
                          child: Text('Bạn chưa có lịch hẹn nào.\nKéo xuống để làm mới, hoặc đặt lịch ở tab Trang chủ.',
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: booking.myBookings.length,
                    itemBuilder: (context, i) {
                      final b = booking.myBookings[i];
                      return BookingCard(
                        booking: b,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b)),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
