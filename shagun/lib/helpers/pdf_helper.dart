import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quiver/iterables.dart';

class PdfHelper {
  static int index = 0;
  
  static Future<pw.Document> exportEvent(eventData, List guestData)
  async {
    final pdf = pw.Document();
    pw.ImageProvider? netImage;
    if(eventData['photo'] != null) {
      netImage = await networkImage(eventData['photo']);
    }
    index = 0;

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {

          return [
              pw.Column(
                children: [
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.green, width: 1.5),
                      children: [
                        buildRow('With blessings of', eventData!['guru']),
                        buildRow('Event:', eventData!['name']),
                        buildRow('Hosted by', eventData!['host']),
                        buildRow(
                            'Date:',
                            DateFormat('EEEE, MMM d, yyyy')
                                .format(eventData!['date'].toDate())),
                        buildRow('Venue:', eventData!['venue']),
                        pw.TableRow(children: [
                          pw.Text('Photo:', style: const pw.TextStyle(
                              fontSize: 15.0
                          )),
                          eventData!['photo'] != null
                              ? pw.Image(netImage!, height: 300)
                              : pw.Container()
                        ])
                      ]
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 4),
                    child: pw.Text(
                      'Guests',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                  pw.Column(
                      children: [
                        pw.Text('No. of guest: ${guestData.length}'),
                        buildGuestsTable(guestData.take(10))
                      ]
                  )
                ]
              ),
              ...partition(guestData.skip(10).toList(), 20).map((sublist) =>
                  buildGuestsTable(sublist)).toList()
            ];// Center
        }));

    return pdf;
  }

  static pw.TableRow buildRow(String label, String? value) {
    return pw.TableRow(
      children: [
        pw.Text("$label ", style: const pw.TextStyle(fontSize: 15.0)),
        pw.Text(value ?? '', style: const pw.TextStyle(fontSize: 15.0))
      ],
    );
  }

  static pw.Text buildCell(String? value) {
    return pw.Text(value?? '', style: const pw.TextStyle(fontSize: 15.0));
  }

  static pw.Widget buildHeadCell(String label) {
    return pw.Text(
            "$label ", 
            style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold)
        );
  }
  
  static pw.Widget buildGuestsTable(guestData) {
    return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.green, width: 1.5),
        children: [
          pw.TableRow(
              children: [
                buildHeadCell('S. No.'),
                buildHeadCell('Guest list'),
                buildHeadCell('Nickname'),
                buildHeadCell('Relation'),
                buildHeadCell('Gift'),
                buildHeadCell('Cash'),
                buildHeadCell('Jewellery'),
              ]
          ),
          ...guestData.map((data) => pw.TableRow(
              children: [
                buildCell('${++index}'),
                buildCell(data['guest_list']),
                buildCell(data['nickname']),
                buildCell(data['relation']),
                buildCell(data['gift']),
                buildCell(data['cash']),
                buildCell(data['jewellery']),
              ]
          )).toList()
        ]
    );
  }
}



