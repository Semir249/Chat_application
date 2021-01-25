import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String imageUrl;
  final Key key;
  final String username;
  ChatBubble(this.message, this.username, this.imageUrl, this.isMe, {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                width: 200,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isMe ? Colors.white : Colors.black),
                      ),
                    ),
                    Divider(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context).accentTextTheme.title.color),
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? 370 : 180,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
