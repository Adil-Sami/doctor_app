
import 'package:demoadmin/model/labTestAppModel.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
class TestReport {
  final name;
  final age;
  final city;
  final date;
  final type;
  final payment;
  final amount;
  final id;
  final sn;
  final status;
  final phone ;
  final desc ;
  final clinicName;

  const TestReport(
      {this.sn,
        this.name,
        this.age,
        this.id,
        this.city,
        this.date,
        this.amount,
        this.payment,
        this.type,
        this.clinicName,
        this.status,
        this.phone,
        this.desc
      });
}

class TestReportApiPdf {
  static Future<File> generateTable(List<LabTestAppModel> appModel) async {
    final pdf = Document();

    final headers = [
      'SN',
      'Test',
      'Status',
      'Test ID',
      'Name',
      'Age',
      'Phone',
      'City',
      'Clinic',
      'Date',
      'Amount',
      'Payment Status',
      'Description',

    ];

    final List<TestReport> users = [];
    int sn = 1;
    for (var e in appModel) {
      users.add(TestReport(
        sn: sn,
        type: e.serviceName,
        status:getStauss(e.status),
        id: e.id,
        name: e.pName,
        age: e.pAge,
        phone:e.pPhn,
        city: e.pCity,
        clinicName:e.clinicName,
        date: e.createdTimeStamp,
        amount: e.paymentAmount,
        payment:e.pymentStatus ,
        desc:e.pDesc,

      ));
      sn = sn + 1;
    }
    final data = users
        .map((user) => [
      user.sn,
      user.type,
      user.status,
      user.id,
      user.name,
      user.age,
      user.phone,
      user.city,
      user.clinicName,
      user.date,
      user.amount,
      user.payment ,
      user.desc,
    ])
        .toList();

    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
        headerStyle: pw.TextStyle(fontSize: 7),
        cellStyle: pw.TextStyle(fontSize: 7),
      ),
    ));

    return saveDocument(name: 'Lab Test History.pdf', pdf: pdf);
  }

  static Future<File> generateImage() async {
    final pdf = Document();

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
    (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Container(
            height: pageTheme.pageFormat.availableHeight - 1,
            child: Center(
              child: Text(
                'Foreground Text',
                style: TextStyle(color: PdfColors.white, fontSize: 48),
              ),
            ),
          ),
          SvgImage(svg: imageSvg),
          Image(MemoryImage(imageJpg)),
          Center(
            child: ClipRRect(
              horizontalRadius: 32,
              verticalRadius: 32,
              child: Image(
                MemoryImage(imageJpg),
                width: pageTheme.pageFormat.availableWidth / 2,
              ),
            ),
          ),
          GridView(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: [
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
            ],
          )
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String? name,
    Document? pdf,
  }) async {
    final bytes = await pdf!.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }

  static getStauss(status) {
    String value="";
    if(status=="0")
      value="Pending";
    else if(status=="1")
      value="Confirmed";
    else  if(status=="2")
      value="Visited";
    else  if(status=="3")
      value="Canceled";
    return value;
  }
}

