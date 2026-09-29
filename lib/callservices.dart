import 'package:callme/constant.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class Callservices{
  Future<void> onUserLogin(String id, String username) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Constant.appId /*input your AppID*/,
      appSign: Constant.appSign /*input your AppSign*/,
      userID:id,
      userName: username,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  void onUserLogout() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

}