import 'package:flutter/material.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_4.dart';
import 'package:blacksheep/screens/register/register_screen_mentor_6.dart';

import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

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
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(color: Color(0xfff7ca2d)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 120),
              padding: EdgeInsets.only(
                top: 80,
                left: 50,
                right: 50,
                bottom: 50,
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'I commit to work with people from different denominations and/or no denomination(s) and minister to people from diverse religious backgrounds, cultures, and sexual orientations.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality Agreement',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'All information that you will encounter as Community Mentor is highly sensitive and confidential. It is governed by the federal Privacy Act of Canada, the Personal Information Protection and Electronic Documents Act (PIPEDA), and provincial privacy and confidentiality legislation where applicable (Note: In Alberta, British Columbia and Quebec, provincial legislation supersedes PIPEDA).',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Therefore, as a Community Mentor, you agree that you will not at any time disclose or disseminate in an unauthorized manner information pertaining to community seekers you meet on the BlackSheep app, their families, or contact information, or any other information you may encounter as it relates to using the BlackSheep or meeting someone from the Blacksheep app.',
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
                            '3. The information is disposed of in a secure manner given its highly sensitive nature, once it is no longer required for the purpose (e.g. deleting messages or contact information from your device).',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'This requires strict adherence by you to the express recorded or written permissions and implied consent given (or not given) by the community seeker via the BlackSheep app regarding all information provided; for example, express consent must be given on the Blacksheep App. You also agree to the principles of confidentiality in this agreement entitled “Confidentiality of the Community Seeker” (see below).',
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
                            'Confidentiality of the Community Seeker*',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Confidentiality, as a practice and responsibility of BlackSheep App users, is based on respect for the individual. The person who has identified themselves as a community seeker on the BlackSheep App may be extremely sensitive in community interactions. Having been or feeling outcasted sometimes carries a societal judgment that this person is expected to behave in an untrustworthy manner. If these expectations are maintained, the person may continue to view him or herself as untrustworthy.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'The responsibility for a community leader relationship mentors and community seekers is based on mutual trust, hence the necessity for strict adherence to the principles of confidentiality as set out below.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information concerning community seekers that is kept on file must be factual and verifiable. All records and files are subject to subpoena by the courts.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Information obtained from a client is shared with other agencies and professionals only with the permission from the client. Exceptions to this may include: ',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- A person who is too ill, physically or mentally, to give such permission and it is to the client’s benefit that the information be shared.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            '- If withholding of such information may endanger the client or another person.',
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
                            '*Community Seeker OR Client here refers to the person who signed up on the BlackSheep app looking for community connection.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'I agree to the Commitment Statement, Confidentiality Agreement, Confidentiality of the Community Seeker, and with the Statement of Faith:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Statement of Faith',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Nicene Creed',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one God, the Father, the Almighty, maker of heaven and earth, of all that is, seen and unseen.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one Lord, Jesus Christ, the only Son of God, eternally begotten of the Father, God from God, Light from Light, true God from true God, begotten, not made, of one Being with the Father; through Him, all things were made.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'For us and for our salvation he came down from heaven, was incarnate of the Holy Spirit and the Virgin Mary and became truly human.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'For our sake he was crucified under Pontius Pilate; he suffered death and was buried.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'On the third day, he rose again in accordance with the Scriptures; he ascended into heaven and is seated at the right hand of the Father.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'He will come again in glory to judge the living and the dead, and his kingdom will have no end.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in the Holy Spirit, the Lord, the giver of life, who proceeds from the Father [and the Son], who with the Father and the Son is worshipped and glorified, who has spoken through the prophets.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We believe in one holy catholic and apostolic Church. We acknowledge one baptism for the forgiveness of sins.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'We look for the resurrection of the dead, and the life of the world to come.',
                          ),
                          SizedBox(height: 20),
                          Text(
                            'I agree to the Commitment Statement, Confidentiality Agreement, Confidentiality of the Community Seeker, and with the Statement of Faith:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text('AGREE / DISAGREE'),
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
                  SizedBox(height: 5),
                  SmallButton('BACK', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            RegisterScreenMentor4(widget.registerData),
                      ),
                    );
                  }, 0xffffff),
                ],
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: NowHeader('ALMOST FINISHED'),
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
