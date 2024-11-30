import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin RoleMixin<T extends StatefulWidget> on State<T> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // This method will fetch the orgRoleId from secure storage
  Future<String> fetchAndDetermineUserRole() async {
    // Fetch orgRoleId from secure storage
    String? orgRoleId = await secureStorage.read(key: 'orgRoleId');
    print('Fetched orgRoleId from secure storage: $orgRoleId'); // Debug print

    // Determine user role
    String userRole = determineUserRole(orgRoleId);
    print('Determined user role: $userRole'); // Debug print

    return userRole;
  }

  // This method determines the user role based on the orgRoleId
  String determineUserRole(String? orgRoleId) {
    int? roleId = int.tryParse(orgRoleId ?? '');
    print("determine roles");
      print(roleId);
    if (roleId == 1) {
      return 'Admin';
    } else if (roleId == 2) {
      return 'Manager';
    } else if (roleId == 3) {
      return 'User';
    } else {
      return 'Unknown Role';
    }
  }
}