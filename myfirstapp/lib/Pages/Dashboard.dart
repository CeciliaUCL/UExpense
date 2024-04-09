import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:myfirstapp/Pages/WelcomePage.dart';
import 'package:myfirstapp/Pages/AddCostPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/Pages/ChangePasswordPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _selectedIndex = 0;
  List<dynamic> _hourlyWeather = [];//store weather
  List<String> messages = [];  // store chat
  TextEditingController messageController = TextEditingController();


  //send messaege and return reply
  Future<void> sendMessage() async {
    final String userInput = messageController.text;
    if (userInput.isNotEmpty) {
      setState(() {
        messages.insert(0, "You: $userInput");
      });
      final String response = await chatWithOpenAI(userInput);
      setState(() {
        messages.insert(0, "OpenAI: $response");
      });
      messageController.clear();
    }
  }

 Future<String> fetchApiKey() async {
  try {
    final response = await http.get(Uri.parse('https://weicheng.app/somesecrettttt.txt'));
    if (response.statusCode == 200) {
      return response.body.trim();  // 返回密钥字符串
    } else {
      throw Exception('Failed to load API key');
    }
  } catch (e) {
    throw Exception('Failed to load API key: $e');
  }
}
  Future<String> chatWithOpenAI(String message) async {
  try {
    final apiKey = await fetchApiKey();  // 从服务器获取 API 密钥
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'messages': [{'role': 'user', 'content': message}],
        'model': 'gpt-3.5-turbo',
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to get response: ${response.body}');
    }
  } catch (e) {
    return 'Error contacting OpenAI: $e';
  }
}





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
      _assistantPage(), // Placeholder for assistant page
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
    String displayName = user?.email ?? "No email available"; // Default text if user name is not available

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(displayName),
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
  String _weatherInfo = 'Press the button to get weather';
  Future<void> getWeather() async {
    try {
      Position position = await determinePosition();
      var currentWeatherData = await fetchWeather(position.latitude, position.longitude);
      var hourlyWeatherData = await fetchHourlyWeather(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String place = placemarks.isNotEmpty ? '${placemarks.first.locality}, ${placemarks.first.country}' : 'Unknown location';
      setState(() {
        _weatherInfo ='Current Temperature: ${_convertToCelsius(currentWeatherData['main']['temp']).toStringAsFixed(1)} °C\n'
                   'Weather: ${currentWeatherData['weather'][0]['description']}';
                   'Location: $place';
        _hourlyWeather = hourlyWeatherData['list'].take(8).toList();//for 24h
      });
    } catch (e) {
      setState(() {
        _weatherInfo = 'Failed to get weather: $e';
        _hourlyWeather = [];
      });
    }
  }
  
  //convert to celsius
  double _convertToCelsius(double tempInKelvin) {
    return tempInKelvin - 273.15;
  }
  

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final apiKey = '69516efa70e4fabd1f6034411c9d4990';  // APIkey
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchHourlyWeather(double latitude, double longitude) async {
    final apiKey = '69516efa70e4fabd1f6034411c9d4990';  // API key
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey';
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather forecast data');
    }
  }

Widget _hourlyWeatherListView() {
  return Container(
    height: 180.0, 
    child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(), // To provide a more compact scrolling experience
      itemCount: _hourlyWeather.length,
      itemBuilder: (context, index) {
        var hourlyData = _hourlyWeather[index];
        var time = DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000);
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0), //ListTile inside margin
          leading: Icon(Icons.wb_sunny, size: 20), 
          title: Text(
            '${time.hour}:00',
            style: TextStyle(fontSize: 14), 
          ),
          subtitle: Text(
            hourlyData['weather'][0]['description'],
            style: TextStyle(fontSize: 12), 
          ),
          trailing: Text(
            '${_convertToCelsius(hourlyData['main']['temp']).toStringAsFixed(1)} °C',
            style: TextStyle(fontSize: 14), 
          ),
        );
      },
    ),
  );
}


Widget _assistantPage() {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Weather Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _weatherInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: getWeather,
          child: Text('Get Weather'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: SizedBox(
            height: 200.0,
            child: _hourlyWeatherListView(),
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: "Ask a question",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ),
                  onSubmitted: (value) => sendMessage(),
                ),
                SizedBox(height: 20),
                Text(
                  'Chat with OpenAI:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



}