import 'package:flutter/material.dart';

import '../constants/supabase_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.badge, color: Colors.deepPurple),
                      title: Text(
                        'Nama Lengkap',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: Text(
                        studentName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.pin, color: Colors.deepPurple),
                      title: Text(
                        'NIM',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: Text(
                        studentId,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.class_, color: Colors.deepPurple),
                      title: Text(
                        'Kelas',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: Text(
                        studentClass,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'EventHub UTS Mobile Application\nVersi 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
