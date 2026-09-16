import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:booking30shine/providers/auth_provider.dart';
import 'package:booking30shine/repositories/auth_repository.dart';
import 'package:booking30shine/screens/auth/login_screen.dart';

Widget _wrap(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepository())),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('LoginScreen shows the sign-in form', (tester) async {
    await tester.pumpWidget(_wrap(const LoginScreen()));

    expect(find.text('Đăng nhập'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Đăng nhập'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors on empty submit', (tester) async {
    await tester.pumpWidget(_wrap(const LoginScreen()));

    // Clear the pre-filled demo credentials.
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
    await tester.pump();

    expect(find.text('Email không được để trống'), findsOneWidget);
    expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
  });
}
