import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(imageUrl: this.imageUrl,),
    );
  }
}


class Body extends StatelessWidget {
   final String imageUrl;

  const Body({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Container(
      height: size.height,
      width: size.width,
      child:Stack(
       children: <Widget>[
          ImageLayer(imageUrl: this.imageUrl,),
          OperationLayer(),
          // another layers can be defined here for zoom in and zoom out operations
       ],
      ),
    );
  }
}


class ImageLayer extends StatelessWidget {
   final String imageUrl;
    
  const ImageLayer({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
        child: CachedNetworkImage(imageUrl: this.imageUrl),
      ),
    );
  }
}

class OperationLayer  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:25),
      width: MediaQuery.of(context).size.width,
      height: 50,
     child: Row(
       children: <Widget>[
         IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);})
       ],
     ),
    );
  }
}