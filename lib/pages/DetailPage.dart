  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
import 'package:lapor_firebase/components/komen_dialog.dart';
  import 'package:lapor_firebase/components/status_dialog.dart';
  import 'package:lapor_firebase/components/styles.dart';
  import 'package:lapor_firebase/models/akun.dart';
  import 'package:lapor_firebase/models/laporan.dart';
  import 'package:intl/intl.dart';
  import 'package:url_launcher/url_launcher.dart';

  class DetailPage extends StatefulWidget {
    DetailPage({super.key});
    @override
    State<StatefulWidget> createState() => _DetailPageState();
  }

  class _DetailPageState extends State<DetailPage> {
    final _firestore = FirebaseFirestore.instance;
    bool _isLoading = false;
    bool isShow = true;

    Future launch(String uri) async {
      if (uri == '') return;
      if (!await launchUrl(Uri.parse(uri))) {
        throw Exception('Tidak dapat memanggil : $uri');
      }
    }

    void statusDialog(Laporan laporan) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatusDialog(
            laporan: laporan,
          );
        },
      );
    }

    void komentarDialog(Akun akun, Laporan laporan) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return KomenDialog(
            laporan: laporan,
            akun: akun,
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      Laporan laporan = arguments['laporan'];
      Akun akun = arguments['akun'];

      //laporan.like?.forEach((element) {
        //if (element.email == akun.email) {
          //print(element.email);
          //setState(() {
            //isShow = false;
          //});
        //}
      //});

      //void likePost() async {
        //CollectionReference laporanCollection = _firestore.collection('laporan');
        //try {
          //await laporanCollection.doc(laporan.docId).update({
            //'likes': FieldValue.arrayUnion([
              //{
                //'email': akun.email,
                //'docId': akun.nama,
                //'timestamp': DateTime.now(),
              //}
            //])
          //});
        //} catch (e) {
          //final snackbar = SnackBar(content: Text(e.toString()));
          //ScaffoldMessenger.of(context).showSnackBar(snackbar);
        //} finally {
          //setState(() {
            //isShow = !isShow;
          //});
        //}
      //}

      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:
              Text('Detail Laporan', style: headerStyle(level: 3, dark: false)),
          centerTitle: true,
        ),
        //floatingActionButton: isShow
            //? FloatingActionButton(
              //backgroundColor: Colors.white,
              //onPressed: () {
                //likePost();
              //},
              //child: Icon(Icons.favorite))
            //: null,      
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          laporan.judul,
                          style: headerStyle(level:3),
                        ),
                        SizedBox(height: 15),
                        laporan.gambar != ''
                            ? Image.network(laporan.gambar!)
                            : Image.asset('assets/istock-default.jpg'),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            laporan.status == 'Posted'
                                ? textStatus(
                                    'Posted', Colors.yellow, Colors.black)
                                : laporan.status == 'Process'
                                    ? textStatus(
                                        'Process', Colors.green, Colors.white)
                                    : textStatus(
                                        'Done', Colors.blue, Colors.white),
                            textStatus(
                                laporan.instansi, Colors.white, Colors.black),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: const Center(child: Text('Nama Pelapor')),
                          subtitle: Center(
                            child: Text(laporan.nama),
                          ),
                          trailing: SizedBox(width: 45),
                        ),
                        ListTile(
                          leading: Icon(Icons.date_range),
                          title: Center(child: Text('Tanggal Laporan')),
                          subtitle: Center(
                              child: Text(DateFormat('dd MMMM yyyy')
                                  .format(laporan.tanggal))),
                          trailing: IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: () {
                              launch(laporan.maps);
                            },
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          'Deskripsi Laporan',
                          style: headerStyle(level:3),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(laporan.deskripsi ?? '',
                          textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 30),
                        if (akun.role == 'admin')
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatusDialog(laporan: laporan ,);
                                  });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Ubah Status'),
                          )
                        ),
                        Container(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              komentarDialog(akun, laporan);
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
                        ),
                        SizedBox(height: 20),
                        Text(
                          'List Komentar',
                          style: headerStyle(level:3),
                        ),
                        SizedBox(height: 20),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: ListView.builder(
                              itemCount: laporan.komentar?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        laporan.komentar![index].nama,
                                        style: const TextStyle(
                                          color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        laporan.komentar![index].isi,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                      ],
                    ),
                  );
                }),
        ),
       ],
                    ),
                  ),
              ),
        ), 
      );
    }

    Container textStatus(String text, var bgcolor, var textcolor) {
      return Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          text,
          style: TextStyle(color: textcolor),
        ),
      );
    }
  }