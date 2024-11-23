import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  String _selectedFilter = 'Daily'; // Default filter is 'Daily'

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

  // Build the list of appointments (you can replace this with dynamic data if you have a backend)
  Widget _buildAppointmentsList() {
    final List<Map<String, String>> appointments = [
      {"time": "10:00 AM", "customer": "John Doe", "service": "Haircut"},
      {"time": "12:00 PM", "customer": "Jane Smith", "service": "Manicure"},
      {"time": "02:00 PM", "customer": "Michael Lee", "service": "Facial"},
      // Add more appointments here
    ];

    // You can apply filters based on the selected timeframe (_selectedFilter)
    // For now, we are just displaying the same list regardless of the selected filter.

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
