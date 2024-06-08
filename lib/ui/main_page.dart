import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopma/data/user_repository.dart';
import 'package:kopma/ui/history_page.dart';
import 'package:kopma/ui/home_page.dart';
import 'package:kopma/ui/profile_page.dart';

import '../bloc/user_bloc/user_bloc.dart';
import '../data/datasource/shared_preferences_service.dart';
import '../di/service_locator.dart';
import 'cart_page.dart';

class MainPage extends StatefulWidget {
  final UserRepository userRepository;

  const MainPage({super.key, required this.userRepository});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final sharedPrefService = serviceLocator<SharedPreferencesService>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetMyUser(myUserId: sharedPrefService.uid));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const HomePage(),
      const HistoryPage(),
      ProfilePage(
        userRepository: widget.userRepository,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kopma'),
        actions:  <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const CartPage();
                  }));
            },
          )
        ],
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 34,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedItemColor: Colors.black38,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        elevation: 12,
        onTap: _onItemTapped,
      ),
    );
  }
}
