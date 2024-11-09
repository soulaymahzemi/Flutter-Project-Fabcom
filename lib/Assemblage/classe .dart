class ListItem {
  final String title;
  final String subtitle;
  final dynamic value; // // Peut être un entier, un double, ou une chaîne

  ListItem({required this.title, required this.subtitle, required this.value});

 // Factory method to create a User object from a JSON map
  factory ListItem.fromJson(Map<String, dynamic> json) {
    return  ListItem(
      value: json['value'],
      title: json['title'],
      subtitle: json['subtitle']
    );
  }




}
