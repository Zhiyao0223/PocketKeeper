import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/utils/custom_function.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class ProfileSettingController extends FxController {
  bool isDataFetched = false;

  late Users currentUser;

  // Constructor
  ProfileSettingController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    currentUser = MemberCache.user!;

    isDataFetched = true;
    update();
  }

  Future<bool> updateProfilePicture() async {
    // Select image from gallery
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    // No select image
    if (image == null) {
      return false;
    }

    // Compress image
    image = await compressImageSize(image);

    // Update cache
    MemberCache.user!.profilePicture = await loadXFileAsUint8List(image);

    // Update objectbox
    UserService().updateLoginUser(MemberCache.user!);

    // Upload image to server
    if (MemberCache.user!.profilePicture != null) {
      // Upload image to server
      await uploadProfilePicture(image);
    }
    showToast(customMessage: "Profile picture updated!");

    return true;
  }

  Future<void> uploadProfilePicture(XFile tmpFile) async {
    // Try catch prevent internet connection error
    try {
      const String filename = "update_profile_picture.php";
      Map<String, dynamic> requestBody = {
        "email": currentUser.email,
        "process": "update_profile_picture",
      };

      Map<String, dynamic> responseJson = await ApiService.multipartRequest(
        filename: filename,
        body: requestBody,
        image: tmpFile,
      );

      // Store share preferences if is valid user
      if (responseJson["status"] == 200) {
        // Indicate success login
        log("Update image successful!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  String getTag() {
    return "ProfileSettingController";
  }
}
