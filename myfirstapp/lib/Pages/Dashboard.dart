import 'package:flutter/material.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      // Add the other pages here
      Text('Home Page'), // Placeholder for home page
      Text('Detail Page'), // Placeholder for detail page
      Text('Assistant Page'), // Placeholder for assistant page
      _profilePage(), // This is the profile page which will have admin and logout options
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 51, 126, 111),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _pages.elementAt(_selectedIndex), // This will switch the content based on the selected index
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add code to open the camera here
        },
        child: Icon(Icons.add, size: 36),
        backgroundColor:  Color.fromARGB(255, 51, 126, 111),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavigationBarItem(icon: Icons.home, label: 'Home', index: 0),
            _buildBottomNavigationBarItem(icon: Icons.trending_up, label: 'Detail', index: 1),
            _buildBottomNavigationBarItem(icon: Icons.bar_chart, label: 'Assistant', index: 2),
            _buildBottomNavigationBarItem(icon: Icons.person, label: 'Profile', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem({required IconData icon, required String label, required int index}) {
    return IconButton(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: _selectedIndex == index ? Color.fromARGB(255, 51, 126, 111) : Colors.grey),
          Text(label, style: TextStyle(fontSize: 12, color: _selectedIndex == index ? Colors.green : Colors.grey))
        ],
      ),
      onPressed: () => _onItemTapped(index),
    );
  }

  Widget _profilePage() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.admin_panel_settings),
        title: Text('Admin'),
        onTap: () {
          // Handle admin tap
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () {
          // Handle logout tap
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomePage()),
            (Route<dynamic> route) => false,
          );
        },
      ),
    ],
  );
}

}
