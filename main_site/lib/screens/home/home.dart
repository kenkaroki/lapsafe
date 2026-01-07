import 'package:flutter/material.dart';
import 'package:main_site/services/api-service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<List<dynamic>> reports = [];

  void initState() {
    super.initState();
    loadReports();
  }

  void loadReports() async {
    final report_detail = await ApiService().getReports(
      'kenkaroki92@gmail.com',
    );
    setState(() {
      reports = report_detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lapsafe Reports"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 4, 41, 106),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 232, 219, 219),
                child: ListTile(
                  title: Text(reports[index][0]),
                  subtitle: Text("blocked on: ${reports[index][1]}"),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 2, 78, 78),
    );
  }
}
