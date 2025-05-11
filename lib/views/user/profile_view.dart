import 'dart:ui';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackAppBar(title: 'Profile'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromARGB(255, 57, 186, 196),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=10',
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 14,
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lloyd Haynes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'callie_parisian@rosenbaum.ca',
                    style: TextStyle(color: Color.fromARGB(255, 230, 229, 229)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileTile(
                          icon: Icons.person_outline,
                          text: 'Account',
                        ),
                        Divider(height: 1),
                        _ProfileTile(
                          icon: Icons.folder_copy,
                          text: 'My projects',
                        ),
                        Divider(height: 1),
                        
                        _ProfileTile(
                          icon: Icons.share,
                          text: 'Share with friends',
                        ),
                        Divider(height: 1),
                        _ProfileTile(icon: Icons.star_border, text: 'Review'),
                        Divider(height: 1),
                        _ProfileTile(icon: Icons.info_outline, text: 'Info'),
                        Divider(height: 1),

                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title: Text(
                            'Log out',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Handle tap action here
                          },
                        ),
                      ],
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

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileTile({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle tap action here
      },
    );
  }
}
