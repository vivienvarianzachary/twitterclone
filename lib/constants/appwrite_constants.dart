class AppwriteConstants {
  static const String databaseId = '643a3070e74444e9794f';
  static const String projectId = '642ceceb8328ebfbed99';
  static const String endPoint = 'https://baas.pasarjepara.com/v1';
  static const String usersCollection = '6465b13cd39d29adf948';
  static const String tweetsCollection = '648438ece36a7fdc500b';
  static const String imagesBucket = '64844fbae2f178ef174e';
  static String imageUrl(String imageId) => 
  '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}