import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCardPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _submitCard(BuildContext context) async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final imageUrl = _imageUrlController.text;

    if (name.isNotEmpty && description.isNotEmpty && imageUrl.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://api.tbmods.xyz/add_card.php'), // Update with your PHP endpoint
        body: {
          'name': name,
          'description': description,
          'image_url': imageUrl,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Card added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add card.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Card Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitCard(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
