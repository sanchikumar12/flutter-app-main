import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/pdf_view/pdf_view.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Firestore firestore = Firestore.instance;
  String name;
  String phone;
  AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
  }

  Widget loader() {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[300],
          period: Duration(milliseconds: 700),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            height: SizeConfig.screenHeight * 0.2,
            width: SizeConfig.screenWidth * 0.92,
          ),
        ));
  }

  Widget _plzLogin() {
    return Container(
        width: SizeConfig.screenWidth * 0.92,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, PhoneLoginRoute);
          },
          color: primaryColor,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pushReplacementNamed(context, HomeRoute),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/img/logo.png',
                fit: BoxFit.fill,
                height: 20,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Profile'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  authProvider.isAuthenticated ? getDetails() : Text(''),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.92,
                    child: Card(
                      child: ExpansionTile(
                        title: Text(
                          'Contact Us',
                          style: profileList,
                        ),
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              _launchCaller("+918144041418");
                            },
                            leading: IconButton(
                              icon: Icon(Icons.phone),
                              color: Colors.blue,
                              iconSize: SizeConfig.screenHeight * 0.04,
                              onPressed: () {
                                _launchCaller("+918144041418");
                              },
                            ),
                            title: Text(
                              'Call Us',
                              style: profileList,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ListTile(
                            onTap: () {
                              _launchWhatsapp('https://wa.me/918144041418');
                            },
                            leading: IconButton(
                              icon: Icon(LineIcons.whatsapp),
                              color: Colors.green[500],
                              iconSize: SizeConfig.screenHeight * 0.04,
                              onPressed: () {
                                _launchWhatsapp('https://wa.me/918144041418');
                              },
                            ),
                            title: Text(
                              'Message Us',
                              style: profileList,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ListTile(
                            onTap: () {
                              _launchEmail("support@frapen.in");
                            },
                            leading: IconButton(
                                icon: Icon(Icons.mail_outline),
                                color: Colors.deepOrange,
                                iconSize: SizeConfig.screenHeight * 0.04,
                                onPressed: () {
                                  _launchEmail("support@frapen.in");
                                }),
                            title: Text(
                              'Write To Us',
                              style: profileList,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'About',
                        style: TextStyle(fontSize: 22, color: Colors.grey),
                      ),
                    ),
                  ),
                  getAbout(),
                  SizedBox(
                    height: 15,
                  ),
                  authProvider.isAuthenticated ? _logOutBtn() : _plzLogin(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget getDetails() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          height: SizeConfig.screenHeight * 0.2,
          width: SizeConfig.screenWidth * 0.92,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(
                        color: Colors.grey[200],
                        width: 1.0,
                      ),
                    ),
                    elevation: 3,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.4),
                      height: SizeConfig.screenHeight * 0.14,
                      width: SizeConfig.screenWidth * 0.9,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              authProvider.user.displayName,
                              style: GoogleFonts.roboto(fontSize: 25),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              authProvider.user.phoneNumber,
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.grey[600]),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              Positioned(
                  top: SizeConfig.screenHeight * 0,
                  left: SizeConfig.screenWidth * 0.1,
                  child: Card(
                    elevation: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: SizeConfig.screenHeight * 0.12,
                        width: SizeConfig.screenWidth * 0.25,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.92,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      if (authProvider.isAuthenticated) {
                        Navigator.of(context)
                            .pushNamed(ProfileEditBasicRoute, arguments: 0);
                      } else {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          content: InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, PhoneLoginRoute),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Login to access it.",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.12,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person_pin,
                              color: primaryColor,
                              size: 40,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'My Profile',
                              style: profileList,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(ProfileAddressRoute,
                          arguments: "My Addresses");
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.12,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              color: primaryColor,
                              size: 40,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Address',
                              style: profileList,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.9,
          child: Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProfileOrderListRoute,
                );
              },
              child: Container(
                height: SizeConfig.screenHeight * 0.12,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: primaryColor,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Orders and Returns',
                        style: profileList,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  getAbout() {
    return Container(
      width: SizeConfig.screenWidth * 0.92,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<String>(
                  future: _checkVersion(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return loader();
                    }
                    return ListTile(
                        title: Text(
                          'App Version',
                          style: profileList,
                        ),
                        subtitle: Text(
                          snapshot.data,
                          style: profileListSub,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () => showAboutDialog(
                              applicationName: "Frapen",
                              applicationVersion: "${snapshot.data}",
                              applicationIcon: ImageIcon(
                                  AssetImage('assets/img/logo_in.png')),
                              context: context,
                              useRootNavigator: true,
                            ));
                  }),
              Divider(),
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfView("Terms & Conditions",
                        "https://firebasestorage.googleapis.com/v0/b/grocapp-f4eb9.appspot.com/o/Terms%20and%20Condition-%20Frapen.pdf?alt=media&token=cce65a75-bfcf-41b6-819f-58b7298295ca"),
                  ),
                ),
                title: Text(
                  'Terms & Conditions',
                  style: profileList,
                ),
                subtitle: Text(
                  'All the stuff you need to know',
                  style: profileListSub,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfView("Privacy Policy",
                        "https://firebasestorage.googleapis.com/v0/b/grocapp-f4eb9.appspot.com/o/Privacy%20Policy-%20Frapen.pdf?alt=media&token=1fb2159c-44bd-4593-a9f3-845df57821d3"),
                  ),
                ),
                title: Text(
                  'Privacy Policy',
                  style: profileList,
                ),
                subtitle: Text('Important for both of us',
                    style: profileListSub, overflow: TextOverflow.ellipsis),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfView("Return & Refund Policy",
                        "https://firebasestorage.googleapis.com/v0/b/grocapp-f4eb9.appspot.com/o/Return%20%26%20Refund%20Policy.pdf?alt=media&token=c28ef661-7ff3-4b7b-bdcd-f4dbc098b137"),
                  ),
                ),
                title: Text(
                  'Return Policy',
                  style: profileList,
                ),
                subtitle: Text('Very Important before placing Order',
                    style: profileListSub, overflow: TextOverflow.ellipsis),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                onTap: () => Navigator.of(context).pushNamed(FAQRoute),
                title: Text(
                  'FAQs',
                  style: profileList,
                ),
                subtitle: Text('All your questions answered',
                    style: profileListSub, overflow: TextOverflow.ellipsis),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logOutBtn() {
    return Container(
        width: SizeConfig.screenWidth * 0.92,
        height: SizeConfig.screenHeight * 0.08,
        child: Card(
          color: Colors.white,
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () {
              authProvider.signOut();
            },
            child: Container(
              width: SizeConfig.screenWidth * 0.92,
              height: SizeConfig.screenHeight * 0.08,
              child: Center(
                child: Text(
                  'Logout',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ));
  }

  Future<String> _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  _launchCaller(String url) async {
    if (await canLaunch("tel:" + url)) {
      await launch("tel:" + url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail(String url) async {
    if (await canLaunch("mailto:" + url + "?subject=&body=")) {
      await launch("mailto:" + url + "?subject=Assistance Required&body=");
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
