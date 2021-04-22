import 'package:flutter/widgets.dart';

class SingleScrollView extends StatefulWidget {
  final Widget child;

  ///if your content is too long set this minHeight to prevent yourself for small screens in that case you will have
  ///scroll on them
  final double minHeight;

  ///if we don't want to take parent's height we can set the maxHeight and take only partial of the parent if its
  ///height is > maxHeight
  final double maxHeight;

  ///wrap child with SingleChildScrollView, but the height of the view will be as matchParent and if the keyboard
  ///appear this height will be kept and view will be scrollable
  SingleScrollView({Key key, this.child, this.minHeight = 0, this.maxHeight = 0}) : super(key: key);

  @override
  _SingleScrollViewState createState() => _SingleScrollViewState();
}

class _SingleScrollViewState extends State<SingleScrollView> {
  double _bodyHeight = 0.0;
  bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: SizedBox(
              //get parent height only first time and reuse it, this way will
              // keep same height when the keyboard is shown, check if is rotated
              height: _getPrimaryHeight(viewportConstraints),
              child: widget.child));
    });
  }

  ///get height according to current parent's height and set min/max sizes
  ///check if device was rotated
  double _getPrimaryHeight(BoxConstraints viewportConstraints) {
    if (_bodyHeight == 0.0 ||
        isLandscape == null ||
        (isLandscape && viewportConstraints.maxHeight > viewportConstraints.maxWidth) ||
        (!isLandscape && viewportConstraints.maxHeight < viewportConstraints.maxWidth)) {

      isLandscape = viewportConstraints.maxHeight < viewportConstraints.maxWidth;

      _bodyHeight = viewportConstraints.maxHeight < widget.minHeight
          ? widget.minHeight
          : widget.maxHeight > 0 && viewportConstraints.maxHeight > widget.maxHeight
              ? widget.maxHeight
              : viewportConstraints.maxHeight;
    }

    return _bodyHeight;
  }
}
