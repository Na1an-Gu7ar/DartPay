// A lightweight wrapper around installed UPI app information.
// The original SDK app object is kept as dynamic so the UI stays package-agnostic.
class UpiAppModel {
  final String name;
  final String packageName;
  final dynamic sdkApp;

  const UpiAppModel({
    required this.name,
    required this.packageName,
    required this.sdkApp,
  });
}
