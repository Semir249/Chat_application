import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './chat_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futuresnapShot) {
          if (futuresnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = snapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (ctx, index) => ChatBubble(
                  docs[index]['text'],
                  docs[index]['username'],
                  docs[index]['userImage'],
                  docs[index]['userId'] == futuresnapShot.data.uid,
                  key: ValueKey(docs[index].documentID),
                ),
              );
            },
          );
        });
  }
}
