import 'package:flutter/material.dart';
import 'package:p_0_fire/constant.dart';


class ChatDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdite;

  ChatDialog({required this.onDelete, required this.onEdite});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.centerRight,
      title: Text('Actions'),
      elevation: 2,
      backgroundColor: kLightDarkColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: onDelete,
            icon: Icon(Icons.delete,color: Colors.red),
            label: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(height: 10,color: Colors.white,),
          TextButton.icon(
            onPressed: onEdite,
            icon: Icon(Icons.edit,color: Colors.blue),
            label: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(height: 10,color: Colors.white,),

        ],
      ),
    );
  }
}
