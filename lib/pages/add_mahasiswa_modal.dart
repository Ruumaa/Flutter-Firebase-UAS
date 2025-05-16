import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMahasiswaModal extends StatefulWidget {
  const AddMahasiswaModal({super.key});

  @override
  State<AddMahasiswaModal> createState() => _AddMahasiswaModalState();
}

class _AddMahasiswaModalState extends State<AddMahasiswaModal> {
  final nimController = TextEditingController();
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void simpanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('mahasiswa').add({
        'nim': nimController.text,
        'nama': namaController.text,
        'jurusan': jurusanController.text,
        'waktu': FieldValue.serverTimestamp(),
      });

      // Tutup modal
      Navigator.pop(context);

      // Tampilkan snackbar di halaman utama
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data mahasiswa berhasil ditambahkan!"),
          backgroundColor: Color(0xFF4DB6AC),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Tambah Mahasiswa",
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF4DB6AC), fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // NIM Field
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Nama Field
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Jurusan Field
              TextFormField(
                controller: jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jurusan tidak boleh kosong';
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
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : simpanData,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text("Simpan"),
        ),
      ],
    );
  }
}
