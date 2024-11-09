import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkLeave extends StatefulWidget {
  const MarkLeave({super.key});

  @override
  State<MarkLeave> createState() => _MarkLeaveState();
}

class _MarkLeaveState extends State<MarkLeave> {

  final _leaveReasonController = TextEditingController();

  Future<void> markLeave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().substring(0 , 10);
    // await prefs.setString('leave_$today', _leaveReasonController.text);
    String leaveKey = 'leave_$today';
    if (!prefs.containsKey(leaveKey)){
      await prefs.setBool(leaveKey, true);
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Leave request sent successfully'),),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Leave request already send'),),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _leaveReasonController,
              decoration: InputDecoration(
                  labelText: 'Reason for leave',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(onPressed: markLeave, child: const Text('Sent leave request', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),),
          ],
        ),
      ),
    );
  }
}
