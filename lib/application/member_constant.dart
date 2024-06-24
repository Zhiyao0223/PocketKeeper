import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/application/model/user.dart';

class MemberConstant {
  static Users user = Users(
    tmpId: 1,
    tmpName: "Xiiaowu",
    tmpEmail: "john@gmail.com",
    tmpProfilePictureUrl: "user_placeholder.jpg",
    tmpRole: Role(tmpId: "2", tmpName: "normal_user"),
    tmpStatus: 0,
    tmpCreatedDate: "2024-05-26 16:22:52",
    tmpUpdatedDate: "2024-05-26 16:22:52",
  );
  static AppSetting appSetting = AppSetting();

  // This function is to reset cache
  reset() {
    user = Users();
    appSetting = AppSetting();
  }

  // Local database
  static ObjectBox? objectBox;
}
