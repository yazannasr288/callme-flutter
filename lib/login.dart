import 'package:callme/Homepage.dart';
import 'package:callme/callservices.dart';
import 'package:callme/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController();
  final TextEditingController id = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();


  Future<void> registerToServer(String username, String id) async {
    final url = Uri.parse("https://bisque-louse-748777.hostingersite.com/callme/signup.php"); // استبدل بالرابط الفعلي
    final response = await http.post(
      url,
      body: {
        "username": username,
        "id": id,
      },
    );

    if (response.statusCode == 200) {
      if (response.body == "success") {
        print("تمت إضافة المستخدم إلى قاعدة البيانات");
      } else if (response.body == "exists") {
        print("المستخدم موجود بالفعل");
      } else {
        print("استجابة غير متوقعة: ${response.body}");
      }
    } else {
      print("فشل في الاتصال بالسيرفر: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // لون خلفية خفيف
      appBar: AppBar(
        title: const Text("تسجيل الدخول"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.lock_person, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                    TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: "اسم المستخدم",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "الرجاء إدخال اسم المستخدم";
                      } else if (val.trim().length <= 3) {
                        return "يجب أن يكون الاسم أطول من 3 أحرف";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                      TextFormField(
                        controller: id,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "المعرّف (ID)",
                          prefixIcon: const Icon(Icons.vpn_key),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "الرجاء إدخال المعرّف";
                          } else if (val.trim().length < 2) {
                            return "يجب أن يكون المعرّف مكونًا من حرفين على الأقل";
                          }
                          return null;
                        },
                      ),


                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (globalKey.currentState!.validate()) {
                    sharedPreferences.setString("id", id.text);
                    sharedPreferences.setString("username", username.text);

                    await registerToServer(username.text.trim(), id.text.trim());

                    Callservices callservices = Callservices();
                    callservices.onUserLogin(id.text, username.text);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Homepage()),
                          (route) => false,
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
