import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
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
                'Please read these terms and conditions carefully before using Our Service.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildSection('Interpretation and Definitions', [
                _buildSubsection('Interpretation', 'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.'),
                _buildSubsection('Definitions', 'For the purposes of these Terms and Conditions:', _buildDefinitionList()),
              ]),
              _buildSection('Acknowledgment', [
                Text('These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('User Accounts', [
                Text('When You create an account with Us, You must provide Us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of Your account on Our Service.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('You are responsible for safeguarding the password that You use to access the Service and for any activities or actions under Your password, whether Your password is with Our Service or a Third-Party Social Media Service.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('Content', [
                Text('Our Service allows You to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material ("Content"). You are responsible for the Content that You post to the Service, including its legality, reliability, and appropriateness.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('Prohibited Uses', [
                Text('You may use the Service only for lawful purposes and in accordance with these Terms. You agree not to use the Service:', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• In any way that violates any applicable national or international law or regulation.', style: TextStyle(fontSize: 16)),
                    Text('• For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way.', style: TextStyle(fontSize: 16)),
                    Text('• To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail", "chain letter," "spam," or any other similar solicitation.', style: TextStyle(fontSize: 16)),
                    Text('• To impersonate or attempt to impersonate the Company, a Company employee, another user, or any other person or entity.', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ]),
              _buildSection('Termination', [
                Text('We may terminate or suspend Your Account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Upon termination, Your right to use the Service will cease immediately. If You wish to terminate Your Account, You may simply discontinue using the Service.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('Governing Law', [
                Text('The laws of the Country, excluding its conflicts of law rules, shall govern this Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('Changes to These Terms and Conditions', [
                Text('We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material We will make reasonable efforts to provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at Our sole discretion.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the website and the Service.', style: TextStyle(fontSize: 16)),
              ]),
              _buildSection('Contact Us', [
                Text('If you have any questions about these Terms and Conditions, You can contact us:', style: TextStyle(fontSize: 16)),
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

  Widget _buildSection(String title, List<Widget> children) {
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
        ...children,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubsection(String title, String content, [Widget? additionalContent]) {
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
        Text(content, style: TextStyle(fontSize: 16)),
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
      {'term': 'Application', 'definition': 'refers to Health Mate, the software program provided by the Company.'},
      {'term': 'Application Store', 'definition': 'means the digital distribution service operated and developed by Apple Inc. (Apple App Store) or Google Inc. (Google Play Store) in which the Application has been downloaded.'},
      {'term': 'Affiliate', 'definition': 'means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'},
      {'term': 'Country', 'definition': 'refers to: Kerala, India'},
      {'term': 'Company', 'definition': '(referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Health Mate.'},
      {'term': 'Device', 'definition': 'means any device that can access the Service such as a computer, a cellphone or a digital tablet.'},
      {'term': 'Service', 'definition': 'refers to the Application.'},
      {'term': 'Terms and Conditions', 'definition': '(also referred as "Terms") mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service.'},
      {'term': 'Third-party Social Media Service', 'definition': 'means any services or content (including data, information, products or services) provided by a third-party that may be displayed, included or made available by the Service.'},
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
} 