import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/anonymous_user.jpg'),),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: const Text('Name'),
                subtitle: const Text('Aladdin Daly'),
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_forward,color: Colors.black,),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: const Text('Phone Number'),
                subtitle: const Text('58247509'),
                leading: Icon(Icons.phone),
                trailing: Icon(Icons.arrow_forward,color: Colors.black,),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: const Text('Address'),
                subtitle: const Text('Tripoli, 4013'),
                leading: Icon(Icons.location_on),
                trailing: Icon(Icons.arrow_forward,color: Colors.black,),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: const Text('Email'),
                subtitle: const Text('dalyalaeddine@gmail.com'),
                leading: Icon(Icons.email),
                trailing: Icon(Icons.arrow_forward,color: Colors.black,),
              ),
            ),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){},
                child: const Text('Save Changes')),
            ElevatedButton(
                onPressed: (){},
                child: const Text('Log Out')),

          ],
        ),
      ),
    );
  }
}