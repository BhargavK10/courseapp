import 'package:courseapp/dashboard.dart';
import 'package:courseapp/viewAll.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  Future signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      backgroundColor: Color(0xFFD7D7D7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF2C3137)),
            child: Icon(Icons.build, color: Colors.white),
          ),
          ListTile(
            leading: Icon(Icons.home, color: const Color(0xFF242424)),
            title: Text('Home', style: TextStyle(color: Color(0xFF242424))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Dashboard()),
              );
              // Use your page navigation logic here
            },
          ),
          /*ListTile(
            leading: Icon(Icons.book, color: Color(0xFF242424)),
            title: Text('Courses', style: TextStyle(color: Color(0xFF242424))),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>AllCoursesPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement, color: Color(0xFF242424)),
            title: Text('Announce', style: TextStyle(color: Color(0xFF242424))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFF242424)),
            title: Text('Users', style: TextStyle(color: Color(0xFF242424))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey[700]),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF242424)),
            title: Text('Settings', style: TextStyle(color: Color(0xFF242424))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: const Color(0xFFDB3939)),
            title: Text('Logout', style: TextStyle(color: Color(0xFFDB3939))),
            onTap: signOut,
          ),*/
        ],
      ),
    );
  }
}
