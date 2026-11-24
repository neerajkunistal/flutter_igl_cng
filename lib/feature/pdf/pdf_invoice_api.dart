import 'dart:io';

import 'package:flutter_igl_cng/feature/pdf/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'pdf_model.dart';

class PdfInvoiceApi {
  static Future<File> generate(PdfModel pdfData) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(pdfData),
        SizedBox(height: 3 * PdfPageFormat.cm),
/*        buildTitle(pdfData),
        buildInvoice(pdfData),*/
        Divider(),
/*        buildTotal(pdfData),*/
      ],
/*      footer: (context) => buildFooter(pdfData),*/
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(PdfModel pdfData) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Other Complaint", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(height: 3 * PdfPageFormat.point),
              Text("Complaint Id : ${pdfData.complaintId}")
            ]
          ),
          Container(
            height: 50,
            width: 50,
            child: pw.Image(pw.MemoryImage(pdfData.image!)),
          ),
        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${pdfData.stationName}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                SizedBox(height: 3 * PdfPageFormat.point),
                Text("Equipment Id : ${pdfData.equipmentId}")
              ]
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Complaint Date : ${pdfData.complaintData}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                SizedBox(height: 3 * PdfPageFormat.point),
                Text("Complaint Status : ${pdfData.complaintStatus}")
              ]
          ),
        ],
      ),
    ],
  );

}