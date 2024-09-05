import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/theme.dart';

class ReserveTncWidget extends StatefulWidget {
  final ReserveBayFormBloc formBloc;
  const ReserveTncWidget({
    super.key,
    required this.formBloc,
  });

  @override
  State<ReserveTncWidget> createState() => _ReserveTncWidgetState();
}

class _ReserveTncWidgetState extends State<ReserveTncWidget> {
  List<String> duration = [
    'Tempoh',
    'Enam (6) bulan',
    'Satu (1) bulan',
  ];

  List<String> fees = [
    'Kadar (RM)',
    '720.00',
    '1,220.00',
  ];

  List<String> caj = [
    'Caj Selenggara Petak (RM)',
    '60.00',
    '120.00',
  ];

  List<String> barrier = [
    'Barrier Stand (RM)',
    '220.00',
    '200.00',
  ];

  List<String> sst = [
    'SST 6% (RM)',
    '43.20',
    '86.40',
  ];

  List<String> total = [
    'Jumlah (RM)',
    '1,023.20',
    '1,846.40',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: kBlack.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Syarat-Syarat Sewaan Peletak Kereta Bermusim.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                spaceVertical(
                  height: 20.0,
                ),
                Text(
                  '1.   Kadar sewaan yang dikenakan:',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                spaceVertical(height: 10.0),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    // Header row
                    TableRow(
                      children: <Widget>[
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'No.',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'Tempoh',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'Kadar (RM)',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'Caj Selenggara Petak (RM)',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'Barrier Stand (RM)',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'SST 6% (RM)',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'Jumlah (RM)',
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Data rows
                    ...List<TableRow>.generate(
                      duration
                          .length, // Generate for the rest of the data excluding header
                      (index) {
                        return TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                '${index + 1}.', // Start numbering from 1
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                duration[
                                    index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                fees[
                                    index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                caj[index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                barrier[
                                    index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                sst[index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                total[
                                    index], // Start from index 1 for actual data
                                style: textStyleNormal(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                spaceVertical(height: 10.0),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '2.   Penyewa perlu menjelaskan sepenuhnya bayaran sewaan yang dikenakan sebelum petak letak kereta boleh digunakan. Bayaran boleh dibuat secara tunai, pindahan akaun atau cek atas nama ',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text: 'HIS VISTA SDN BHD.',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text: 'Pembayaran hendaklah dikemukakan ke ',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'HIS VISTA SDN BHD B10, Tingkat 2, Jalan Gambut 25000 Kuantan, Pahang.',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceVertical(height: 10.0),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '3.   Sewaan petak khas adalah untuk kegunaan ',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'memakir kenderaan mulai jam 8.00 pagi – 6.00 petang kecuali hari Ahad dan hari cuti am.',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceVertical(height: 10.0),
                Text(
                  '4.   Pihak syarikat tidak bertanggungjawab ke atas sebarang kerosakan, kecurian harta benda, halangan atau kecederaan ke atas penyewa, tetamu, agen, pelawat, wakil atau tuntutan pihak ketiga akibat daripada penggunaan petak  ini atau kerana papan tanda halangan.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                ),
                spaceVertical(height: 10.0),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '5.   ',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Wang deposit papan tanda halangan (BARRIER STAND) sebanyak RM200.00 ',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'akan dikembalikan sebaik tempoh sewaan tamat dengan syarat papan tanda tersebut dikembalikan dalam keadaan baik dan tiada tunggakkan sewaan petak khas.',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceVertical(height: 10.0),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '6.   Pemohon hendaklah ',
                        style: textStyleNormal(
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'memohon secara bertulis 2 bulan sebelum tempoh penyewaan tamat untuk pembaharuan sewaan .',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceVertical(height: 10.0),
                Text(
                  '7.   Pihak Syarikat berhak menarik balik atau membatalkan sewaan petak khas sekiranya pemohon gagal menjelaskan bayaran sewaan dalam tempoh yang telah ditetapkan.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                ),
                spaceVertical(height: 10.0),
                Text(
                  '8.   Pemohon dikehendaki menjaga kebersihan dan tidak dibenarkan untuk membina sebarang bentuk binaan kekal (cth: konkrit,jerajak besi dan sebagainya) serta membuat sebarang aktiviti perrniagaan atau kerja-kerja penyelenggaraan dalam petak khas tersebut.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                ),
                spaceVertical(height: 10.0),
                Text(
                  '9.   Pemohon tidak dibenarkan untuk memindah milik atau menyerah hak penyewaan tersebut kepada pihak ketiga tanpa mendapat kebenaran secara bertulis dari pihak HVSB.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                ),
                spaceVertical(height: 10.0),
                Text(
                  '10.   Pihak HVSB berhak membatalkan sewaan petak khas serta-merta sekiranya pemohon melanggar mana-mana syarat yang telah ditetapkan.',
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 12.0,
                  ),
                ),
                spaceVertical(height: 10.0),
              ],
            ),
          ),
          CheckboxFieldBlocBuilder(
            booleanFieldBloc: widget.formBloc.tnc,
            body: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Saya/kami telah membaca dan memahami syarat-syarat sewaan petak letak kereta sepertimana dinyatakan di para 1 hingga 10 dan bersetuju mematuhi sepenuhnya syarat-syarat tersebut. Sekiranya saya/kami didapati gagal berbuat demikian boleh menyebabkan kemudahan sewaan petak letak kereta ini ditarik balik tanpa apa-apa notis lanjut daripada Majlis dan pihak His Vista Sdn Bhd.',
                style: textStyleNormal(
                  fontSize: 10.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
