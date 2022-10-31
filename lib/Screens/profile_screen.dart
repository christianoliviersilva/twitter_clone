import 'package:fireflutter/Constants/constants.dart';
import 'package:fireflutter/Models/user_model.dart';
import 'package:fireflutter/Screens/editprofile_screen.dart';
import 'package:fireflutter/Screens/welcome_screen.dart';
import 'package:fireflutter/Services/auth_service.dart';
import 'package:fireflutter/Services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel user;

  const ProfileScreen(
      {Key key, this.currentUserId, this.visitedUserId, this.user})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCount = 0;
  int _followingCount = 0;
  int _profileSegmentValue = 0;
  bool _isFollowing = false;

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Posts',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
    1: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Media',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
    2: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Likes',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        )),
  };

  Widget buildProfileWidgets() {
    switch (_profileSegmentValue) {
      case 0:
        return Center(child: Text('Posts', style: TextStyle(fontSize: 25)));
        break;
      case 1:
        return Center(child: Text('Media', style: TextStyle(fontSize: 25)));
        break;
      case 2:
        return Center(child: Text('Likes', style: TextStyle(fontSize: 25)));
        break;
      default:
        return Center(
            child: Text('Algo deu errado', style: TextStyle(fontSize: 25)));
        break;
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);

    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);

    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollwing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    _isFollowing = isFollowingThisUser;
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollwing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: usersRef.doc(widget.visitedUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(KTweeterColor),
              ),
            );
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data);
          return ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                //  child: Expanded(
                //     flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                      padding: EdgeInsets.only(top: 50),
                      height: 170,
                      decoration: BoxDecoration(
                        color: KTweeterColor,
                        image: userModel.coverImage.isEmpty
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(userModel.coverImage),
                              ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox.shrink(),
                         widget.currentUserId == widget.visitedUserId ?
                          PopupMenuButton(
                            elevation: 3.2,

                            // padding: EdgeInsets.symmetric(vertical: 20),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ),

                            itemBuilder: (_) {
                              return <PopupMenuItem<String>>[
                                new PopupMenuItem(
                                  child: Text('Logout'),
                                  value: 'logout',
                                ),
                              ];
                            },
                            onSelected: (selectedItem) {
                              UserModel user = UserModel(
                                  //   id: usersRef.id,
                                  //     name: userModel.name,
                                  //     profilePicture: userModel.profilePicture,
                                  //    coverImage: userModel.coverImage,
                                  //    bio: userModel.bio,
                                  );
                              AuthService.signOut(user);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                              Navigator.pop(context);
                            },
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -82.0, 0.0),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: userModel
                                          .profilePicture.isEmpty
                                      ? AssetImage('assets/placeholder.png')
                                      : NetworkImage(userModel.profilePicture),
                                ),
                              ),
                              widget.currentUserId == widget.visitedUserId
                                  ? GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(
                                              user: userModel,
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: KTweeterColor)),
                                        child: Center(
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                color: KTweeterColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: followOrUnFollow,
                                      child: Container(
                                        width: 100,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: _isFollowing
                                                ? KTweeterColor
                                                : Colors.white,
                                            border: Border.all(
                                                color: KTweeterColor)),
                                        child: Center(
                                          child: Text(
                                            _isFollowing
                                                ? 'Following'
                                                : 'Follow',
                                            style: TextStyle(
                                                color: _isFollowing
                                                ? Colors.white
                                                : KTweeterColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userModel.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userModel.bio,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                '$_followingCount Following',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                '$_followersCount Followers',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: CupertinoSlidingSegmentedControl(
                              groupValue: _profileSegmentValue,
                              thumbColor: KTweeterColor,
                              backgroundColor: Colors.blueGrey,
                              children: _profileTabs,
                              onValueChanged: (i) {
                                setState(() {
                                  _profileSegmentValue = i;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    buildProfileWidgets(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
