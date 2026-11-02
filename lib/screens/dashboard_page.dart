import 'package:flutter/material.dart';

import '../widgets/student_header_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EventHub Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            StudentHeaderCard(), // Widget identitas kita
            SizedBox(height: 24),
            Text('Selamat datang di EventHub Bali!'),
          ],
        ),
      ),
    );
  }
}
