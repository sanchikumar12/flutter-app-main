class DeliveryTypes {
  static String STANDARD = 'Standard';
  static String EXPRESS = 'Express';
  static String SPECIAL = 'Special';
  static String NONE = 'None';
  String type;
  bool enabled;
  String enabledMessage;
  double charge;
  String message;

  DeliveryTypes.none()
      : type = DeliveryTypes.NONE,
        enabled = false,
        enabledMessage = '',
        charge = 0,
        message = '';

  DeliveryTypes.clone(DeliveryTypes e) {
    this.charge = e.charge;
    this.enabled = e.enabled;
    this.enabledMessage = e.enabledMessage;
    this.message = e.message;
    this.type = e.type;
  }

  DeliveryTypes.fromMap(String type, Map<String, dynamic> snap) {
    this.type = type[0].toUpperCase() + type.substring(1).toLowerCase();
    this.enabled = snap['enabled'];
    this.enabledMessage = snap['enabledMessage'];
    this.message = snap['message'];
    this.charge = double.tryParse("${snap['charge']}") ?? 0;
  }
}
