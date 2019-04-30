import 'dart:html';

import 'base/DomElement.dart';

class Application extends DomElement {
  Application(root):super(root, Element.div()) {
    print("> Application -> build");
    root.append(this.dom);
  }

  void replacePage( DomElement page ) {
    this.dom.children.clear();
    page.setDOMParent( this.dom );
  }
}
