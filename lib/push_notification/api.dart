import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey =
      "AAAAJp7kOaQ:APA91bFl2VvHyhmcISIISgPpVbnpdtclxmPBrWcU5iOpOS564AfKDlYufA2CH5mfxY61mdMbb19SZicEqQpD9Qj7E18cRLiOFnaO4dP0s9a_kQ7M3V86uwt8sI4QSDdRtqrxITjzh8x5";

  void sendFcm(String title, String body, List<dynamic> fcmToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"/topics/all_users","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
