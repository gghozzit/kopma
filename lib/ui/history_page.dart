import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kopma/data/model/transaction/transaction_model.dart';

import '../data/datasource/network/firebase_transaction_datasource.dart';

class HistoryPage extends StatelessWidget {
  final FirebaseTranscationDataSource _dataSource = FirebaseTranscationDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _dataSource.getListTransaction(null).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No transactions found'));
          } else {
            final transactions = snapshot.data!.docs.map((doc) {
              final data = doc.data()!;
              return TransactionModel(
                id: doc.id,
                dateTime: (data['dateTime'] as Timestamp).toDate(),
                itemId: data['itemId'],
                itemName: data['itemName'],
                itemImage: data['itemImage'],
                itemQuantity: data['itemQuantity'],
                itemPrice: data['itemPrice'],
                buyerId: data['buyerId'],
                buyerName: data['buyerName'],
                buyerEmail: data['buyerEmail'],
                buyerAddress: data['buyerAddress'],
                buyerMoney: data['buyerMoney'],
                sellerId: data['sellerId'],
                sellerName: data['sellerName'],
                sellerEmail: data['sellerEmail'],
                sellerAddress: data['sellerAddress'],
                sellerImage: data['sellerImage'],
              );
            }).toList();

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: Center(child: Image.network(transaction.itemImage, fit: BoxFit.cover)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                transaction.itemName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text('Seller: ${transaction.sellerName}'),
                              Text('Date: ${transaction.dateTime}'),
                              Text('QTY: ${transaction.itemQuantity}'),
                              Text('Rp.${transaction.itemPrice}'),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
