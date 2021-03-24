import 'package:flutter/material.dart';

class HeavyLoadingModal extends StatelessWidget {
  final String message;
  HeavyLoadingModal({this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.2,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            message,
            style:
                TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
          ),
          Expanded(child: SizedBox()),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
