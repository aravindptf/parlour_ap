import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parlour/Appoinment.dart';
import 'package:parlour/Map_page.dart';
import 'package:parlour/notification.dart'; // Import your Notification page
import 'package:parlour/profile.dart'; // Import your Profile page
import 'package:parlour/servicespage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homepage extends StatefulWidget {
  final String? coverImagePath;
  final String? profileImagePath;

  const Homepage({super.key, this.coverImagePath, this.profileImagePath});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the pages with HomeContent and pass the image paths
    _pages.add(HomeContent(
      coverImagePath: widget.coverImagePath,
      profileImagePath: widget.profileImagePath,
    ));
    _pages.add(const NotificationsPage());
    _pages.add(const ProfileScreen());
  }

  void onBottomNavTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: Colors.black26, // Background color of the nav bar
        buttonBackgroundColor: Colors.black, // Color for the selected button
        backgroundColor: Colors.transparent, // Background color of the container
        animationCurve: Curves.easeInOut, // Animation for transitions
        animationDuration: const Duration(milliseconds: 300), // Duration of the animation
        onTap: onBottomNavTapped, // Handle taps
      ),
    );
  }
}

// HomeContent Widget: The main content for the homepage
class HomeContent extends StatefulWidget {
  final String? coverImagePath;
  final String? profileImagePath;

  const HomeContent({super.key, this.coverImagePath, this.profileImagePath});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int activateIndex = 0; // Track the active index of the carousel

  final List<String> imageList = [
    'assets/salon1.jpg',
    'assets/salon2.jpg',
    'assets/salon 3.avif',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        SizedBox(height: 30),
        _buildCarouselSlider(),
        Expanded(child: _buildVerticalOptions()), // Fill the remaining space with options
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          '', // AppBar title
          style: GoogleFonts.adamina(color: Colors.white, fontSize: 30),
        ),
      ),
      backgroundColor: Colors.black26,
      toolbarHeight: 150,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Transform.translate(
          offset: Offset(0, -40),
          child: IconButton(
            icon: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Mappage()),
              );
            },
          ),
        ),
      ),
      actions : [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: widget.profileImagePath != null
                ? FileImage(File(widget.profileImagePath!))
                : null, // Display profile image
            child: widget.profileImagePath == null
                ? Icon(Icons.person, size: 30, color: Colors.grey) // Default icon
                : null,
          ),
        ),
      ],
    );
  }

  // Build the Carousel Slider
  Widget _buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: imageList.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageList[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                activateIndex = index;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AnimatedSmoothIndicator(
            activeIndex: activateIndex,
            count: imageList.length,
            effect: WormEffect(
              dotWidth: 10,
              dotHeight: 10,
              dotColor: Colors.grey,
              activeDotColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Build the Vertical Options (e.g., Appointments, Services)
  Widget _buildVerticalOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          _buildOptionContainer("Appointments"),
          SizedBox(height: 15), // Space between options
          _buildOptionContainer("Employees"),
          SizedBox(height: 15), // Space between options
          _buildOptionContainer("Services"),
        ],
      ),
    );
  }

  // Helper method to create each option container
  Widget _buildOptionContainer(String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Appointments") {
          // Navigate to the AppointmentsPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentsPage()),
          );
           } else if (title == "Services") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ServicesPage()),
        );
        } else {
          // Handle other taps here (e.g., Employees, Services)
          print('$title tapped');
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black26, // Background color of the option
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          title,
          style: GoogleFonts.adamina(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}