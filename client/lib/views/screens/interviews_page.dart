import 'package:authenticheck/views/screens/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/interviews_services.dart';
import '../../services/login_services.dart';
import 'meeting_page.dart';
class InterviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scheduled Interviews'),
          actions: [
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String role = snapshot.data?.getString('role') ?? '';

                  // Display the plus icon only if the role is 'interviewer'
                  if (role == 'interviewer') {
                    return IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Add your logic to handle the plus icon click
                        // For now, navigate to the MeetingPrepPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchedulePage(),
                          ),
                        );
                      },
                    );
                  }
                }

                return Container();
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/bg.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            TabBarView(
              children: [
                ScheduledInterviewsTab(tabTitle: 'Upcoming'),
                ScheduledInterviewsTab(tabTitle: 'Completed'),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: FutureBuilder<SharedPreferences>(
            // Use FutureBuilder to asynchronously fetch SharedPreferences
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Once SharedPreferences data is available, extract the name and email
                String name = snapshot.data?.getString('name') ?? 'John Doe';
                String email = snapshot.data?.getString('email') ?? 'john.doe@example.com';

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('path_to_user_image.jpg'), // Replace with the actual path
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'User Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              // Add more user details as needed
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (snapshot.data?.getString('role') == 'interviewee') ...[
                      ListTile(
                        title: Text('Profile'),
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      // Add more list items as needed
                    ],
                    ListTile(
                      title: Text('Feedback'),
                      onTap: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                    ),
                    ListTile(
                      title: Text('Logout'),
                      onTap: () async {
                        Map<String, dynamic> logoutResult = await LoginServices.logoutUser();
                        if (logoutResult['success']) {
                          // Successfully logged out, navigate to login page
                          Navigator.of(context).pushReplacementNamed('/login');
                        } else {
                          // Handle logout error, if any
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logout failed: ${logoutResult['error']}'),
                            ),
                          );
                        }
                      },
                    ),
                    // Add more list items as needed
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ScheduledInterviewsTab extends StatelessWidget {
  final String tabTitle;

  ScheduledInterviewsTab({required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: InterviewServices.getMeetings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available.');
        } else {
          // Use the fetched data to build InterviewCard widgets
          List<Map<String, dynamic>> meetingsData = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: meetingsData.map((meeting) {
                String intervieweeEmail = meeting['intervieweeEmail'] ?? '';
                String role = meeting['role'] ?? '';
                String date = meeting['time']['\$date'] ?? '';
                String title = meeting['title'] ?? '';

                // Convert the scheduled date string to DateTime
                DateTime scheduledDate = DateTime.parse(date);

                // Check if the meeting is 'Upcoming' or 'Completed' based on the current time
                bool isUpcoming = scheduledDate.isAfter(DateTime.now());
                bool isCompleted = scheduledDate.isBefore(DateTime.now());

                // Format date and time using intl package
                String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(scheduledDate);

                // Display the content only for the relevant tab
                if ((tabTitle == 'Upcoming' && isUpcoming) ||
                    (tabTitle == 'Completed' && isCompleted)) {
                  return InterviewCard(
                    meeting: meeting,
                    intervieweeName: intervieweeEmail,
                    roleApplied: role,
                    date: formattedDate,
                    time: title,
                  );
                } else {
                  return Container(); // Return an empty container if not displayed
                }
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
class InterviewCard extends StatefulWidget {
  final String intervieweeName;
  final String roleApplied;
  final String date;
  final String time;
  final Map<String, dynamic> meeting;

  InterviewCard({
    required this.intervieweeName,
    required this.roleApplied,
    required this.date,
    required this.time,
    required this.meeting,
  });

  @override
  _InterviewCardState createState() => _InterviewCardState();
}
class _InterviewCardState extends State<InterviewCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String title = widget.meeting['title'] ?? '';
    String interviewerEmail = widget.meeting['interviewerEmail'] ?? '';

    // Convert the scheduled date string to DateTime
    DateTime scheduledDate = DateTime.parse(widget.meeting['time']['\$date'] ?? '');

    // Check if the meeting is 'Upcoming' or 'Completed' based on the current time
    bool isCompleted = scheduledDate.isBefore(DateTime.now());

    return Container(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Interviewee: ${widget.intervieweeName}'),
                Text('Interviewer Email: $interviewerEmail'),
                Text('Role Applied: ${widget.roleApplied}'),
                Text('Date and time: ${widget.date}'),
                if (isExpanded) ...[
                  SizedBox(height: 8.0),
                  if (!isCompleted) // Add this line
                    ElevatedButton(
                      onPressed: () {
                        String meetingCode = widget.meeting['meetingCode'] ?? '';

                        Future<String> getName() async {
                          final prefs = await SharedPreferences.getInstance();
                          return prefs.getString('name') ?? '';
                        }

                        getName().then((name) {
                          print("meeting code is $meetingCode, name is $name");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetingPage(meetingCode: meetingCode, name: name),
                            ),
                          );
                        });
                      },
                      child: Text('Join'),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}