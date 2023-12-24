import 'package:flutter/material.dart';
import 'package:hw4/constants.dart';
import 'package:hw4/models/users.dart';
import 'package:hw4/database/db_helper.dart';
import 'package:hw4/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:hw4/providers/user_data_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final userId = userDataProvider.userId;
    fetchUserData(userId);
  }

  Future<void> fetchUserData(int? userId) async {
    try {
      User? user = await DBHelper.getUser(userId ?? 0);

      if (user != null) {
        setState(() {
          _user = user;
        });
      } else {
        print('User data not found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Use the user's profile picture here
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${_user.firstName} ${_user.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Settings'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Logout'),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
