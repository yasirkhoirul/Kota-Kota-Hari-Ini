import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/tambahkota_cubit.dart';

class TambahkotaPage extends StatefulWidget {
  const TambahkotaPage({super.key});

  @override
  State<TambahkotaPage> createState() => _TambahkotaPageState();
}

class _TambahkotaPageState extends State<TambahkotaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _deskripsipanjangController =
      TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _deskripsipanjangController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 800,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- Input Gambar ---
              BlocBuilder<TambahkotaCubit, TambahkotaState>(
                builder: (context, state) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: context.read<TambahkotaCubit>().pickImage,
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: (state is TambahKotaPickGambar)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  state.byte!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  Text("Ketuk untuk tambah foto"),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
          
              // --- Form Input ---
              TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: "Nama Kota"),
                  // Validator: Logika pengecekan
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Kota tidak boleh kosong';
                    }
                    return null; // Null artinya valid
                  },
                ),
                const SizedBox(height: 10),
          
                TextFormField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(labelText: "Deskripsi Singkat"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi Singkat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
          
                TextFormField(
                  controller: _deskripsipanjangController,
                  decoration: const InputDecoration(labelText: "Deskripsi Panjang"),
                  maxLines: 3, // Biar agak lebar untuk deskripsi panjang
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi Panjang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
          
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(labelText: "Lokasi"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
          
                // --- Tombol Submit ---
                BlocBuilder<TambahkotaCubit, TambahkotaState>(
                  builder: (context, state) {
                    if (state is TambahKotaPickGambar) {
                      return ElevatedButton(
                        onPressed: () {
                          // 3. Cek Validasi di sini sebelum kirim data
                          if (_formKey.currentState!.validate()) {
                            // Jika Valid, baru jalankan logic kirim
                            DateTime createdAt = DateTime.now();
                            
                            context.read<TambahkotaCubit>().tambahkotaform(
                                  state.byte!,
                                  _namaController.text,
                                  state.mimeType!,
                                  _deskripsiController.text,
                                  _deskripsipanjangController.text,
                                  createdAt.toString(),
                                  _lokasiController.text,
                                );
                          } else {
                            // Jika tidak valid, otomatis muncul tulisan merah di bawah textfield
                            print("Form tidak valid"); 
                          }
                        },
                        child: const Text("Kirim"),
                      );
                    } else if (state is TambahkotaError) {
                      return Column(
                        children: [Text("Terjadi kesalahan: ${state.message}")],
                      );
                    } else if (state is TambahkotaLoading || state is TambahkotaLoadingUpGambar) {
                      return Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Sedang memproses data..."),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text(state.toString()),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
