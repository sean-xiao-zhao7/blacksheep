import 'package:flutter/material.dart';
import 'package:blacksheep/screens/register/register_screen_2.dart';
import 'package:blacksheep/screens/register/register_screen_4.dart';
import 'package:blacksheep/widgets/buttons/small_button.dart';
import 'package:blacksheep/widgets/layouts/headers/now_header.dart';

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
      body: Container(
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(color: Color(0xff32a2c0)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.only(
                top: 100,
                left: 50,
                right: 50,
                bottom: 100,
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
                  SmallButton('BACK', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => RegisterScreen2(widget.registerData),
                      ),
                    );
                  }, 0xffffff),
                ],
              ),
            ),
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: const NowHeader('ALMOST FINISHED'),
            ),
            Positioned(
              top: 40,
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
