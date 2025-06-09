import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var profileImage = Rxn<String>();
  var lastLogin = ''.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    var response = await http.get(Uri.parse("https://177e-163-227-64-50.ngrok-free.app/api/user/profile"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      username.value = data['username'];
      email.value = data['email'];
      profileImage.value = data['profileImage'];
      lastLogin.value = data['last_login'];
    }
  }

  void saveProfile(String newName, String newEmail) async {
    var response = await http.post(Uri.parse("https://177e-163-227-64-50.ngrok-free.app/api/user/update"),
      body: {"username": newName, "email": newEmail});
    if (response.statusCode == 200) {
      fetchProfile();
      Get.back();
    }
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var request = http.MultipartRequest('POST', Uri.parse("https://177e-163-227-64-50.ngrok-free.app/api/user/upload"));
      request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));
      var res = await request.send();
      if (res.statusCode == 200) {
        fetchProfile();
      }
    }
  }

  void logout() {
    // implement your logic
    Get.offAllNamed('/login');
  }
}
