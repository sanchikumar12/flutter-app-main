import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniapp/constants.dart';
import 'package:miniapp/screens/event_page.dart';
import 'package:miniapp/screens/form_screen.dart';
import 'package:miniapp/screens/phone_number_verification.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _eventsStream = FirebaseFirestore.instance.collection('users/$uid/events').snapshots();
    if(isLogin){
      Future.delayed(Duration.zero, () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 310,
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  height: 12,
                                ),
                                Text("TERMS & CONDITIONS", style: TextStyle(color: Colors.brown, fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                                  child: Text("""Users are requested to input indicative figures only for data security reasons
                        
Terms and Conditions for Shagun Android App

Please read these Terms and Conditions ("Agreement", "Terms and Conditions") carefully before using Shagun Android App ("the App") provided by Vijay ("Provider", "us", "we", or "our"). This Agreement sets forth the legally binding terms and conditions for your use of the App.

By downloading, installing or using the App, you agree to be bound by these Terms and Conditions. If you do not agree to these Terms and Conditions, do not download, install or use the App.

Account Registration
To use the App, you must register an account by providing your mobile number. You are solely responsible for maintaining the confidentiality of your account and password and for all activities that occur under your account.

Payment and Fees
The App is a one-time fee service of 51₹ that is non-refundable. Payment must be made in Indian Rupees. You may not transfer or assign your license to use the App to another person or entity.

Use of the App
The App is intended for personal use only. You agree not to use the App for any commercial or illegal purposes. You may not reproduce, distribute, or modify the App or any content within the App without the written permission of the Provider.

Privacy and Data Collection
The App does not use any kind of advertising and does not track users. We do not collect any personal data or information other than your mobile number for account registration.

Liability
We are not liable for any damages, including, but not limited to, direct, indirect, incidental, or consequential damages arising out of or in connection with the use or inability to use the App.

Termination
We may terminate your access to the App at any time, without cause or notice. Upon termination, your license to use the App will be immediately revoked.

Governing Law
This Agreement shall be governed by and construed in accordance with the laws of India without regard to its conflict of law provisions.

Changes to the Agreement
We reserve the right to modify these Terms and Conditions at any time. Your continued use of the App after any such changes constitutes your acceptance of the new Terms and Conditions.

By downloading, installing, or using the App, you acknowledge that you have read these Terms and Conditions, understand them, and agree to be bound by them. If you do not agree to these Terms and Conditions, do not download, install or use the App.""",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                isLogin=false;
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    const PhoneNumberVerification()), (Route<dynamic> route) => false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                                      child: Text("DENY", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            InkWell(
                              onTap: () {
                                isLogin=false;
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                                      child: Text("ACCEPT", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    )),
                              ),
                            ),
                          ]),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              );
            });
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/event_bg.jpeg"),fit: BoxFit.fill)
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _eventsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Add event from +'),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format((data['date'] as Timestamp).toDate())),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => openEvent(document.reference),
                        child: const Text('Open'),
                      ),
                      IconButton(onPressed: () => editEvent(document.id), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => showConfirmationDialog(document.reference), icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addEvent() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FormScreen()));
  }

  openEvent(eventRef) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventPage(eventRef: eventRef)));
  }

  void showConfirmationDialog(DocumentReference<Object?> reference) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete the event"),
            content: const Text("Would you like to delete the event ?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                  onPressed: () => deleteEvent(reference),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  deleteEvent(DocumentReference<Object?> reference) {
    reference.delete();
    Navigator.of(context).pop();
  }

  editEvent(String id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormScreen(
              eventId: id,
            )));
  }
}
