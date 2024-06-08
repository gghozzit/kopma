import 'package:flutter/material.dart';


class DetailItemPage extends StatefulWidget {
  final String idItem;
  const DetailItemPage({super.key, required this.idItem});


  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}


class _DetailItemPageState extends State<DetailItemPage> {


  @override
  Widget build(BuildContext context) {
    return const Text('Detail Item Page');
  }
}
