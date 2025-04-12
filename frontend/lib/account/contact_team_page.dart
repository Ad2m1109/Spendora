import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTeamPage extends StatefulWidget {
  const ContactTeamPage({Key? key}) : super(key: key);

  @override
  State<ContactTeamPage> createState() => _ContactTeamPageState();
}

class _ContactTeamPageState extends State<ContactTeamPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final String email = 'spendora85@gmail.com';
    final String subject = Uri.encodeComponent(_subjectController.text.trim());
    final String body = Uri.encodeComponent(_messageController.text.trim());

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Support Team',
          style: TextStyle(color: Color.fromRGBO(166, 235, 78, 1)),
        ),
        iconTheme: const IconThemeData(color: Color.fromRGBO(25, 65, 55, 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We’re here to help!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(25, 65, 55, 1),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions, concerns, or feedback, feel free to reach out to us. Fill out the form below, and we’ll get back to you as soon as possible.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(25, 65, 55, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(25, 65, 55, 1),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.email, color: Color.fromRGBO(25, 65, 55, 1)),
                SizedBox(width: 8),
                Text(
                  'Email: spendora85@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.access_time, color: Color.fromRGBO(25, 65, 55, 1)),
                SizedBox(width: 8),
                Text(
                  'Support Hours: 9 AM - 5 PM (Mon-Fri)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
