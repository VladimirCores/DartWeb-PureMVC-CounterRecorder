import 'dart:html';

import 'base/DomElement.dart';

class Application extends DomElement {
  Application(root):super(root, Element.div()) {
    print("> Application -> build");
  }

  void replacePage(DomElement page) {
    this.dom.children.clear();
    page.changeParent(this.dom);
  }
}
