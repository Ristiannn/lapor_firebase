import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapor_firebase/components/styles.dart';
import 'package:lapor_firebase/models/akun.dart';
import 'package:lapor_firebase/models/laporan.dart';

class KomenDialog extends StatefulWidget {
  final Akun akun;
  final Laporan laporan;

  const KomenDialog({
    required this.akun,
    required this.laporan,
  });

  @override
  _KomenDialogState createState() => _KomenDialogState();
}

class _KomenDialogState extends State<KomenDialog> {
  late String status;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _komenController = TextEditingController();

  void addKomentar() async {
    CollectionReference transaksiCollection = _firestore.collection('laporan');

    // Convert DateTime to Firestore Timestamp

    try {
      if (_komenController.text != '') {
        await transaksiCollection.doc(widget.laporan.docId).update({
          'komentar': FieldValue.arrayUnion([
            {
              'nama': widget.akun.nama,
              'isi': _komenController.text,
            }
          ]),
        });
      }

      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.laporan.judul,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _komenController,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Komentar',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addKomentar();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Tambah Komentar'),
            ),
          ],
        ),
      ),
    );
  }
}