import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  List<String> attendanceRecords = [];

  @override
  void initState() {
    loadAttendance();
    super.initState();
  }

  Future<void> loadAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> records = [];
    prefs.getKeys().forEach((key){
      if (key.startsWith('attendance_') || key.startsWith('leave_')){
        records.add(key);
      }
      setState(() {
        attendanceRecords = records;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Attendance'),
      ),
      body: attendanceRecords.isEmpty ? const Center(child: Text('No attendance or leave records are found'),) :

      ListView.builder(
          itemCount: attendanceRecords.length,
          itemBuilder: (ctx , index){
            String recordKey = attendanceRecords[index];
            String displayDate = recordKey.split('_').last;
            return ListTile(
              title: Text(displayDate),
              subtitle: Text(recordKey.startsWith('leave_') ? 'Present' : 'Leave Request'),
            );
          }),
    );
  }
}
