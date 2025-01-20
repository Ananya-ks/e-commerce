import 'dart:io';

import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  AuthService authService = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController userName = TextEditingController();
  final TextEditingController newUserName = TextEditingController();
  final TextEditingController _oldpassword = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    print(FirebaseAuth.instance.currentUser);
    userName.text = 'Not set';
    super.initState();
  }

  openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose to upload profile picture',
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          profilePicture(ImageSource.camera);
                        },
                        icon: Icon(
                          Icons.camera,
                          size: 30.0,
                        )),
                    IconButton(
                        onPressed: () {
                          profilePicture(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.photo,
                          size: 30.0,
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  profilePicture(ImageSource source) async {
    User? user = FirebaseAuth.instance.currentUser;
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile!;
    });
    await user?.updatePhotoURL(_imageFile!.path);
    print("Selected image path: ${_imageFile?.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentUser!.providerData
                      .any((data) => data.providerId == 'google.com')
                  ? Text('${currentUser!.displayName}')
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(currentUser?.displayName == 'Not set'
                            ? userName.text
                            : currentUser?.displayName ?? ''),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Set name'),
                                    content: Container(
                                      height: 100.0,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: newUserName,
                                            decoration: InputDecoration(
                                              hintText: 'Ex: Ananya',
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                User? user = FirebaseAuth
                                                    .instance.currentUser;
                                                setState(() {
                                                  userName.text =
                                                      newUserName.text;
                                                });
                                                user?.updateDisplayName(
                                                    userName.text);
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK')),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 15.0,
                          ),
                        ),
                      ],
                    ),
              // currentUser!.providerData
              //         .any((data) => data.providerId == 'google.com')
              //     ?
              // Stack(alignment: Alignment.bottomRight, children: [
              //     Image.network('${currentUser!.photoURL}'),
              //   ])
              // :
              Stack(alignment: Alignment.bottomRight, children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: _imageFile != null
                      //  (currentUser?.photoURL == null)
                      //     ? const AssetImage('assets/person.png')
                      //     : AssetImage(currentUser!.photoURL!)
                      ? FileImage(File(_imageFile!.path))
                      : (currentUser?.photoURL != null)
                          ? AssetImage(currentUser!.photoURL!)
                          : const AssetImage('assets/person.png'),
                ),
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(100.0)),
                  child: IconButton(
                    highlightColor: Colors.grey,
                    icon: Icon(Icons.edit),
                    onPressed: () => openBottomSheet(),
                  ),
                ),
              ])
            ],
          ),
        ),
        Form(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              child: TextFormField(
                enabled: false,
                initialValue: currentUser!.email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return (currentUser?.providerData.any((data) =>
                                      data.providerId == 'google.com') ??
                                  false)
                              ? Container(
                                  child: Center(
                                      child: AlertDialog(
                                    content: Container(
                                      height: 85.0,
                                      child: Column(
                                        children: [
                                          const Text(
                                              'Since you\'ve loggedin with google, pasword will be managed by google'),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'))
                                        ],
                                      ),
                                    ),
                                  )),
                                )
                              : AlertDialog(
                                  title: Text('Password'),
                                  actionsPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  content: Container(
                                    width: 400.0,
                                    constraints:
                                        BoxConstraints(maxWidth: 400.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          expands: false,
                                          controller: _oldpassword,
                                          decoration: const InputDecoration(
                                              labelText: 'Old Password',
                                              labelStyle:
                                                  TextStyle(fontSize: 15.0)),
                                        ),
                                        TextFormField(
                                          controller: _newpassword,
                                          decoration: const InputDecoration(
                                              labelText: 'New Password',
                                              labelStyle:
                                                  TextStyle(fontSize: 15.0)),
                                        ),
                                        TextFormField(
                                          controller: _confirmpassword,
                                          decoration: const InputDecoration(
                                              labelText: 'Confirm Password',
                                              labelStyle:
                                                  TextStyle(fontSize: 15.0)),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              if (_newpassword.text ==
                                                  _confirmpassword.text) {
                                                try {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  print('user is $user');
                                                  AuthCredential credential =
                                                      EmailAuthProvider
                                                          .credential(
                                                              email:
                                                                  user!.email!,
                                                              password:
                                                                  _oldpassword
                                                                      .text);
                                                  await user
                                                      .reauthenticateWithCredential(
                                                          credential);
                                                  await user.updatePassword(
                                                      _newpassword.text);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Password updated Successfully');
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  print(e.toString());
                                                  Fluttertoast.showToast(
                                                      msg: e.toString());
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'New passwords don\'t match');
                                              }
                                            },
                                            child: Text('Confirm')),
                                      ],
                                    ),
                                  ),
                                );
                        });
                  },
                  child: Text('Change password')),
            ),
          ],
        )),
        ElevatedButton(
            onPressed: () {
              authService.signout();
              GoRouter.of(context).goNamed(MyAppRouteConstants.wrapperRoute);
            },
            child: const Text('signout'))
      ],
    );
  }
}
