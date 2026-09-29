import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 9',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ApiHomeScreen(),
    );
  }
}

class ApiHomeScreen extends StatefulWidget {
  const ApiHomeScreen({super.key});

  @override
  State<ApiHomeScreen> createState() => _ApiHomeScreenState();
}

class _ApiHomeScreenState extends State<ApiHomeScreen> {
  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData(); // Step 5 - Call the function
  }

  // Step 4 - Create API function
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          isLoading = false;
        });
        print(data);
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
        print('Failed to load data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessing APIs through HTTP'),
      ),
      body: Center(
        child: isLoading
            ? const Text('Loading...') // Step 7 - Handle loading
            : errorMessage.isNotEmpty
                ? Text(errorMessage, style: const TextStyle(color: Colors.red)) // Step 8 - Handle errors
                : ListView.builder( // Step 6 - Display API data
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index]['title'].toString()),
                      );
                    },
                  ),
      ),
    );
  }
}
