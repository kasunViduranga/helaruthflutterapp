import 'package:flutter/material.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Helaruth Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(title: const Text('Dictionary'), onTap: () {}),
          ListTile(title: const Text('Favorites'), onTap: () {}),
          ListTile(title: const Text('History'), onTap: () {}),
          ListTile(title: const Text('Help'), onTap: () {}),
          ListTile(title: const Text('Rate This App'), onTap: () {}),
          ListTile(title: const Text('Share this App'), onTap: () {}),
          ListTile(title: const Text('Follow us on Facebook'), onTap: () {}),
          ListTile(title: const Text('About'), onTap: () {}),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(value: false, onChanged: (value) {}),
          ),
        ],
      ),
    );
  }
}