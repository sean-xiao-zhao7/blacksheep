/// Chat Message Model
class Message {
  const Message(this.id, this.mentee, this.message, this.timestamp);

  final String id;
  final bool mentee;
  final String message;
  final int timestamp;
}
