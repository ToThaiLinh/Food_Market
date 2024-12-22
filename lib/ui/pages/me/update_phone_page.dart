// Update Phone Page
import 'package:flutter/material.dart';

class UpdatePhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Số điện thoại', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFBF4E19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Số điện thoại hiện tại'),
              subtitle: Text('******012'),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cập nhật số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text('Tiếp tục', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}