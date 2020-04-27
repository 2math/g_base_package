import 'package:flutter/widgets.dart';

///wrap child with SingleChildScrollView, but the height of the view will be as matchParent and if the keyboard
///appear this height will be kept and view will be scrollable
class SingleScrollView extends StatefulWidget {
  final Widget child;

  SingleScrollView({Key key, this.child}) : super(key: key);

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
              height: _bodyHeight == 0.0 ? _bodyHeight = viewportConstraints.maxHeight : _bodyHeight,
              child: widget.child));
    });
  }
}
