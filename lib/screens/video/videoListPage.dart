import 'package:demoadmin/screens/video/editVideoPage.dart';
import 'package:demoadmin/service/videoService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  ScrollController _scrollController = new ScrollController();
  int limit = 10;
  int itemLength = 0;
  @override
  void initState() {
    // TODO: implement initState
    _scrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Video"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add New",
        onPressed: () {
          Navigator.pushNamed(context, "/AddVideoPage");
        },
        isEnableBtn: true,
      ),
      body: FutureBuilder(
          future: VideoService.getData(limit), //fetch all testimonials details
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildList(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  Widget _buildList(videoDetails) {
    itemLength = videoDetails.length;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: videoDetails.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditVideoPage(videoDetails: videoDetails[index])),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListTile(
                  title: Text(
                    videoDetails[index].title,
                    style: kCardSubTitleStyle,
                  ),
                  subtitle: Text(
                    videoDetails[index]
                        .createdTimeStamp
                        .toString()
                        .substring(0, 10),
                    style: kCardSubTitleStyle,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      )),
                  leading: Container(
                    height: 100,
                    width: 80,
                    child: videoDetails[index].imageUrl == ""
                        ? Icon(
                            Icons.category,
                            color: iconsColor,
                            size: 30,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageBoxFillWidget(
                              imageUrl: videoDetails[index].imageUrl,
                            )),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      // print("length" $itemLength $limit");
      if (itemLength >= limit) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            limit += 10;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }
}
