import 'package:flutter/material.dart';
import 'package:myapp/widgets/customAppbar.dart';
import 'package:myapp/widgets/profile_menu.dart';
import 'package:myapp/widgets/section_heading.dart';
import 'package:myapp/widgets/user_image.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Profile'),
        showBackArrow: true,
      ),
      // body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CircularImage(
                      image: 'assets/images/profile.png',
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              // Details
              const SizedBox(
                height: 8,
              ),
              Divider(),
              const SizedBox(
                height: 16,
              ),

              // Heading
              const CustomSectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(
                height: 16,
              ),

              CustomProfileMenu(
                  onPressed: () {}, title: 'Name', value: 'MedLink'),
              const SizedBox(height: 16),
              CustomProfileMenu(
                  onPressed: () {}, title: 'Username', value: 'Thomas_112'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Personal Infomration Section
              const CustomSectionHeading(
                  title: 'Personal Information', showActionButton: false),
              const SizedBox(height: 16),

              CustomProfileMenu(
                  onPressed: () {},
                  title: 'User ID',
                  icon: Iconsax.copy,
                  value: '41996'),
              CustomProfileMenu(
                  onPressed: () {},
                  title: 'E-mail',
                  value: 'thomasquarshie36@gmail.com'),
              CustomProfileMenu(
                  onPressed: () {}, title: 'Contact', value: '0256230766'),
              CustomProfileMenu(
                  onPressed: () {}, title: 'Gener', value: 'Male'),
              CustomProfileMenu(
                  onPressed: () {},
                  title: 'Date of Birth',
                  value: '25 Mar 1995'),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
