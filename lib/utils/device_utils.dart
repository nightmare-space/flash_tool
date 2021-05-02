class DeviceUtils {
  DeviceUtils._();
  static final Map<String, String> _map = <String, String>{
    'platina': '小米8青春版',
    'umi': '小米10',
    'santoni': 'redmi4x',
  };
  static String getName(String id) {
    return _map[id] ?? id;
  }
}
