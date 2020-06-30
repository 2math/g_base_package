import 'package:flutter/widgets.dart';

class SingleScrollView extends StatefulWidget {
  final Widget child;
  ///if your content is too long set this minHeight to prevent yourself for small screens in that case you will have
  ///scroll on them
  final double minHeight;

  ///wrap child with SingleChildScrollView, but the height of the view will be as matchParent and if the keyboard
  ///appear this height will be kept and view will be scrollable
  SingleScrollView({Key key, this.child, this.minHeight = 0}) : super(key: key);

  @override
  _SingleScrollViewState createState() => _SingleScrollViewState();
}

class _SingleScrollViewState extends State<SingleScrollView> {
  double _bodyHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: SizedBox(
              //get parent height only first time and reuse it, this way will
              // keep same height when the keyboard is shown
              height: _bodyHeight == 0.0
                  ? _bodyHeight = viewportConstraints.maxHeight < widget.minHeight
                      ? widget.minHeight
                      : viewportConstraints.maxHeight
                  : _bodyHeight,
              child: widget.child));
    });
  }
}
