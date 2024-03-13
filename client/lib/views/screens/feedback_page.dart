import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<String> suggestions = ['Great!', 'Needs Improvement', 'User-friendly', 'Bug Report'];
  String? selectedFeedback;
  TextEditingController customFeedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bg.svg', // Replace with your SVG file path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Give us your Feedback',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8), // Grey translucent background
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Choose from Suggestions',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedFeedback,
                    onChanged: (String? value) {
                      setState(() {
                        selectedFeedback = value;
                      });
                    },
                    items: suggestions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8), // Grey translucent background
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: customFeedbackController,
                    decoration: InputDecoration(
                      labelText: 'Add Your Own Feedback',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String? finalFeedback = selectedFeedback!.isNotEmpty
                        ? selectedFeedback
                        : customFeedbackController.text;
                    print('Submitted Feedback: $finalFeedback');

                    // Add your logic to handle the submitted feedback

                    // Reset the state to clear the data
                    setState(() {
                      selectedFeedback = null;
                      customFeedbackController.clear();
                    });
                  },
                  child: Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
