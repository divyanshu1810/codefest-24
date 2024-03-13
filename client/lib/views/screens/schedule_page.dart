import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../../services/schedule_services.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Interview'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: Svg('assets/images/bg.svg'), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ScheduleForm(),
          ),
        ),
      ),
    );
  }
}

class ScheduleForm extends StatefulWidget {
  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController intervieweeNameController = TextEditingController();
  TextEditingController intervieweeEmailController = TextEditingController();
  TextEditingController roleAppliedController = TextEditingController();
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController otherInterviewersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateField(),
          SizedBox(height: 16.0),
          _buildTimeField(),
          SizedBox(height: 16.0),
          _buildTextField(intervieweeNameController, 'Interviewee Name', Icons.person),
          SizedBox(height: 16.0),
          _buildTextField(intervieweeEmailController, 'Interviewee Email', Icons.email),
          SizedBox(height: 16.0),
          _buildTextField(roleAppliedController, 'Role Applied', Icons.work),
          SizedBox(height: 16.0),
          _buildTextField(meetingTitleController, 'Meeting Title', Icons.event),
          SizedBox(height: 16.0),
          _buildTextField(otherInterviewersController, 'Other Interviewers', Icons.people),
          SizedBox(height: 32.0),

          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
                // Call the scheduleInterview method from ScheduleServices
                Map<String, dynamic> scheduleResult = await ScheduleServices.scheduleInterview(
                  selectedDate!,
                  selectedTime!,
                  intervieweeNameController.text,
                  intervieweeEmailController.text,
                  roleAppliedController.text,
                  meetingTitleController.text,
                  otherInterviewersController.text,
                );

                if (scheduleResult['success']) {
                  // Successfully scheduled, you can handle success accordingly
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Interview scheduled successfully!'),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/interviews');

                  // Optionally navigate to another page or perform additional actions
                } else {
                  // Handle scheduling error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to schedule interview: ${scheduleResult['error']}'),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            child: Text('Schedule Interview', style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Color(0xE3DAC9),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(Icons.date_range),
          filled: true,
          fillColor: Color(0xE3DAC9),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
        child: Text(selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''),
      ),
    );
  }

  Widget _buildTimeField() {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null && pickedTime != selectedTime) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Time',
          prefixIcon: Icon(Icons.access_time),
          filled: true,
          fillColor: Color(0xE3DAC9),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
        child: Text(selectedTime != null ? selectedTime!.format(context) : ''),
      ),
    );
  }
}
