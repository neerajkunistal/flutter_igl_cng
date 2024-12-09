import 'dart:collection';

import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void main() {

  final linkedList = LinkedList<DataEntry>();
  linkedList.add(DataEntry('Item 1'));
  linkedList.add(DataEntry('Item 2'));
  linkedList.add(DataEntry('Item 3'));
  for (final entry in linkedList) {
    print(entry);
  }
  linkedList.map((element) {
     print(element);
  }).toString();
}

final class DataEntry extends LinkedListEntry<DataEntry> {
  final String data;
  DataEntry(this.data);
  @override
  String toString() {
    return 'DataEntry{data: $data}';
  }
}