import 'package:flutter/material.dart';

import 'package:blacksheep/widgets/text/now_text.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_4.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_6.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

/// Agreement for mentor
class RegisterScreenMentor5 extends StatefulWidget {
  const RegisterScreenMentor5(this.registerData, {super.key});
  final Map<String, dynamic> registerData;

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenInitialState();
  }
}

class _RegisterScreenInitialState extends State<RegisterScreenMentor5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7ca2d),
      body: Container(
        padding: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(color: Color(0xfff7ca2d)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 120),
              padding: EdgeInsets.only(
                top: 80,
                left: 20,
                right: 20,
                bottom: 80,
              ),
              decoration: BoxDecoration(
                color: Color(0xff9e607e),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'I commit to work with people from different denominations and/or no denomination(s) and minister to people from diverse religious backgrounds, cultures, and sexual orientations.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality Agreement',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'All information that you will encounter as Community Mentor is highly sensitive and confidential. It is governed by the federal Privacy Act of Canada, the Personal Information Protection and Electronic Documents Act (PIPEDA), and provincial privacy and confidentiality legislation where applicable (Note: In Alberta, British Columbia and Quebec, provincial legislation supersedes PIPEDA).',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Therefore, as a Community Mentor, you agree that you will not at any time disclose or disseminate in an unauthorized manner information pertaining to community seekers you meet on the BlackSheep app, their families, or contact information, or any other information you may encounter as it relates to using the BlackSheep or meeting someone from the BlackSheep app.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text('An authorized manner is as follows:'),
                          SizedBox(height: 20),
                          Text(
                            '1. The person to whom the information directly relates has disclosed that information in particular and consented to its disclosure.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '2. The information is being used for the purpose for which it was obtained or compiled or for a consistent purpose.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '3. The information is disposed of in a secure manner given its highly sensitive nature, once it is no longer required for the purpose (e.g. deleting messages or contact information from your device).',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'This requires strict adherence by you to the express recorded or written permissions and implied consent given (or not given) by the community seeker via the BlackSheep app regarding all information provided; for example, express consent must be given on the BlackSheep App. You also agree to the principles of confidentiality in this agreement entitled “Confidentiality of the Community Seeker” (see below).',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Further, you agree to take reasonable steps to protect any confidential information you receive as it relates to your involvement on the BlackSheep App, and will destroy any paperwork you or anyone on your team has upon completion of your duties.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Lastly, all unpublished data regarding community members that you meet on the BlackSheep App is confidential and this information shall not be disclosed by you at any time both during your registered use of the BlackSheep App and/or afterwards.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality of the Community Seeker*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality, as a practice and responsibility of BlackSheep App users, is based on respect for the individual. The person who has identified themselves as a community seeker on the BlackSheep App may be extremely sensitive in community interactions. Having been or feeling outcasted sometimes carries a societal judgment that this person is expected to behave in an untrustworthy manner. If these expectations are maintained, the person may continue to view him or herself as untrustworthy.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'The responsibility for a community leader relationship mentors and community seekers is based on mutual trust, hence the necessity for strict adherence to the principles of confidentiality as set out below.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information concerning community seekers that is kept on file must be factual and verifiable. All records and files are subject to subpoena by the courts.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information obtained from a client is shared with other agencies and professionals only with the permission from the client. Exceptions to this may include: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- A person who is too ill, physically or mentally, to give such permission and it is to the client’s benefit that the information be shared.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- If withholding of such information may endanger the client or another person.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- If case records are used in research, the researcher must agree to make every effort to keep the material confidential and to use it in such a way that no individual case will be identifiable through the material published.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Case histories, when used as illustrative material in talks or published material, are changed in such a way that no individual can be identified. Case histories are, where possible, prefaced by a remark indicating that the story has been altered to protect the identity of the client.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '*Community Seeker OR Client here refers to the person who signed up on the BlackSheep app looking for community connection.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Statement of Faith',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Nicene Creed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one God, the Father, the Almighty, maker of heaven and earth, of all that is, seen and unseen.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one Lord, Jesus Christ, the only Son of God, eternally begotten of the Father, God from God, Light from Light, true God from true God, begotten, not made, of one Being with the Father; through Him, all things were made.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'For us and for our salvation he came down from heaven, was incarnate of the Holy Spirit and the Virgin Mary and became truly human.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'For our sake he was crucified under Pontius Pilate; he suffered death and was buried.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'On the third day, he rose again in accordance with the Scriptures; he ascended into heaven and is seated at the right hand of the Father.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'He will come again in glory to judge the living and the dead, and his kingdom will have no end.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in the Holy Spirit, the Lord, the giver of life, who proceeds from the Father [and the Son], who with the Father and the Son is worshipped and glorified, who has spoken through the prophets.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one holy catholic and apostolic Church. We acknowledge one baptism for the forgiveness of sins.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We look for the resurrection of the dead, and the life of the world to come.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'End-User License Agreement (EULA)\nLast Updated: December 2, 2025',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                            """BlackSheep Child Safety & CSAE Standards
Last updated: January 2025""",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("""
1. Zero-Tolerance Policy for Child Sexual Abuse and Exploitation (CSAE)
BlackSheep has a zero-tolerance policy toward Child Sexual Abuse and Exploitation (CSAE). The use of the BlackSheep app to create, upload, distribute, request, promote, store, or facilitate any form of CSAE is strictly prohibited.
This includes, but is not limited to:
	•	Child Sexual Abuse Material (CSAM)
	•	Sexualized content involving minors
	•	Grooming, solicitation, or exploitation of minors
	•	Any behavior intended to harm, exploit, or endanger a child
Any violation of this policy may result in immediate content removal, account suspension or termination, and referral to law enforcement where required.

2. Scope and Applicability
These standards apply to all users, content, interactions, and activities on the BlackSheep platform, including user-generated content, messages, media uploads, and profile information.
Use of the BlackSheep app constitutes agreement to comply with these standards.

3. In-App Reporting & User Feedback Mechanism (Self-Certification)
BlackSheep provides an in-app mechanism that allows users to:
	•	Report suspected CSAE or CSAM
	•	Submit safety concerns or policy violations
	•	Provide feedback related to child safety
Reports can be submitted directly within the app and are reviewed by BlackSheep’s safety and moderation team.

4. Handling of CSAM and CSAE Content (Self-Certification)
Upon obtaining actual knowledge of CSAM or CSAE-related activity, BlackSheep will take appropriate and prompt action, which may include:
	•	Immediate removal of the offending content
	•	Suspension or termination of involved accounts
	•	Preservation of relevant data where legally required
	•	Escalation to appropriate authorities
Actions are taken in accordance with these published standards and applicable laws.

5. Compliance with Child Safety Laws & Mandatory Reporting (Self-Certification)
BlackSheep complies with all applicable child safety laws and regulations.
Where required by law, confirmed CSAM is reported to the National Center for Missing and Exploited Children (NCMEC) or the relevant regional authority. BlackSheep maintains internal processes to ensure lawful and timely reporting.

6. Child Safety Point of Contact
BlackSheep maintains a designated Child Safety Point of Contact to receive notifications related to CSAE, including communications from Google Play.
This representative is authorized to:
	•	Address CSAE enforcement actions
	•	Explain BlackSheep’s review and moderation procedures
	•	Take immediate action when required
Contact: contact.us.blacksheep@gmail.com

7. Enforcement
BlackSheep reserves the right to:
	•	Investigate suspected violations
	•	Enforce these standards at its sole discretion
	•	Cooperate with law enforcement and regulatory authorities
Failure to comply with these standards may result in permanent loss of access to the BlackSheep app.
""", style: TextStyle(fontSize: 16)),
                          Text(
                            'To agree and move forward, click Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SmallButton('CONTINUE', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            RegisterScreenMentor6(widget.registerData),
                      ),
                    );
                  }, 0xff32a2c0),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              RegisterScreenMentor4(widget.registerData),
                        ),
                      ),
                    },
                    child: NowText(
                      body: 'BACK',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: NowHeader('ALMOST FINISHED', fontSize: 20),
              ),
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
