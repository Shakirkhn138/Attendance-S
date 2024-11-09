import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  bool isMarked = false;

  @override
  void initState() {
    checkAttendanceStatus();
    super.initState();
  }

  Future<void> checkAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().substring(0, 10);
    setState(() {
      isMarked = prefs.getBool(today) ?? false;
    });
  }

  Future<void> markAttendance() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().substring(0, 10);
    // await prefs.setBool(today, true);
    String attendanceKey = 'attendance_$today';
    if (!prefs.containsKey(attendanceKey)){
      await prefs.setBool(attendanceKey, true);
      setState(() {
        isMarked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance marked successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance already marked'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance', ),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: isMarked ? null : markAttendance,
            child: Text(
                isMarked ? 'Attendance already marked' : 'Mark Attendance', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))),
      ),
    );
  }
}
