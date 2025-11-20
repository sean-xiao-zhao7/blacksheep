/// Chat Model
/// Not in use at the moment.
class Chat {
  const Chat({
    required this.id,
    required this.approved,
    required this.menteeFirstName,
    required this.menteeLastName,
    required this.menteeUid,
    required this.mentorFirstName,
    required this.mentorLastName,
    required this.mentorUid,
    required this.messages,
    required this.type,
    required this.disabled,
  });

  final String id;
  final bool approved;
  final String menteeFirstName;
  final String menteeLastName;
  final String menteeUid;
  final String mentorFirstName;
  final String mentorLastName;
  final String mentorUid;
  final Map<dynamic, dynamic> messages;
  final String type;
  final bool disabled;

  bool get isPhone {
    return type == 'phone';
  }
}
