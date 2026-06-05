import 'package:flutter/material.dart';
import 'package:pertemuan10_2306063/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("username") ?? "";
    });
  }

  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFDA7A54), // Perbaikan typo bawaan: kode Hex warna harus diawali 0xFF agar valid

    body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), // Perbaikan typo bawaan: .symmetric -> const EdgeInsets.symmetric
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Perbaikan typo bawaan: .circular -> BorderRadius.circular
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                "https://picsum.photos/seed/picsum/200/300",
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo, Selamat Datang!",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6,),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 20,
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      // Tambahan: Dibungkus dengan InkWell agar Container di dalamnya bisa mendeteksi klik/tekan tombol logout
                      InkWell(
                        onTap: logout,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                          color:  Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8
                            ),
                          ],
                         ),
                         child: const Icon(
                          Icons.logout,
                          size: 28,
                          color: Colors.red,
                         ),
                        ),
                      )
                    ],
                  )
                ],
              )
              )
          ],
        ),
      ),
    )
    ),
    );
  }
}