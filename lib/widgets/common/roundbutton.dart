import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String data;
  final Function onTap;
  final bool isLoading;
  const RoundButton(
    this.data, {
    Key key,
    @required this.onTap, this.isLoading=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: !isLoading&&onTap!=null?1.0:0.6,
      child: InkWell(
        onTap: isLoading?null:onTap,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                    shape: BoxShape.rectangle,
                    ),
                child: isLoading?CircularProgressIndicator():Text(
                  data,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
