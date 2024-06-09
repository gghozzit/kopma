import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl untuk menggunakan NumberFormat
import 'package:kopma/data/model/transaction/transaction_model.dart';

import '../data/datasource/network/firebase_transaction_datasource.dart';

class HistoryPage extends StatelessWidget {
  final FirebaseTranscationDataSource _dataSource = FirebaseTranscationDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Transaksi'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _dataSource.getListTransaction(null).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada transaksi'));
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

            // Buat objek NumberFormat untuk memformat nominal rupiah dengan tanda koma
            final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Image.network(transaction.itemImage, fit: BoxFit.cover),
                    ),
                    title: Text(
                      transaction.itemName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Penjual: ${transaction.sellerName}'),
                        Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(transaction.dateTime)}'),
                        Text('Jumlah: ${transaction.itemQuantity}'),
                        Text('Harga: ${currencyFormat.format(transaction.itemPrice)}'),
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
