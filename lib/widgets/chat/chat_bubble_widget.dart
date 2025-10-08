import 'package:flutter/material.dart';

/// A widget that shows a container with a message and its metadata.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.message =
        'I want to show you something awesome today\n\nthat I believe is often overlooked in Scripture: My sheep (plurality in oneness) listen to my voice; I know them (plurality in oneness), and they (plurality in oneness) follow me. I give them (plurality in oneness) eternal life, and they (plurality in oneness) shall never perish; no one will snatch them (plurality in oneness) out of my hand. My Father, who has given them (plurality in oneness) to me, is greater than all; no one can snatch them (plurality in oneness) out of my Father’s hand. I and the Father are one” (plurality in oneness). Again, his Jewish opponents (plurality in oneness) picked up stones to stone him, but Jesus said to them, (plurality in oneness) “I have shown you many good works (plurality of action) from the Father. (Plurality of source: Jesus along with His Father) For which of these do you stone me? ”We (plurality in oneness) are not stoning you for any good work,” they (plurality in oneness) replied, “but for blasphemy, because you, a mere man, claim to be God.” (for suggesting plurality in God’s oneness with himself). ',
    this.isCurrentUser = false,
    this.userName = 'David',
    this.timestamp = 0,
    this.isAdmin = false,
  });
  final String message;
  final String userName;
  final bool isCurrentUser;
  final int timestamp;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: isCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              isCurrentUser && !isAdmin ? 'Me' : userName,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Now',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(210),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 16, fontFamily: 'Now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              timestamp == 0
                  ? 'Date not available.'
                  : "${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}",
              style: TextStyle(fontSize: 10, fontFamily: 'Now'),
            ),
          ],
        ),
      ],
    );
  }
}
