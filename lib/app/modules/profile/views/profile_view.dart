import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
        children: [
          Container(
            color: Colors.teal[700],
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImage.value != null
                      ? NetworkImage(controller.profileImage.value!)
                      : AssetImage("assets/default_avatar.png") as ImageProvider,
                ),
                Text(controller.username.value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(controller.email.value),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/edit-profile'),
                  child: Text('EDIT PROFILE'),
                ),
              ],
            ),
          ),
          ListTile(title: Text("Privacy Policy"), trailing: Icon(Icons.arrow_forward_ios), onTap: () => Get.toNamed('/privacy-policy')),
          ListTile(title: Text("FAQ"), trailing: Icon(Icons.arrow_forward_ios), onTap: () => Get.toNamed('/faq')),
          ListTile(title: Text("Sign In History\nLast login: ${controller.lastLogin.value}"), trailing: Icon(Icons.expand_more)),
          ListTile(title: Text("Sign Out"), trailing: Icon(Icons.logout), onTap: controller.logout),
        ],
      )),
    );
  }
}
