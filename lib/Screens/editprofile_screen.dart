import 'dart:io';

import 'package:fireflutter/Constants/constants.dart';
import 'package:fireflutter/Models/user_model.dart';
import 'package:fireflutter/Services/database_services.dart';
import 'package:fireflutter/Services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name;
  String _bio;
  File _profileImage;
  File _coverImage;
  String _imagePickedType;
  final picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.user.coverImage.isNotEmpty) {
        return NetworkImage(widget.user.coverImage);
      }
    } else {
      return FileImage(_coverImage);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profilePicture.isEmpty) {
        return AssetImage('assets/placeholder.png');
      } else {
        return NetworkImage(widget.user.profilePicture);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  saveProfile() async {
    _formkey.currentState.save();
    if (_formkey.currentState.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      String coverPictureUrl = '';

      if (_profileImage == null) {
        profilePictureUrl = widget.user.profilePicture;
      } else {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.user.profilePicture, _profileImage);
      }
      if (_coverImage == null) {
        coverPictureUrl = widget.user.coverImage;
      } else {
        coverPictureUrl = await StorageService.uploadCoverPicture(
            widget.user.coverImage, _coverImage);
      }
      UserModel user = UserModel(
        id: widget.user.id,
        name: _name,
        profilePicture: profilePictureUrl,
        coverImage: coverPictureUrl,
        bio: _bio,
      );

      DatabaseServices.updateUserData(user);
      Navigator.pop(context);
    }
  }

  handleImageFromGallery() async {
    try {
      final imageFile = await picker.getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = File(imageFile.path);
          });
        } else if (_imagePickedType == 'cover') {
          setState(() {
            _coverImage = File(imageFile.path);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          //  SingleChildScrollView(
          //    physics: NeverScrollableScrollPhysics(),
          GestureDetector(
            onTap: () {
              _imagePickedType = 'cover';
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  padding: EdgeInsets.only(top: 50),
                  height: 170,
                  decoration: BoxDecoration(
                    color: KTweeterColor,
                    image: _coverImage == null && widget.user.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover, image: displayCoverImage()),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  padding: EdgeInsets.only(top: 15),
                  height: 170,
                  color: Colors.black45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        "Change your cover",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          //  fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -45.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              backgroundImage: displayProfileImage(),
                            ),
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black54,
                            //   backgroundImage: displayProfileImage(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Change your photo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    //   fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                       
                       // transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                        width: 100,
                        height: 35,
                        //padding: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration( 
                          borderRadius: BorderRadius.circular(20),
                          color: KTweeterColor,
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(color: KTweeterColor, fontSize: 18),
                        ),
                        validator: (input) => input.trim().length < 2
                            ? 'Insira um nome válido'
                            : null,
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle:
                              TextStyle(color: KTweeterColor, fontSize: 18),
                        ),
                        onSaved: (value) {
                          _bio = value;
                        },
                      ),
                      _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(KTweeterColor),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
