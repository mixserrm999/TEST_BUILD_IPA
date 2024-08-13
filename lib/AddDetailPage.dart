import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDetailPage extends StatefulWidget {
  @override
  _AddDetailPageState createState() => _AddDetailPageState();
}

class _AddDetailPageState extends State<AddDetailPage> {
  List<Map<String, dynamic>> items = [];
  String? selectedCardId;
  bool isLoading = true;
  final TextEditingController episodeTitleController = TextEditingController();
  final TextEditingController episodeDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('https://api.tbmods.xyz/fetch_data.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data.map((item) => {
            'id': item['id'], // Assuming 'id' is available
            'name': item['name']
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addEpisode() async {
    if (selectedCardId != null && episodeTitleController.text.isNotEmpty && episodeDescriptionController.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://api.tbmods.xyz/add_episode.php'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: <String, String>{
            'card_id': selectedCardId!,
            'title': episodeTitleController.text,
            'description': episodeDescriptionController.text,
          },
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Episode added successfully')));
        } else {
          throw Exception('Failed to add episode');
        }
      } catch (e) {
        print('Error adding episode: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButton<String>(
                    value: selectedCardId,
                    hint: Text('Select Card'),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'].toString(), // Use card ID as value
                        child: Text(item['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCardId = value;
                      });
                    },
                  ),
            SizedBox(height: 20),
            TextField(
              controller: episodeTitleController,
              decoration: InputDecoration(labelText: 'Episode Title'),
            ),
            TextField(
              controller: episodeDescriptionController,
              decoration: InputDecoration(labelText: 'Episode Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addEpisode,
              child: Text('Add Episode'),
            ),
            SizedBox(height: 20),
            Text(
              selectedCardId != null ? 'Selected: $selectedCardId' : 'No card selected',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
