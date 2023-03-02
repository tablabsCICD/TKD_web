/*

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/menu_provider.dart';
import '../../../util/ResponsiveWidget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;

class IFramePage extends StatefulWidget {
  String url;
  IFramePage({Key? key, required this.url}) : super(key: key);

  @override
  _IFramePageState createState() => _IFramePageState();
}

class _IFramePageState extends State<IFramePage> {

  final html.IFrameElement _iframeElement = html.IFrameElement();
  late Widget _iframeWidget;

  @override
  void initState() {
    super.initState();

    //_iframeElement.height = '500';
    //_iframeElement.width = '500';
    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!ResponsiveWidget.isDesktop(context))
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: context.read<MenuProvider>().controlMenu,
                ),
                Text(
                  "WebView",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            Expanded(child: _iframeWidget),
          ],
        ),
      ),
    );
  }
}
*/
