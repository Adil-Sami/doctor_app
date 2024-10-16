
import 'dart:io';
import 'package:demoadmin/model/pharma_req_model.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
class PharmaReport {
  final sn;
  final name;
  final phone;
  final title;
  final status;
  final date;

  const PharmaReport(
      {this.sn,
        this.name,
        this.phone,
        this.title,
        this.status,
        this.date
      });
}

class PharmaReportApiPdf {
  static Future<File> generateTable(List<PharmacyReqModel> appModel) async {
    final pdf = Document();

    final headers = [
      'SN',
      'Title',
      'Status',
      'Name',
      'Phone',
      'Date'

    ];

    final List<PharmaReport> users = [];
    int sn = 1;
    for (var e in appModel) {
      users.add(PharmaReport(
        sn: sn,
        title: e.desc,
        status: e.status=="0"?
        "Pending":e.status=="1"?"Confirmed":
        e.status=="2"?"Delivered": e.status=="3"?"Canceled":"Not Updated",
        name: "${e.firstName} ${e.lastName}",
        phone:e.phone,
        date: e.createdTimeStamp,

      ));
      sn = sn + 1;
    }
    final data = users
        .map((user) => [
      user.sn,
      user.title,
      user.status,
      user.name,
      user.phone,
      user.date,
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

    return saveDocument(name: 'Pharma Test History.pdf', pdf: pdf);
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


}

