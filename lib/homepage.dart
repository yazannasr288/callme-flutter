import 'package:callme/callservices.dart';
import 'package:callme/login.dart';
import 'package:callme/main.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Callservices callservices = Callservices();

  late Future<List<Map<String, dynamic>>> futureUsers;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http.get(
      Uri.parse("https://bisque-louse-748777.hostingersite.com/callme/getuser.php"),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("فشل في تحميل المستخدمين");
    }
  }

  @override
  void initState() {
    super.initState();
    callservices.onUserLogin(
      sharedPreferences.getString("id")!,
      sharedPreferences.getString("username")!,
    );
    futureUsers = fetchUsers();
  }

  void callUser(String userId, String userName, bool isVideo) {
    ZegoUIKitPrebuiltCallInvitationService().send(
      resourceID: "yazan",
      invitees: [ZegoCallUser(userId, userName)],
      isVideoCall: isVideo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الصفحة الرئيسية",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "المستخدمون",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("حدث خطأ أثناء تحميل المستخدمين"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("لا يوجد مستخدمون"));
                  }

                  final users = snapshot.data!;

                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user["user_name"]),
                        subtitle: Text("ID: ${user["user_num"]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.videocam, color: Colors.deepPurple),
                              tooltip: "مكالمة فيديو",
                              onPressed: () => callUser(
                                user["user_num"].toString(),
                                user["user_name"],
                                true,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              tooltip: "مكالمة صوتية",
                              onPressed: () => callUser(
                                user["user_num"].toString(),
                                user["user_name"],
                                false,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                callservices.onUserLogout();
                sharedPreferences.clear();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("تسجيل الخروج"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
