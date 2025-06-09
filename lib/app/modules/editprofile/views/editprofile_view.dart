import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  final controller = Get.find<ProfileController>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usernameController.text = controller.username.value;
    emailController.text = controller.email.value;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Obx(() => CircleAvatar(
              radius: 50,
              backgroundImage: controller.profileImage.value != null
                  ? NetworkImage(controller.profileImage.value!)
                  : AssetImage("assets/default_avatar.png") as ImageProvider,
              child: Icon(Icons.edit),
            )),
          ),
          TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
          TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
          ElevatedButton(
            onPressed: () => controller.saveProfile(usernameController.text, emailController.text),
            child: Text("SAVE CHANGE"),
          ),
        ],
      ),
    );
  }
}
