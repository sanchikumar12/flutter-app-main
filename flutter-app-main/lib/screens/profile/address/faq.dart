import 'package:flutter/material.dart';
import 'package:grocapp/const/text_style.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Frequently Asked Questions',
          style: orderDetilsHeadText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SelectableText(
              "Check out this section to get answers for all the frequently asked questions. \n\nIf you’d like get in touch with us, please do write to us at support@frapen.in or call us on +91-8144041418 between 06:00 am & 10:00 pm throughout the week and we will respond immediately. \n\nYou can also reach out to us on Whatsapp : +91-8144041418",
              textAlign: TextAlign.justify,
              style: orderListContentText,
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Registration',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How do I register?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "You can register by clicking on the 'Login' section located at the My Profile page at the bottom right hand corner or at the start of Application. Please provide the required information in the form that appears and click on submit. We will send a one-time password (OTP) to verify your mobile number. Post verification, you can start shopping on Frapen.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "Are there any charges for registration?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "No. Registration on Frapen is absolutely free.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "Do I need to register before shopping on Frapen?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "Yes, you do need to register before shopping with us. However, you can browse the app without registration. You are required to login or register while you checkout.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "Can I register multiple times using the same phone number/email ID?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "Each email ID/login ID and mobile number can only be associated with one customer account.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "What if I enter the wrong email ID while registering online/through the phone?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: SelectableText(
                          "Please contact our customer support team at +91-8144041418 or write to us at: support@frapen.in and we will fix this issue for you.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Login / Account Related',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "What is My Account?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "'My Account' is the section where you can view your Personal Information, Order History, view, add multiple or update address.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "I am unable to login",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "You may have entered incorrect login details. Please enter the correct information & try again.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Product / Price / Promotion',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How do I look for a particular Product?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "You can search for a product by navigating through the category pages or by using search tab on the top.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How will you ensure the freshness of products?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "We ensure that all our products are hygienically and carefully handled and maintain them in the correct temperature & packaging.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Ordering',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How do I know if I placed my order correctly?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "Upon the successful completion of your order, you can view your order under my Profile section under categories Orders & Return.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "Can I call and place an order?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: SelectableText(
                          "Yes, you can call +91-8144041418, and place the order or whatsapp the order via same number.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How are the fruits and vegetables weighed?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "All fruits and vegetables vary in size and weight. You can choose any size/weight available on the website. While you shop, we will show an estimated weight and price. At the time of processing, we pack the closest size/weight and charge you for the actual weight of each item. E.g. If you order 1 kg of apples, we will try to pack exactly 1 kg or the weight closest to 1 kg. If the actual weight is 987 gm, we will bill you for 987 gm and not 1 kg.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How do I make changes to my order?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "Currently, there is no provision to change the order once it’s been placed. Please call our customer support team & we will assist you however we can.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
                color: Colors.white,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Payment',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "What are the various modes of payment I can use for shopping?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: Text(
                            "• UPI \n• Credit Card / Debit Card \n•	Netbanking \n• e-Wallets \n• Cash on Delivery",
                            textAlign: TextAlign.left,
                            style: orderListContentText,
                          ),
                        ),
                      )
                    ],
                  ),
                ])),
            SizedBox(
              height: 10,
            ),
            Card(
                color: Colors.white,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Delivery',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How will I know if Frapen delivers to my area?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          "Frapen currently serves all areas of the city Sambalpur, Burla and Hirakud. So, if your area comes under this category, we got you covered.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ])),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Get in touch with us!',
                      style: orderDetilsHeadText,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.green[50],
                    title: Text(
                      "How do I contact you for feedback/queries/suggestions?",
                      style: faqHeadText,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: SelectableText(
                          "If you’d like get in touch with us, please do write to us at support@frapen.in or call us on +91-8144041418 between 06:00 am & 10:00 pm throughout the week and we will respond immediately.",
                          textAlign: TextAlign.justify,
                          style: orderListContentText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
