import 'package:flutter/material.dart';
import 'package:lapor_firebase/models/akun.dart';

class MyLaporan extends StatefulWidget {
  final Akun akun;
  const MyLaporan({super.key, required this.akun});

  @override
  State<MyLaporan> createState() => _MyLaporanState();
}

class _MyLaporanState extends State<MyLaporan> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('My Laporan'),
      );
  }
}