import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:   Text("Privacy And Policy"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text("Introduction",style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                text: TextSpan(
                  text:  "This privacy policy sets out how Daily HD WallPaper uses and protects any information that you give Daily HD WallPaper when you use this website.\n\nDaily HD WallPaper is committed to ensuring that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, then you can be assured that it will only be used in accordance with this privacy statement.",
                  style: GoogleFonts.lato(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),

                ),
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Information we collect",style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  text: "1) Your mobile operating system. \n\n2) The type of mobile internet browsers you are using.\n\n3) Your current location.\n\n4) Information about how you interact with the mobile application and any of our web sites to which the mobile application links, such as how many times you use a specific part of the mobile application over a given time period, the amount of time you spend using the mobile application, how often you use the mobile application, actions you take in the mobile application and how you engage with the mobile application.\n\n5)Information to allow us to personalize the services and content available through the mobile application.\n\n6) Data from sms/ text messages upon receiving device permissions for the purposes of (i) issuing and receiving one time passwords and other device verification, and (ii) automatically filling verification details during financial transactions, either through us or a third-party service provider, in accordance with applicable law. We do not share or transfer sms/ text message data to any third party other than as provided under this privacy policy"
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                text:TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  text: "\t\t\t\t In addition to any protected information or other information that you choose to submit to us, we collect certain information whenever you visit or interact with the services (usage information). This usage information may include the browser that you are using, the URL that referred you to our services, all of the areas within our services that you visit, and the time of day, among other information. In addition, we collect your device identifier for your device. \nA device identifier is a number that is automatically assigned to your device used to access the services, and our computers identify your device by its device identifier. \n\nIn case of booking via call center, Daily HD WallPaper may record calls for quality and training purposes.In addition, tracking information is collected as you navigate through our services, including, but not limited to geographic areas. The driver’s mobile phone will send your GPS coordinates, during the ride, to our servers. Most GPS enabled mobile devices can define one’s location to within 50 feet. When you use any of our mobile applications, the mobile application may automatically collect and store some or all of the following information from your mobile device (mobile device information), in addition to the device information, including without limitation",
                ),
              ),
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Security",style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(

                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      text: "We are committed to ensuring that your information is secure. In order to prevent unauthorized access or disclosure we have put in place suitable physical, electronic and managerial procedures to safeguard and secure the information we collect online.")),
            ),
          ],
        ),
      ),
    );
  }
}
