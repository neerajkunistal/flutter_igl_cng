import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/firebase_device_model.dart';
import "package:googleapis_auth/auth_io.dart";
import "package:http/http.dart" as http;

class NotificationHelper {
  static Future<dynamic> sendNotification({
    required List<FirebaseDeviceModel> firebaseDeviceList,
    required String title,
    required String body,
    required String pageId,
    required String complaintId,
    required String dateTime,
  }) async {
    try {
      String url = APIs.sendNotificationApi;
      List<String> deviceIdToke = [];
      for (var firebaseToken in firebaseDeviceList) {
        deviceIdToke.add(firebaseToken.firebaseId.toString());
        var json = {"message" : {
          "token": firebaseToken.firebaseId.toString(),
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "title": title,
            "body": body,
            "pageId": pageId,
            "complaintId": complaintId,
            "dateTime": dateTime,
          },
        }
        };
        await ServerRequest.firebasePushNotification(url: url, body: json);
      }
    } catch (_) {}
  }

  static Future<dynamic> obtainAuthenticatedClient() async {
    var accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "igl-cng",
      "private_key_id": "7702c01fca91a6b1ac0fe407fecfdfa3a4fcc308",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDi7fy8D1q8b9lD\nC16QPaY5awFujt15YfSFZOY0WoFwMAc7rfuOoJ+IOaKgRkMAkep9h7vZIXxnl49B\nau8cWmwBA+XdZ63c6vCrjsZl8zjR4HYyt1W6aETgApPRjxUYl+kmyKYftqGhQEHI\n7TnjzO7mwT1Y8rNzvoDG6G6CxxLyWWPVmNuVBDnkU+R1lOMKLB2Xs7xvBbXXUOKA\nVDCzcZpjFIzHnbLNssvmZuULNOjyrBCX2qE/8sxHhY7RttWpedLny/yjIwb5Xv6M\nkPKAoln6gWaOVH+oNbcCVe6rofveuMTUPZ21sloaEe3zNX00JZhukgRYEABVjO9Q\nBKJaGQMbAgMBAAECggEARrauWNPYDHw2EYRLdVsgnyfPDGqMbTSvA5pLeejyCMmO\nl3RBvVIkJEkBejwqyNSvY2qWiLS8lXNO+q2d0RIEMdTLHlEehobXdD5LaJ2ACTaO\n3oLuveWcAMoM0fJqOn2r85/21E8O0ra5SSlTLr8/erygp0UJ0nl8m372YN4z8zx9\ndEZkcSRo1r+EiIWOqFqh4aMjTnxmzVaLDWQ9CUx84lvq9YU4QuAqaC1Y6J0pTDLs\n8kIIbDzDLbT2Va700AqRCNeVCl5P1BiqugI+iiQDuh04iEeuw2zKm9ZHO2VC3ZQV\nV+rokc+IQaa9KJfmCojnlESfaZK+ebAzs+L+sqixEQKBgQDrhUOH41UhtqlH3M0O\n7cZ8rvhXh3hqbOHsdgW/BK+gC+YnUwJ6vPiTiY3dZyR6g5g72WGcjejiALRqZLBk\nc/OsAuDLEECyVrKTzeFaDI2UUIbqfcAt0CSSjKlQ2IIbH7FNj5+LkpYD5810+rB6\nBOtEvmbV0NtObDOfafqijqfGjwKBgQD2qXza25EihKiKMbZqHKGrr67FiGlAXNpp\nF4cZY2zidlwIuZMMcMtNcW8kMn3eDtonQ0/LB12VmyEEmkmGqEgjSplWmrB2QCNk\nxP3cPZhL16VcR+72ny+6htyjnsUkhxV4Ef7202igffHAzrzwGZrS4juh4JtpBlKM\n8gOmHrxgtQKBgQCVeuhIh92RXziDlr1DO2Cd5ANUsnOXwHGHvcSZ3ySEhOjXjpTl\nR6jRIx26Jut9IqZtXePZFCx5vI7FdBCMQRen1c/Msg0N437F1oavu4XkW1O14ogl\ny5RauxH/cNrq0iubGYvebvPtmKLLGw0E9LhJ0jq8fCmk1YHSLNZZdAdCOwKBgFwg\nxc+Avt6jqcej9bwAYaocfiytXJJ7m+Awt3cWGa8kAhAIMBIvdt/ABIECktyDs5uC\nmqT8ZUnhnR14+wlehUMZM9iTAmHIZu/WW/MM1ntNWifzfh+DKXKDuJksTfnssmoc\nXpyWLbf0En2vOgZ7qcYmVZuKpsE9aUvXgOFlDXsZAoGANnwHBxJ7E1J87fixC4Tp\nwriaUumphj96BW1kKztAGsjVVpBX52nHhChb8999xuJ1oFl/AG7oUiBiI5zNgyuU\nDpNa/oRBz5T68o65WOPD59sL82sGXKV9dHAt6Kh5cGDgDPdYicQe7b9GBsZPJA3X\nHOnUBw0oK5WhyrsesMD/zHg=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-za298@igl-cng.iam.gserviceaccount.com",
      "client_id": "108663151094442550311",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-za298%40igl-cng.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    var scopes = ["https://www.googleapis.com/auth/firebase.messaging"];
    var client = http.Client();
    AccessCredentials credentials =
    await obtainAccessCredentialsViaServiceAccount(accountCredentials, scopes, client);
    client.close();
    return credentials.accessToken.data;
  }
}
