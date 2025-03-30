import 'package:shopngo/models/user_model.dart';
import 'package:shopngo/services/auth_service.dart';
import 'package:shopngo/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Profile'),
      ),
      body: StreamBuilder<UserModel?>(
        stream: _authService.currentUser, // Listen to the stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile data.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found.'));
          } else {
            final user = snapshot.data!;
            return _buildProfileContent(user);
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        const SizedBox(height: 20),
        Text(
          user.name ?? 'User Name',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          user.email ?? 'No Email',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}