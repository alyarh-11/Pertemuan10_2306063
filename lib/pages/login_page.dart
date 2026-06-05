import 'package:flutter/material.dart';
import 'package:pertemuan10_2306063/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  // Tambahan: Controller untuk password
  final TextEditingController passwordController = TextEditingController();
  // Tambahan: Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    // Tambahan: Cek apakah validasi username & password sudah terisi semua
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogin", true);
      await prefs.setString("username", usernameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage())
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25), // Perbaikan typo bawaan: .all -> const EdgeInsets.all
              child: Form(
                key: _formKey, // Tambahan: Bungkus dengan Form untuk validasi
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.green,),
                    const SizedBox(height: 20,),
                    // Mengubah TextField menjadi TextFormField agar bisa menggunakan fungsi validator
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), // Perbaikan typo bawaan: .circular -> BorderRadius.circular
                        )
                      ),
                      // Tambahan: Validasi username
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    // Tambahan: Input untuk Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: true, // Menyembunyikan teks password
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      // Tambahan: Validasi password
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Perbaikan typo bawaan: .circular -> BorderRadius.circular
                          )
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}