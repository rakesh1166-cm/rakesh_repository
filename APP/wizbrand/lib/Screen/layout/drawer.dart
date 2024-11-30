import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Auth/loginscreen.dart';
import 'package:wizbrand/view_modal/Login_view_model.dart';

mixin DrawerMixin<T extends StatefulWidget> on State<T> {
  Widget buildDrawer(BuildContext context, {required String orgSlug}) {
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();

 void _logout() async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.logout(context).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

    return Drawer(
      child: Container(
        color: Colors.white, // Adjust the background color as needed
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Wizbrand',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.home,
              title: 'Dashboard/Seo',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'SEO Dashboard',
                  route: '/seo_dashboard',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Analytics',
                  route: '/analytics',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.settings,
              title: 'Organization Setting',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'Users',
                  route: '/users',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Organization list',
                  route: '/organization',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.business,
              title: 'Project Onboarding',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'Projects',
                  route: '/new_project',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'URLs',
                  route: '/urls',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                    _buildSubmenuItem(
                  context: context,
                  text: 'Keywords',
                  route: '/keywords',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.assessment,
              title: 'Competitors',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'Add Competitor',
                  route: '/competitor_analysis',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.star_rate,
              title: 'Rank Rating',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'Team Rating',
                  route: '/rank_overview',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Website Rating',
                  route: '/web_ratings',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Page Ranking',
                  route: '/page_rank',
                  arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Social Ranking',
                  route: '/social_rank',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.web,
              title: 'SEO Assets',
              children: [
              
                _buildSubmenuItem(
                  context: context,
                  text: 'Keys Manager',
                  route: '/key_manager',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Website Access',
                  route: '/web_access',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Email Access',
                  route: '/email_access',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
                  _buildSubmenuItem(
                  context: context,
                  text: 'Phone numbers',
                  route: '/phone_numbers',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Guest post',
                  route: '/guest_post',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            _buildDrawerItemWithSubmenu(
              context: context,
              icon: Icons.task,
              title: 'Task Manager',
              children: [
                _buildSubmenuItem(
                  context: context,
                  text: 'Task Board',
                  route: '/current_tasks',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
                _buildSubmenuItem(
                  context: context,
                  text: 'Interval Task',
                  route: '/interval_tasks',
                   arguments: orgSlug, // Pass the orgSlug argument here
                ),
              ],
            ),
            Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                  _logout();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.security, color: Colors.blue),
                title: Text(
                  'WizBrand\nDigital Marketing',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), // Ensure icon color is consistent
      title: Text(text, style: TextStyle(color: Colors.black)), // Text color
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDrawerItemWithSubmenu({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black), // Icon color
      title: Text(title, style: TextStyle(color: Colors.black)), // Text color
      children: children,
    );
  }

  Widget _buildSubmenuItem({
    required BuildContext context,
    required String text,
    required String route,
    String? arguments,
  }) {
    return ListTile(
      title: Text(text, style: TextStyle(color: Colors.black)), // Text color
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          route,
          arguments: arguments, // Pass the arguments if any
        );
      },
    );
  }
}