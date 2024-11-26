import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  String _selectedFilter = 'Daily'; // Default filter is 'Daily'

  final Map<String, List<Map<String, String>>> _appointments = {
    "Daily": [
      {"time": "10:00 AM", "customer": "John Doe", "service": "Haircut"},
      {"time": "11:00 AM", "customer": "Emily Davis", "service": "Shampoo"},
      {"time": "01:00 PM", "customer": "Jane Smith", "service": "Manicure"},
      {"time": "03:00 PM", "customer": "Chris Brown", "service": "Hair Coloring"},
      {"time": "05:00 PM", "customer": "Michael Lee", "service": "Facial"},
    ],
    "Weekly": [
      {"time": "Monday, 10:00 AM", "customer": "Alice Green", "service": "Haircut"},
      {"time": "Tuesday, 02:00 PM", "customer": "Robert Taylor", "service": "Beard Trim"},
      {"time": "Wednesday, 01:00 PM", "customer": "Olivia Harris", "service": "Pedicure"},
      {"time": "Friday, 04:00 PM", "customer": "Ethan King", "service": "Facial"},
      {"time": "Saturday, 11:00 AM", "customer": "Sophia Moore", "service": "Hair Styling"},
    ],
    "Monthly": [
      {"time": "1st Nov, 10:00 AM", "customer": "Liam Miller", "service": "Haircut"},
      {"time": "5th Nov, 03:00 PM", "customer": "Emma Wilson", "service": "Spa"},
      {"time": "15th Nov, 12:00 PM", "customer": "Noah Clark", "service": "Shaving"},
      {"time": "20th Nov, 02:00 PM", "customer": "Ava Adams", "service": "Hair Coloring"},
      {"time": "28th Nov, 05:00 PM", "customer": "Lucas Hall", "service": "Pedicure"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments ($_selectedFilter)'), // Display selected filter here
        backgroundColor: Colors.black26,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value; // Update the selected filter
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Daily', 'Weekly', 'Monthly'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _buildAppointmentsList(),
    );
  }

  // Build the list of appointments based on the selected filter
  Widget _buildAppointmentsList() {
    final List<Map<String, String>> appointments = _appointments[_selectedFilter] ?? [];

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text('${appointment['customer']} - ${appointment['service']}'),
            subtitle: Text('Time: ${appointment['time']}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Handle tap if needed (e.g., show details of the appointment)
            },
          ),
        );
      },
    );
  }
}
