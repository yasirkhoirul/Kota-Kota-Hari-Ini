import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/add_detail_bangunan_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_bangunan_cubit.dart'; // Cubit Fetch Data
// Import Dialog yang tadi dibuat// Sesuaikan path-nya

class DetailBangunanPage extends StatefulWidget {
  final int idBangunan;
  final String namaBangunan; // Optional, buat judul AppBar

  const DetailBangunanPage({
    super.key,
    required this.idBangunan,
    required this.namaBangunan,
  });

  @override
  State<DetailBangunanPage> createState() => _DetailBangunanPageState();
}

class _DetailBangunanPageState extends State<DetailBangunanPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<DetailBangunanCubit>().getBangunan(widget.idBangunan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.namaBangunan)),
      // 2. Tombol Tambah (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              // Panggil Dialog yang tadi dibuat
              return AddDetailDialog(
                idBangunan: widget.idBangunan,
                onSuccess: () {
                  // Callback: Refresh data setelah berhasil nambah
                  _fetchData();
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      // 3. List Data
      body: BlocBuilder<DetailBangunanCubit, DetailBangunanState>(
        builder: (context, state) {
          if (state is DetailBangunanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailBangunanError) {
            return Center(child: Text(state.message));
          } else if (state is DetailBangunanLoaded) {
            // Cek jika data kosong
            if (state.data.isEmpty) {
              return const Center(child: Text("Belum ada detail ruangan."));
            }

            // Tampilkan List
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final detail = state.data[index];

                // Card untuk setiap item detail
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // A. Gambar
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                detail
                                    .imagePath, // Sesuaikan field url gambar di entity kamu
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                              ),
                            ),

                            // B. Deskripsi
                            BlocConsumer<AddDetailBangunanCubit, AddDetailBangunanState>(
                              listener: (context, state) {
                                if (state is AddDeleteSuccess) {
                                  context.read<DetailBangunanCubit>().getBangunan(widget.idBangunan);
                                }
                                if (state is AddDetailError) {
                                  showDialog(context: context, builder: (context) => AlertDialog(
                                    title: Icon(Icons.error,color: Colors.redAccent,),
                                    content: Text(state.message),
                                  ),);
                                }
                              },
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail
                                            .deskripsi, // Sesuaikan field deskripsi di entity kamu
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Tambahan info lain jika ada (misal tanggal upload)
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<AddDetailBangunanCubit>().deleteDetail(
                            detail.id,
                            detail.imagePath,
                          );
                        },
                        icon: Icon(Icons.cancel, color: Colors.redAccent),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class AddDetailDialog extends StatefulWidget {
  final int idBangunan;
  final VoidCallback onSuccess;

  const AddDetailDialog({
    super.key,
    required this.idBangunan,
    required this.onSuccess,
  });

  @override
  State<AddDetailDialog> createState() => _AddDetailDialogState();
}

class _AddDetailDialogState extends State<AddDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _deskripsiController = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocListener akan mencari AddDetailBangunanCubit dari context parent (Main)
    return BlocListener<AddDetailBangunanCubit, AddDetailBangunanState>(
      listener: (context, state) {
        if (state is AddDetailSuccess) {
          Navigator.pop(context); // Tutup dialog
          widget.onSuccess(); // Refresh list di halaman belakang
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil menambah detail!"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: AlertDialog(
        title: const Text("Tambah Detail Ruangan"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- GAMBAR ---
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                                ? Image.network(
                                    _selectedImage!.path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Ketuk untuk pilih foto",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- DESKRIPSI ---
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _deskripsiController,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi (misal: Kamar Tidur)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi wajib diisi";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),

          // BlocBuilder mendengarkan state dari Cubit global
          BlocBuilder<AddDetailBangunanCubit, AddDetailBangunanState>(
            builder: (context, state) {
              if (state is AddDetailLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Harap pilih gambar dulu!"),
                        ),
                      );
                      return;
                    }

                    // --- PANGGIL CUBIT ---
                    // Menggunakan context.read karena Cubit sudah ada di tree (Main)
                    context.read<AddDetailBangunanCubit>().addDetail(
                      image: _selectedImage!,
                      idBangunan: widget.idBangunan,
                      deskripsi: _deskripsiController.text,
                    );
                  }
                },
                child: const Text("Simpan"),
              );
            },
          ),
        ],
      ),
    );
  }
}
