import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:flutter/material.dart';

import 'package:blacksheep/screens/register/register_screen_mentee_2.dart';
import 'package:blacksheep/screens/register/register_screen_mentee_4.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Agreement for mentee
class RegisterScreen3 extends StatefulWidget {
  const RegisterScreen3({this.registerData = const {}, super.key});
  final Map<String, dynamic> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff32a2c0),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(color: Color(0xff32a2c0)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.only(
                top: 110,
                left: 20,
                right: 20,
                bottom: 60,
              ),
              decoration: BoxDecoration(
                color: Color(0xfffbee5e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                  topRight: Radius.circular(200),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Text(
                            'Commitment Statements',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'I commit to work with people from different denominations and/or no denomination(s) in a respectful manner from diverse religious backgrounds, cultures, and sexual orientations.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality Agreement',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'All information that you will encounter as Mentee is highly sensitive and confidential. It is governed by the federal Privacy Act of Canada, the Personal Information Protection and Electronic Documents Act (PIPEDA), and provincial privacy and confidentiality legislation where applicable (Note: In Alberta, British Columbia and Quebec, provincial legislation supersedes PIPEDA).',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Therefore, as a Mentee, you agree that you will not at any time disclose or disseminate in an unauthorized manner information pertaining to the communities you are involved in through the BlackSheep app, their families, or contact information, or any other information you may encounter as it relates to using the BlackSheep or meeting someone from the BlackSheep app.',
                          ),
                          SizedBox(height: 20),
                          Text('An authorized manner is as follows:'),
                          SizedBox(height: 20),
                          Text(
                            '1. The person to whom the information directly relates has disclosed that information in particular and consented to its disclosure.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '2. The information is being used for the purpose for which it was obtained or compiled or for a consistent purpose.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '3. The information is disposed of in a secure manner given its highly sensitive nature, once it is no longer required for the purpose (e.g. deleting messages or contact information from your device) or respecting someone’s preference to not be contacted any further.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'This requires strict adherence by you to the express recorded or written permissions and implied consent given (or not given) by community connections via the BlackSheep App regarding all information provided; for example, express consent must be given on the BlackSheep App. You also agree to the principles of confidentiality in this agreement entitled “Confidentiality of the Community Seeker” (see below).',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Further, you agree to take reasonable steps to protect any confidential information you receive as it relates to your involvement on the BlackSheep App, and will destroy any paperwork you or anyone on your team has upon completion of your duties.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Lastly, all unpublished data regarding community members that you meet on the BlackSheep App is confidential and this information shall not be disclosed by you at any time both during your registered use of the BlackSheep App and/or afterwards.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality of the Community*',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality, as a practice and responsibility of BlackSheep App users, is based on respect for the individual. The person who has identified themselves as a community members on the BlackSheep App may be extremely sensitive in community interactions.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'The responsibility for a community relationship is based on mutual trust, hence the necessity for strict adherence to the principles of confidentiality as set out below.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information concerning community members that is kept on file must be factual and verifiable. All records and files are subject to subpoena by the courts.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information obtained from a client is shared with other agencies and professionals only with the permission from the community member. Exceptions to this may include: ',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- A person who is too ill, physically or mentally, to give such permission and it is to the member’s benefit that the information be shared.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- If withholding of such information may endanger a community member or another person.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- If case records are used in research, the researcher must agree to make every effort to keep the material confidential and to use it in such a way that no individual case will be identifiable through the material published.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Case histories, when used as illustrative material in talks or published material, are changed in such a way that no individual can be identified. Case histories are, where possible, prefaced by a remark indicating that the story has been altered to protect the identity of the client.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '*Refers to Mentor, Mentee, or any other member of the community who is met whether through sign up or introduction via someone who signed up on the BlackSheep app looking for community connection.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'End-User License Agreement (EULA)\nLast Updated: December 2, 2025',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            """This End-User License Agreement (“Agreement”) is a legal contract between you (“User,” “you,” or “your”) and BlackSheep (“Company,” “we,” “us,” or “our”) governing your use of the BlackSheep mentorship application, including its website, software, and related services (collectively, the “App”). By downloading, accessing, or using the App, you agree to be bound by this Agreement. If you do not agree, you must discontinue use of the App.

1. License Grant
BlackSheep grants you a limited, non-exclusive, non-transferable, revocable license to use the App solely for your personal and non-commercial purposes, in accordance with this Agreement and our Privacy Policy.

2. Restrictions
You agree that you will not:
Modify, copy, reproduce, distribute, or create derivative works of the App;
Reverse engineer, decompile, or attempt to extract the source code of the App;
Use the App for any unlawful, harmful, or unauthorized purpose;
Interfere with the security, integrity, or operation of the App;
Sell, resell, sublicense, rent, or transfer any rights granted under this Agreement.

3. User Content
You are solely responsible for any content, messages, information, or materials submitted through the App (“User Content”). By submitting User Content, you warrant that you have the necessary rights to do so. You grant BlackSheep a non-exclusive, worldwide, royalty-free license to use, process, store, and display your User Content as required to operate and enhance the App.

4. Mentorship Disclaimer
The App provides mentorship-related tools, communication channels, and resources. Any mentorship guidance offered through BlackSheep is not professional, legal, medical, therapeutic, or financial advice and should not be relied upon as such. Users are solely responsible for any decisions or actions taken based on information obtained through the App.

5. Intellectual Property
All trademarks, logos, content, designs, software, and intellectual property within the App are the exclusive property of BlackSheep or its licensors. Your use of the App grants no rights or ownership to any intellectual property belonging to BlackSheep.

6. Termination
BlackSheep may suspend or terminate your access to the App at any time, with or without notice, if we determine you have violated this Agreement or engaged in conduct harmful to the App, its users, or BlackSheep. Upon termination, all rights granted to you under this Agreement will immediately cease.

7. Updates and Modifications
BlackSheep may update, change, or modify the App at any time. Your continued use after such updates constitutes acceptance of the modified App. BlackSheep may also update this Agreement from time to time, and changes take effect when posted within the App or on our website.

8. Third-Party Services
The App may integrate with or link to third-party applications, tools, or services. BlackSheep is not responsible for third-party content, policies, or practices. Your use of third-party services is governed by their respective terms.

9. Limitation of Liability
To the fullest extent permitted by Ontario and Canadian law, BlackSheep is not liable for any direct, indirect, incidental, consequential, or special damages arising from:
Your use or inability to use the App;
Any actions taken based on mentorship interactions or content;
Unauthorized access to or alteration of your data;
Conduct or content of any third party;
Any other matter related to your use of the App.
Your sole remedy for any dissatisfaction with the App is to discontinue its use.

10. Indemnification
You agree to indemnify and hold harmless BlackSheep, its employees, contractors, officers, and affiliates from any claims, damages, losses, or liabilities arising from your use of the App, your User Content, or any violation of this Agreement.

11. Governing Law
This Agreement is governed by and interpreted in accordance with the laws of the Province of Ontario and the federal laws of Canada, without regard to conflict-of-law principles. Any disputes arising under this Agreement shall be resolved exclusively in the courts of Ontario.

12. Contact Information
If you have any questions regarding this Agreement, you may contact us at:

BlackSheep
Email: contact.us.blacksheep@gmail.com""",
                          ),
                          SizedBox(height: 20),
                          Text(
                            'To agree and move forward, click Continue',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SmallButton('CONTINUE', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            RegisterScreen4(registerData: widget.registerData),
                      ),
                    );
                  }, 0xff32a2c0),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              RegisterScreen2(widget.registerData),
                        ),
                      ),
                    },
                    child: NowText(body: 'BACK', fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: const NowHeader('ALMOST FINISHED'),
            ),
            Positioned(
              top: 10,
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/sheep.png'),
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
