import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniapp/constants.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:miniapp/helpers/form_helper.dart';
import 'package:miniapp/screens/event_page.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, this.eventId}) : super(key: key);
  final String? eventId;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  RequestState saveRequestState = RequestState.idle;
  TextEditingController religionController = TextEditingController();
  TextEditingController guruController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? imageUrl;
  TextEditingController guestController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  DateTime date = DateTime.now();
  RequestState getRequestState = RequestState.idle;

  @override
  void initState() {
    super.initState();
    if(widget.eventId != null) {
      getRequestState = RequestState.pending;
      fetchEvent();
    }
  }

  Future<void> fetchEvent() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .doc('users/$uid/events/${widget.eventId}').get();

    setState(() {
      final data = snapshot.data();
      religionController.text = data!['religion'];
      guruController.text = data['guru'];
      eventNameController.text = data['name'];
      imageUrl = data['photo'];
      guestController.text = data['guest'];
      date = data['date'].toDate();
      dateController.text = DateFormat('yyyy-MM-dd').format(date);
      venueController.text = data['venue'];
      hostController.text = data['host'];
      getRequestState = RequestState.complete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId == null ? 'Add event' : 'Edit event'),
      ),
      body: SingleChildScrollView(
        child: getRequestState == RequestState.pending ?
        const Center(child: CircularProgressIndicator()) : Container(
          padding: kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <InlineSpan>[
                    // first part
                    const WidgetSpan(child: Text("I am ", style: TextStyle(fontSize: 20),)),
                    // flexible text field
                    WidgetSpan(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 3),
                            child: IntrinsicWidth(
                              child: TextField(
                                  controller: religionController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0))),
                            ))),
                    const WidgetSpan(child: Text("(Your religion)", style: TextStyle(fontSize: 20),)),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <InlineSpan>[
                    // first part
                    const WidgetSpan(child: Text("I follow ", style: TextStyle(fontSize: 20),)),
                    // flexible text field
                    WidgetSpan(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 3),
                            child: IntrinsicWidth(
                              child: TextField(
                                  controller: guruController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0))),
                            ))),
                    const WidgetSpan(child: Text("(Mention your Spiritual Guru)", style: TextStyle(fontSize: 20),)),
                  ],
                ),
              ),
              FormHelper.buildTextField('Event name', controller: eventNameController),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: TextButton(
                  onPressed: showPhotoDialog,
                  child: const Text('Attach photo'),
                ),
              ),
              buildPhoto(),
              FormHelper.buildTextField('Guest of honour', controller: guestController),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: TextField(
                  controller: dateController, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Date" //label text of field
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: date,
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                    );

                    if(pickedDate != null ){
                      if (kDebugMode) {
                        print(pickedDate);
                      }
                      date = pickedDate;
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      if (kDebugMode) {
                        print(formattedDate);
                      } //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateController.text = formattedDate; //set output date to TextField value.
                      });
                    }else if(kDebugMode){
                      print("Date is not selected");
                    }
                  },
                ),
              ),
              FormHelper.buildTextField('Venue', controller: venueController),
              FormHelper.buildTextField('Hosted by', controller: hostController),

              Container(
                margin: const EdgeInsets.only(top: 4),
                child: ElevatedButton(
                    onPressed: saveEvent,
                    child: saveRequestState == RequestState.pending ?
                    const CircularProgressIndicator(color: Colors.white,) :
                    const Text('Save')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showPhotoDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }


  void saveEvent() async {
    if(saveRequestState != RequestState.pending) {
      setState(() {
        saveRequestState = RequestState.pending;
      });

      final eventData = {
        'religion': eventNameController.text,
        'guru': guruController.text,
        'name': eventNameController.text,
        'guest': guestController.text,
        'date': date,
        'venue': venueController.text,
        'host': hostController.text
      };

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference eventRef;
      if(widget.eventId == null) {
        eventRef = await FirebaseFirestore.instance.collection(
            'users/$uid/events'
        ).add(eventData);
      } else {
        eventRef = FirebaseFirestore.instance
            .doc('users/$uid/events/${widget.eventId}');
        await eventRef.update(eventData);
      }


      final image = this.image;
      if(image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final extension = image.path.split('.').last;
        final imagePath = '$uid/${eventRef.id}.$extension';
        final imageRef = storageRef.child(imagePath);
        File file = File(image.path);
        final task = await imageRef.putFile(file);
        final imageUrl = await task.ref.getDownloadURL();
        await eventRef.update({'photo': imageUrl});
      }

      if(mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventPage(eventRef: eventRef,)
        ));
      }
    }
  }

  Widget buildPhoto() {

    return image != null || imageUrl != null
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image(
          image: (image != null ? FileImage(File(image!.path)) :
          NetworkImage(imageUrl!)) as ImageProvider<Object>,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 300,
        ),
      ),
    ) : imageUrl != null ? Image.network(
        imageUrl!
    )
        : Container();

  }
}
