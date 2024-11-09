import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<String> attendanceRecords = [];
  List<String> leaveRequests = [];

  @override
  void initState() {
    loadAttendanceRecord();
    loadLeaveRequests();
    super.initState();
  }

  Future<void> loadAttendanceRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> records = [];
    prefs.getKeys().forEach((key) {
      if (key.startsWith('attendance_')) {
        records.add(key);
      }
      setState(() {
        attendanceRecords = records;
      });
    });
  }

  Future<void> loadLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> requests = [];
    prefs.getKeys().forEach((key) {
      if (key.startsWith('leave_')) {
        requests.add(key);
      }
      setState(() {
        leaveRequests = requests;
      });
    });
  }

  Future<void> approveLeave(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, true);
    setState(() {
      leaveRequests.remove(key);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Leave approved successfuly'),
      ),
    );
  }

  Future<void> denyLeave(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    setState(() {
      leaveRequests.remove(key);
    });
  }

  String getGrade(int attendance) {
    if (attendance >= 26) return 'A';
    if (attendance >= 20) return 'B';
    if (attendance >= 15) return 'C';
    if (attendance >= 10) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text(
              'Attendance Record',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            attendanceRecords.isEmpty
                ? const Center(
              child: Text(
                'Don\'t have attendance records',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
                : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendanceRecords.length,
                itemBuilder: (ctx, index) {
                  String recordKey = attendanceRecords[index];
                  String date = recordKey.split('_').last;
                  return ListTile(
                    title: Text('Date: $date'),
                    subtitle: const Text('Status: Present'),
                  );
                }),
            const Text(
              'Leave Requests',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            leaveRequests.isEmpty
                ? const Center(
              child: Text(
                'Don\'t have leave requests',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
                : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leaveRequests.length,
                itemBuilder: (ctx, index) {
                  String leaveKey = leaveRequests[index];
                  String date = leaveKey.split('_').last;
                  return ListTile(
                    title: Text('Date: $date'),
                    subtitle: const Text('Status: Pending'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => approveLeave(leaveKey),
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                            onPressed: () => denyLeave(leaveKey),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  );
                }),
            const Text(
              'Attendance Grading',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Attendance grading'),
              subtitle: Text('Grade: ${getGrade(attendanceRecords.length)}'),
            )
          ],
        ),
      ),
    );
  }
}
