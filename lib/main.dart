import 'package:attendance/screen/login_screen.dart';
import 'package:attendance/screen/registration_screen.dart';
import 'package:attendance/screen/student_dashboard/edit_profile.dart';
import 'package:attendance/screen/student_dashboard/mark_attendance.dart';
import 'package:attendance/screen/student_dashboard/mark_leave.dart';
import 'package:attendance/screen/student_dashboard/student_dashboard.dart';
import 'package:attendance/screen/student_dashboard/view_attendance.dart';
import 'package:attendance/screen/teacher_dashboard.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),

      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/student_dashboard': (context) => StudentDashboard(),
        '/teacher_dashboard': (context) => TeacherDashboard(),
        '/mark_attendance': (context) => MarkAttendance(),
        '/mark_leave': (context) => MarkLeave(),
        '/view_attendance': (context) => ViewAttendance(),
        '/edit_profile': (context) => EditProfileScreen(),
      },
    );
  }
}
