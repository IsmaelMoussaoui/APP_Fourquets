import 'dart:io';
import 'package:commandes/models/Product.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

reportView(context, List<Product> _cart) async
{
  final Document pdf = Document();

  pdf.addPage(MultiPage(
      pageFormat:
      PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1)
          return null;
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Commandes',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Header(level: 0, child: Text('Commandes', textScaleFactor: 2)),
        for(int i = 0; i != _cart.length; i++)
          Header(level: 1, text: _cart.where((element) => element.provider == "" ).toList().toString()),
              Paragraph(text: _cart.where((element) => element.provider == "Société").toString()),
        Padding(padding: const EdgeInsets.all(10)),
        ]),
      );
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  OpenFile.open('$dir/report.pdf');
  //material.Navigator.of(context).push(
  //  material.MaterialPageRoute(
  //    builder: (_) => ViewPDF(path: path),
  //  ),
}
