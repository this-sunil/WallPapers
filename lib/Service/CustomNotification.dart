import 'package:awesome_notifications/awesome_notifications.dart';

class CustomNotification{
  init() async{

    await AwesomeNotifications().initialize(
        'resource://drawable/logo',[
      NotificationChannel(

        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: "Hi",
        playSound: true,
        channelShowBadge: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        icon: "resource://drawable/logo",

        defaultRingtoneType: DefaultRingtoneType.Notification,

      )
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
  Future<void> createNotification(String title,String body,String image) async {
   /* var timeZone=await AwesomeNotifications().getLocalTimeZoneIdentifier();
    NotificationSchedule notificationSchedule=new NotificationSchedule(timeZone: '');*/
    final id=DateTime.now().millisecondsSinceEpoch~/1000;
    await AwesomeNotifications().createNotification(

      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title:title,
        body: body,
        bigPicture: image,
        notificationLayout: NotificationLayout.BigPicture,
        displayOnBackground: true,
        displayOnForeground: true,



      ),
      // schedule: NotificationInterval(interval: 1,timeZone: timeZone),
    );
  }
  display() async{
    AwesomeNotifications().displayedStream.listen((event) {
      print("event.data");
    });
  }
}