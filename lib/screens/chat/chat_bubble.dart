import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.message =
        'I want to show you something awesome today\n\nthat I believe is often overlooked in Scripture: My sheep (plurality in oneness) listen to my voice; I know them (plurality in oneness), and they (plurality in oneness) follow me. I give them (plurality in oneness) eternal life, and they (plurality in oneness) shall never perish; no one will snatch them (plurality in oneness) out of my hand. My Father, who has given them (plurality in oneness) to me, is greater than all; no one can snatch them (plurality in oneness) out of my Father’s hand. I and the Father are one” (plurality in oneness). Again, his Jewish opponents (plurality in oneness) picked up stones to stone him, but Jesus said to them, (plurality in oneness) “I have shown you many good works (plurality of action) from the Father. (Plurality of source: Jesus along with His Father) For which of these do you stone me? ”We (plurality in oneness) are not stoning you for any good work,” they (plurality in oneness) replied, “but for blasphemy, because you, a mere man, claim to be God.” (for suggesting plurality in God’s oneness with himself). ',
    this.currentUser = false,
    this.userName = 'David',
    this.datetime = 0,
  });
  final String message;
  final String userName;
  final bool currentUser;
  final int datetime;

  _convertTimestampToDateTime() {
    // var timestamp = 230523110326;

    // var components = <int>[];
    // for (var i = 0; i < 6; i += 1) {
    //   components.add(timestamp % 100);
    //   timestamp = timestamp ~/ 100;
    // }

    // var [seconds, minutes, hour, twoDigitYear, month, day] = components;
    // var year = fromTwoDigitYear(twoDigitYear); // See below.

    // var dateTime = DateTime(year, month, day, hour, minutes, seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: currentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              currentUser ? 'Me' : userName,
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
                  crossAxisAlignment: currentUser
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
              '09/15/2025, 3:09PM',
              style: TextStyle(fontSize: 10, fontFamily: 'Now'),
            ),
          ],
        ),
      ],
    );
  }
}
