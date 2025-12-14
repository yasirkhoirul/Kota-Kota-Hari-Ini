import 'dart:io'; // WAJIB: Untuk File
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // WAJIB: Image Picker
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/add_bangunan_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/bangunan_kota_cubit.dart';

// PASTIKAN ANDA MENGIMPORT FILE DEPENDENCY INJECTION (DI) ANDA
// import 'package:kota_kota_hari_ini/injection_container.dart' as di; 
// Atau sesuaikan cara anda memanggil Cubit

class BangunanKotaPage extends StatefulWidget {
  final String idKota;

  const BangunanKotaPage({super.key, required this.idKota});

  @override
  State<BangunanKotaPage> createState() => _BangunanKotaPageState();
}

class _BangunanKotaPageState extends State<BangunanKotaPage> {
  @override
  void initState() {
    super.initState();
    // Load data awal
    context.read<BangunanKotaCubit>().getBangunan(widget.idKota);
  }

  // --- FUNGSI MENAMPILKAN DIALOG INPUT ---
  void _showAddDialog(BuildContext rootContext) {
    showDialog(
      context: rootContext,
      builder: (context) {
        // Kita bungkus Dialog dengan BlocProvider untuk AddBangunanCubit
        // Asumsi: Anda menggunakan GetIt/DI, sesuaikan 'create' nya
        return _DialogContent(
            idKota: int.parse(widget.idKota),
            onSuccess: () {
              // Refresh list di halaman utama setelah sukses add
              rootContext.read<BangunanKotaCubit>().getBangunan(widget.idKota);
            },
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Bangunan")),
      
      // --- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),

      // --- LIST VIEW (Kode lama anda) ---
      body: BlocBuilder<BangunanKotaCubit, BangunanKotaState>(
        builder: (context, state) {
          if (state is BangunanKotaLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BangunanKotaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context.read<BangunanKotaCubit>().getBangunan(widget.idKota),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }
          if (state is BangunanKotaLoaded) {
            if (state.data.isEmpty) return const Center(child: Text("Kosong"));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.data.length,
              itemBuilder: (context, index) => _buildBangunanCard(state.data[index],widget.idKota),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBangunanCard(BangunanEntity bangunan,String idkota) {
    return InkWell(
      onTap: () => context.pushNamed('detailbangunankota',pathParameters: {
        'id':idkota,
        'idbangunan':bangunan.id.toString(),
      }),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            SizedBox(
              height: 200, 
              width: double.infinity,
              child: Image.network(bangunan.imagePath, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.error)),
            ),
            ListTile(
              title: Text(bangunan.deskripsi),
              subtitle: Text("ID Kota: ${bangunan.idKota}"),
            )
          ],
        ),
      ),
    );
  }
}

// --- WIDGET ISI DIALOG (Form & Logic Upload) ---
class _DialogContent extends StatefulWidget {
  final int idKota;
  final VoidCallback onSuccess;

  const _DialogContent({required this.idKota, required this.onSuccess});

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final _deskripsiController = TextEditingController();
  XFile? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listener untuk menutup dialog jika sukses
    return BlocListener<AddBangunanCubit, AddBangunanState>(
      listener: (context, state) {
        if (state is AddBangunanSuccess) {
          Navigator.pop(context); // Tutup dialog
          widget.onSuccess(); // Refresh list induk
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil!")));
        } else if (state is AddBangunanError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AlertDialog(
        title: const Text("Tambah Bangunan"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- IMAGE PICKER ---
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage != null
                        ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.camera_alt), Text("Pilih Foto")],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // --- INPUT DESKRIPSI ---
                TextFormField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  validator: (v) => v!.isEmpty ? "Isi deskripsi" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          
          // --- TOMBOL SIMPAN ---
          BlocBuilder<AddBangunanCubit, AddBangunanState>(
            builder: (context, state) {
              if (state is AddBangunanLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _selectedImage != null) {
                    // Panggil Event AddBangunan
                    context.read<AddBangunanCubit>().onsubmit
                    (
                      _deskripsiController.text,
                       _selectedImage!,
                       widget.idKota,
                    );
                  } else if (_selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Foto wajib dipilih!")));
                  }
                },
                child: const Text("Simpan"),
              );
            },
          )
        ],
      ),
    );
  }
}