import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<dynamic>> _transactionFuture;
  final TransactionModel _transactionModel = TransactionModel();
  final Pbt _pbtModel = Pbt();
  final TransactionWalletModel _walletModel = TransactionWalletModel();

  @override
  void initState() {
    super.initState();
    _transactionFuture = _getTransaction();
  }

  Future<List<dynamic>> _getTransaction() async {
    var transactionHistory = await ProfileResources.getTransactionHistory(
        prefix: '/transaction/'); // Transaction data
    var walletData = await ProfileResources.getTransactionWallet(
        prefix: '/payment/wallet-transaction'); // Wallet data

    return [transactionHistory, walletData];
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    Map<String, dynamic> details = arguments?['locationDetail'] ?? {};

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color'] ?? 0xFFFFFFFF),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.transactionHistory,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          setState(() {
            _transactionFuture = _getTransaction();
          });
        },
        child: FutureBuilder<List<dynamic>>(
          future: _transactionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              // Extract data from both futures
              var transactionHistory = snapshot.data![0];
              var walletData = snapshot.data![1];

              // Combine both lists
              var combinedData = [
                ...transactionHistory.map((transaction) => {
                      'type': 'transaction',
                      ...transaction,
                    }),
                ...walletData.map((wallet) => {
                      'type': 'wallet',
                      ...wallet,
                    }),
              ];

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: combinedData.length,
                itemBuilder: (context, index) {
                  var item = combinedData[index];

                  if (item['type'] == 'transaction') {
                    _transactionModel.amount = item["amount"];
                    _transactionModel.description = item["description"];

                    _pbtModel.name = item["pbt"]["name"];

                    // Parse the ISO 8601 timestamp to DateTime
                    DateTime dateTime =
                        DateTime.parse(item["createdAt"]).toLocal();

                    // Format DateTime to 'h:mm a' format
                    String formattedTime =
                        DateFormat('h:mm a').format(dateTime);

                    // Display transaction data
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          '${AppLocalizations.of(context)!.transaction}: ${_transactionModel.description}',
                          style: textStyleNormal(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.amount}: RM${double.parse(_transactionModel.amount!).toStringAsFixed(2)}',
                              style: textStyleNormal(),
                            ),
                            Text(
                              'PBT: ${_pbtModel.name}',
                              style: textStyleNormal(),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.date}: $formattedTime',
                              style: textStyleNormal(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (item['type'] == 'wallet') {
                    _walletModel.amount = item["amount"].toDouble();
                    _walletModel.status = item["status"];

                    // Parse the ISO 8601 timestamp to DateTime
                    DateTime dateTime =
                        DateTime.parse(item["createdAt"]).toLocal();

                    // Format DateTime to 'h:mm a' format
                    String formattedTime =
                        DateFormat('h:mm a').format(dateTime);

                    // Display wallet data
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          _walletModel.status == 'SUCCESS'
                              ? '${AppLocalizations.of(context)!.compoundStatus}: ${_walletModel.status}'
                              : '${AppLocalizations.of(context)!.statusTopUpWallet}: ${_walletModel.status!.toUpperCase()}',
                          style: textStyleNormal(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.amount}: RM${_walletModel.amount!.toStringAsFixed(2)}',
                              style: textStyleNormal(),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.date}: $formattedTime',
                              style: textStyleNormal(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink(); // Fallback if no type matches
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
