import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList =
        prefs.getStringList('products') ?? [];

    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> productList =
        products.map((item) => item.toJson()).toList();

    await prefs.setStringList(
      'products',
      productList,
    );
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });

    await saveProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Produk berhasil ditambahkan",
        ),
      ),
    );
  }

  Future<void> updateProduct(
    int index,
    ProductModel product,
  ) async {
    setState(() {
      products[index] = product;
    });

    await saveProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Produk berhasil diperbarui",
        ),
      ),
    );
  }

  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });

    await saveProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Produk berhasil dihapus",
        ),
      ),
    );
  }

  void showForm(
  ProductModel? product,
  int? index,
) {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController =
      TextEditingController(
    text: product?.name ?? "",
  );

  TextEditingController descriptionController =
      TextEditingController(
    text: product?.description ?? "",
  );

  TextEditingController priceController =
      TextEditingController(
    text: product?.price.toString() ?? "",
  );

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        product == null
            ? "Tambah Produk"
            : "Edit Produk",
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Deskripsi tidak boleh kosong";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: priceController,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Harga tidak boleh kosong";
                }

                if (int.tryParse(value) ==
                    null) {
                  return "Harga harus berupa angka";
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!
                .validate()) {
              return;
            }

            final newProduct =
                ProductModel(
              name: nameController.text.trim(),
              description:
                  descriptionController.text
                      .trim(),
              price: int.parse(
                priceController.text.trim(),
              ),
            );

            if (product == null) {
              addProduct(newProduct);
            } else {
              updateProduct(
                index!,
                newProduct,
              );
            }

            Navigator.pop(context);
          },
          child: Text(
            product == null
                ? "Simpan"
                : "Perbarui",
          ),
        ),
      ],
    ),
  );
}

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username =
          prefs.getString('username') ?? '';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 150,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(
                        "https://picsum.photos/id/237/200/300",
                      ),
                    ),
                    const SizedBox(
                        width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            "Hai, Selamat Datang!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .grey[600],
                            ),
                          ),
                          const SizedBox(
                              height: 5),
                          Row(
                            children: [
                              Text(
                                username,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      22,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              const SizedBox(
                                  width: 6),
                              const Icon(
                                Icons
                                    .verified,
                                color: Colors
                                    .blueAccent,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: logout,
                      child: Container(
                        padding:
                            const EdgeInsets
                                .all(12),
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .red
                              .shade50,
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      12),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada produk",
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            products.length,
                        itemBuilder:
                            (context, index) {
                          final product =
                              products[index];

                          return Card(
                            margin:
                                const EdgeInsets
                                    .only(
                              bottom: 12,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          15),
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets
                                      .all(15),

                              leading:
                                  IconButton(
                                icon:
                                    const Icon(
                                  Icons.edit,
                                  color: Colors
                                      .orange,
                                ),
                                onPressed:
                                    () =>
                                        showForm(
                                  product,
                                  index,
                                ),
                              ),

                              title: Text(
                                product.name,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              subtitle:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const SizedBox(
                                      height:
                                          5),
                                  Text(
                                    "Rp ${product.price}",
                                  ),
                                  const SizedBox(
                                      height:
                                          5),
                                  Text(
                                    product
                                        .description,
                                  ),
                                ],
                              ),

                              trailing:
                                  IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .delete,
                                  color: Colors
                                      .red,
                                ),
                                onPressed:
                                    () =>
                                        deleteProduct(
                                  index,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          showForm(null, null);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}