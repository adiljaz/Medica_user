import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Last updated: July 26, 2024',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildSection('Interpretation and Definitions', [
                _buildSubSection('Interpretation', 
                  'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.'
                ),
                _buildSubSection('Definitions', 
                  'For the purposes of this Privacy Policy:',
                  additionalContent: _buildDefinitionList()
                ),
              ]),
              _buildSection('Collecting and Using Your Personal Data', [
                _buildSubSection('Types of Data Collected', 
                  'Personal Data',
                  additionalContent: _buildPersonalDataSection()
                ),
                _buildSubSection('Use of Your Personal Data', 
                  'The Company may use Personal Data for the following purposes:',
                  additionalContent: _buildPersonalDataUseSection()
                ),
              ]),
              _buildSection('Security of Your Personal Data', [
                Text(
                  'We take the security of your Personal Data seriously and use appropriate technical and organizational measures to protect your information. These measures include:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Encryption of data in transit and at rest', style: TextStyle(fontSize: 16)),
                    Text('• Secure user authentication', style: TextStyle(fontSize: 16)),
                    Text('• Regular security audits and updates', style: TextStyle(fontSize: 16)),
                    Text('• Strict access controls for our staff', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'We use Firebase, a Google service, for secure data storage and processing. Firebase employs industry-standard security protocols and is compliant with various security certifications.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'However, no method of transmission over the Internet or electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Data Storage and Protection', [
                Text(
                  'Your Personal Data is stored securely on Firebase servers. Firebase uses encryption in transit and at rest to protect your data. The servers are located in secure data centers with restricted physical access. We retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Your Data Protection Rights', [
                Text(
                  'You have certain data protection rights. If you wish to be informed what Personal Data we hold about you and if you want it to be removed from our systems, please contact us. In certain circumstances, you have the following data protection rights:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• The right to access, update or to delete the information we have on you.', style: TextStyle(fontSize: 16)),
                    Text('• The right of rectification.', style: TextStyle(fontSize: 16)),
                    Text('• The right to object.', style: TextStyle(fontSize: 16)),
                    Text('• The right of restriction.', style: TextStyle(fontSize: 16)),
                    Text('• The right to data portability', style: TextStyle(fontSize: 16)),
                    Text('• The right to withdraw consent', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ]),
              _buildSection('Children\'s Privacy', [
                Text(
                  'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Changes to This Privacy Policy', [
                Text(
                  'We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page and sending you an email notification. We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Location Information', [
                Text(
                  'We may request access or permission to track location-based information from your mobile device, either continuously or while you are using our application, to provide certain location-based services. If you wish to change our access or permissions, you may do so in your device\'s settings.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Camera Access', [
                Text(
                  'We may request access or permission to your device\'s camera to provide certain features of our application. If you wish to change our access or permissions, you may do so in your device\'s settings.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Third-Party Services', [
                Text(
                  'We use Firebase, a platform developed by Google, for various services including authentication, data storage, and analytics. Firebase collects and processes data as described in the Google Privacy Policy (https://policies.google.com/privacy) and Firebase Privacy and Security documentation (https://firebase.google.com/support/privacy).',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Firebase employs industry-standard security measures, including encryption in transit and at rest, to protect your data. For more information on Firebase security, visit: https://firebase.google.com/support/privacy#data_protection',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Data Retention', [
                Text(
                  'We will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your Personal Data to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our legal agreements and policies.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'We will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period, except when this data is used to strengthen the security or to improve the functionality of our Service, or we are legally obligated to retain this data for longer periods.',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              _buildSection('Contact Us', [
                Text(
                  'If you have any questions about this Privacy Policy, You can contact us:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'By email: adiljaz17@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ...content,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubSection(String title, String content, {Widget? additionalContent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        if (additionalContent != null) ...[
          SizedBox(height: 10),
          additionalContent,
        ],
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDefinitionList() {
    final definitions = [
      {'term': 'Account', 'definition': 'means a unique account created for You to access our Service or parts of our Service.'},
      {'term': 'Affiliate', 'definition': 'means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'},
      {'term': 'Application', 'definition': 'refers to HealthHub , the software program provided by the Company.'},
      {'term': 'Company', 'definition': '(referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to HealthHub.'},
      {'term': 'Country', 'definition': 'refers to: Kerala, India'},
      {'term': 'Device', 'definition': 'means any device that can access the Service such as a computer, a cellphone or a digital tablet.'},
      {'term': 'Personal Data', 'definition': 'is any information that relates to an identified or identifiable individual.'},
      {'term': 'Service', 'definition': 'refers to the Application.'},
      {'term': 'Service Provider', 'definition': 'means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.'},
      {'term': 'Usage Data', 'definition': 'refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).'},
      {'term': 'You', 'definition': 'means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: definitions.map((def) => _buildDefinitionItem(def['term']!, def['definition']!)).toList(),
    );
  }

  Widget _buildDefinitionItem(String term, String definition) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(text: '$term: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: definition),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Email address', style: TextStyle(fontSize: 16)),
            Text('• First name and last name', style: TextStyle(fontSize: 16)),
            Text('• Phone number', style: TextStyle(fontSize: 16)),
            Text('• Address, State, Province, ZIP/Postal code, City', style: TextStyle(fontSize: 16)),
            Text('• Usage Data', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalDataUseSection() {
    final uses = [
      'To provide and maintain our Service, including to monitor the usage of our Service.',
      'To manage Your Account: to manage Your registration as a user of the Service.',
      'For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.',
      'To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication.',
      'To provide You with news, special offers and general information about other goods, services and events which we offer.',
      'To manage Your requests: To attend and manage Your requests to Us.',
      'For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets.',
      'For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: uses.map((use) => Padding( 
        padding: const EdgeInsets.only(bottom: 10),
        child: Text('• $use', style: TextStyle(fontSize: 16)),
      )).toList(),
    );
  }
} 