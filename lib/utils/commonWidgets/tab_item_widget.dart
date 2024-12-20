import 'package:flutter/material.dart';

class TabItemWidget extends StatelessWidget {
  final String title;
  final int count;

  const TabItemWidget({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}