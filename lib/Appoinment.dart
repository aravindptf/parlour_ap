// appointments.dart
import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.black26,
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
