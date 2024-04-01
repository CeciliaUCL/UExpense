import 'package:flutter/material.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';
import 'package:myfirstapp/Pages/AddCostPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/Pages/ChangePasswordPage.dart';


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
      _homePage(), //This is the profile page which will have admin and logout options
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
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _pages.elementAt(_selectedIndex), // This will switch the content based on the selected index
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add code to open the camera here
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCostPage()));
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
    return GestureDetector(
    behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: _selectedIndex == index ? Color.fromARGB(255, 51, 126, 111) : Colors.grey),
          Text(label, style: TextStyle(fontSize: 10, color: _selectedIndex == index ? Colors.green : Colors.grey))
        ],
      ),
    onTap: () => _onItemTapped(index),
    );
  }

 Widget _homePage() {
    return Column(
      children: [
        _accountBalanceSection(),
        _dateFilterSection(),
        _recentTransactionSection(),
        // Add more sections as needed
      ],
    );
  }

  // Account balance section
  Widget _accountBalanceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _balanceCard('Income', 5000, Icons.arrow_downward, Colors.green),
          _balanceCard('Expenses', 1200, Icons.arrow_upward, Colors.red),
        ],
      ),
    );
  }

  // Date filter section
  Widget _dateFilterSection() {
    // Implementation depends on how you want to handle date filtering
    return Container(
      // Style and content for date filtering
    );
  }

  // Recent transactions section
  Widget _recentTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Recent Transaction', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // List of transactions or ListView.builder for dynamic content
      ],
    );
  }

  // Helper method to create balance cards
  Widget _balanceCard(String title, int amount, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            Text(title),
            Text('\$$amount'),
          ],
        ),
      ),
    );
  }
   Widget _profilePage() {
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.email ?? "No name available"; // Default text if user name is not available

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(displayName),
          subtitle: Text('Tap to edit profile'),
          onTap: () {
            // Handle profile edit tap
          },
        ),
        ListTile(
          leading: Icon(Icons.vpn_key),
          title: Text('Change Password'),
          onTap: () {
            // Navigate to change password page
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // Handle logout tap
            FirebaseAuth.instance.signOut();
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
