
import 'dart:io';
import 'package:demoadmin/model/attendance_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
class WorkerAttReport {
  final sn;
  final name;
  final clinicName;
  final taskTitle;
  final dateTime;
  final checkOut;
  final workTime;

  const WorkerAttReport(
      {
        this.sn,
    this.taskTitle,
        this.dateTime,
        this.clinicName,
        this.name,
        this.checkOut,
        this.workTime
      });
}

class WorkerAttReportApiPdf {
  final clinicName;
  WorkerAttReportApiPdf({this.clinicName});

   Future<File> generateTable(List<AttendanceModel> appModel) async {
    final pdf = Document();

    final headers = [
      'SN',
      'Name',
      'Clinic',
      'Task',
      'Check-in',
      'Check-out',
      'Work Time'
    ];

    final List<WorkerAttReport> users = [];
    int sn = 1;
    for (var e in appModel) {
      users.add(WorkerAttReport(
        sn: sn,
        name:"${e.firstName} ${e.lastName}",
        clinicName: clinicName??"",
        taskTitle: e.task_title,
        dateTime: e.time_stamp,
          checkOut: e.end_time_stamp==null?"--":e.end_time_stamp,
          workTime: e.end_time_stamp==null?"--":getWorkHour(e.time_stamp,e.end_time_stamp)


      ));
      sn = sn + 1;
    }
    final data = users
        .map((user) => [
      user.sn,
      user.name,
      user.clinicName,
      user.taskTitle,
      user.dateTime,
      user.checkOut,
      user.workTime
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

    return saveDocument(name: 'Worker Attendance History.pdf', pdf: pdf);
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
  getWorkHour(time_stamp, end_time_stamp) {
    final checkinTime=DateTime.parse(time_stamp);
    final checkoutTime=DateTime.parse(end_time_stamp);
    final timeDiff=checkoutTime.difference(checkinTime);
    return "${(timeDiff.inMinutes/60).toInt()}Hour:${(timeDiff.inMinutes%60).toInt()}Minute";
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

