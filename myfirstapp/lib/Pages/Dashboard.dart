import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';
import 'package:myfirstapp/Pages/AddCostPage.dart';
import 'package:myfirstapp/Pages/ChangePasswordPage.dart';
import 'package:myfirstapp/tool/DBExTool.dart';

import '../entity/RecordDetails.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  double expenseTotal = 0;
  double incomeTotal = 0;

  List<Map> recordDetailsLst = [];
  List<String> showRecordDetailsLst = [];
  List<String> showAllRecordDetailsLst = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> selIncomeData(int index) async {
    String entryType = index == 0 ? "expense" : "income";
    List<Map> result = await DBExTool().selRecordDetailsByEntryType(entryType);
    double amount = 0;
    for (var item in result) {
      amount += item["amount"];
    }
    setState(() {
      if (index == 0) {
        expenseTotal = amount;
      } else {
        incomeTotal = amount;
      }
    });
  }

  Future<void> selRecordDetails() async {
    recordDetailsLst = await DBExTool().selRecordDetailsByAll();
    recordDetailsLst.reversed; // 反转lst
    showRecordDetailsLst = [];
    showAllRecordDetailsLst = [];
    setState(() {
      for (var i = 0; i < recordDetailsLst.length; i++) {
        var item = recordDetailsLst[i];
        var itemStr = "Entry Type: ${item["entryType"]}\n"
            "Description: ${item["description"]}\n"
            "Amount: ${item["amount"]}\n"
            "Expense Type: ${item["expenseType"]}\n"
            "Date: ${item["date"].toString()}\n"
            "Time: ${item["time"]}";
        if (i < 3) {
          showRecordDetailsLst.add(itemStr);
        }
        showAllRecordDetailsLst.add(itemStr);
      }
    });
  }

  void initData() {
    selIncomeData(0);
    selIncomeData(1);
    selRecordDetails();
  }

  @override
  Widget build(BuildContext context) {
    initData();
    List<Widget> _pages = [
      // Add the other pages here
      _homePage(),
      //This is the profile page which will have admin and logout options
      _detailPage(),
      // Placeholder for detail page
      Text('Assistant Page'),
      // Placeholder for assistant page
      _profilePage(),
      // This is the profile page which will have admin and logout options
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
          child: _pages.elementAt(
              _selectedIndex), // This will switch the content based on the selected index
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add code to open the camera here
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddCostPage(null)));
        },
        child: Icon(Icons.add, size: 36),
        backgroundColor: Color.fromARGB(255, 51, 126, 111),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavigationBarItem(
                icon: Icons.home, label: 'Home', index: 0),
            _buildBottomNavigationBarItem(
                icon: Icons.trending_up, label: 'Detail', index: 1),
            _buildBottomNavigationBarItem(
                icon: Icons.bar_chart, label: 'Assistant', index: 2),
            _buildBottomNavigationBarItem(
                icon: Icons.person, label: 'Profile', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(
      {required IconData icon, required String label, required int index}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon,
              color: _selectedIndex == index
                  ? Color.fromARGB(255, 51, 126, 111)
                  : Colors.grey),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: _selectedIndex == index ? Colors.green : Colors.grey))
        ],
      ),
      onTap: () => _onItemTapped(index),
    );
  }

  Future<void> itemDel(Map map) async {
    bool result = await DBExTool().deleteRecordDetailsById(map["id"]);
    String info = result ? "Delete Successfully!" : "Delete Failed!";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info),
      ),
    );
    Navigator.pop(context);
  }

  void listItemClick(int itemIndex, listIndex) {
    Map map = recordDetailsLst[itemIndex];
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddCostPage(map)));
  }

  void listItemLongClick(int itemIndex, listIndex) {
    Map map = recordDetailsLst[itemIndex];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Record'),
            content: Text('Are you sure you want to delete this record?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  itemDel(map);
                },
              )
            ],
          );
        });
  }

  Icon getExpenseTypeIcon(String expenseType) {
    expenseType = expenseType.trim().toLowerCase();
    switch (expenseType) {
      case 'daily':
        return Icon(Icons.home, size: 50, color: Colors.blue);
      case 'eating':
        return Icon(Icons.restaurant, size: 50, color: Colors.red);
      case 'shopping':
        return Icon(Icons.shopping_cart, size: 50, color: Colors.green);
      case 'entertainment':
        return Icon(Icons.movie, size: 50, color: Colors.purple);
      case 'study':
        return Icon(Icons.school, size: 50, color: Colors.orange);
      default:
        return Icon(Icons.error, size: 50, color: Colors.grey);
    }
  }

  // _buildExpenseTypeChip(Icons.home, 'Daily'),
  // _buildExpenseTypeChip(Icons.restaurant, 'Eating'),
  // _buildExpenseTypeChip(Icons.shopping_cart, 'Shopping'),
  // _buildExpenseTypeChip(Icons.movie, 'Entertainment'),
  // _buildExpenseTypeChip(Icons.school, 'Study'),

  Widget _listItem(List<String> dataLst, int listIndex) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20.0), // 外边距调整
        children: List.generate(
            dataLst.length,
            (index) => InkWell(
                onLongPress: () => listItemLongClick(index, listIndex),
                onTap: () => listItemClick(index, listIndex),
                child: Card(
                  elevation: 5.0, // 卡片的阴影效果
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 卡片圆角
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0), // 卡片内容的内边距
                    child: Align(
                      alignment: Alignment.topLeft, // 设置左对齐
                      child: Row(
                        children: <Widget>[
                          getExpenseTypeIcon(
                              recordDetailsLst[index]['expenseType']),
                          SizedBox(width: 10),
                          Text(
                            dataLst[index],
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  Widget _homePage() {
    return Column(
      children: [
        _accountBalanceSection(),
        _dateFilterSection(),
        _recentTransactionSection(),
        Container(
            width: 800,
            height: 500,
            child: _listItem(showRecordDetailsLst, 0)),
      ],
    );
  }

  Widget _detailPage() {
    return Container(
        width: 800, height: 800, child: _listItem(showAllRecordDetailsLst, 1));
  }

  // Account balance section
  Widget _accountBalanceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _balanceCard(
              'Income', incomeTotal, Icons.arrow_downward, Colors.green),
          _balanceCard(
              'Expenses', expenseTotal, Icons.arrow_upward, Colors.red),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Recent Transaction',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // List of transactions or ListView.builder for dynamic content
      ],
    );
  }

  // Helper method to create balance cards
  Widget _balanceCard(String title, double amount, IconData icon, Color color) {
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
    // User? user = FirebaseAuth.instance.currentUser;
    // String displayName = user?.email ??
    //     "No name available"; // Default text if user name is not available

    String displayName = "Test";

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
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChangePasswordPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // Handle logout tap
            // FirebaseAuth.instance.signOut();
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
