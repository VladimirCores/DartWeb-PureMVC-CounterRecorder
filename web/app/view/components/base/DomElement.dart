import 'dart:async';
import 'dart:html';

abstract class DomElement {

  Element dom;
  Element parent;
  List<DomElement> domElements;

	StreamController _onShown = StreamController.broadcast(sync: true);
	Stream get onShown => _onShown.stream;

  StreamController _onHidden = StreamController.broadcast(sync: true);
	Stream get onHidden => _onHidden.stream;

  DomElement( Element parent, Element dom ) {
    this.parent = parent;
    this.dom = dom;
    this.domElements = [];
    this.dom.className = this.runtimeType.toString();
  }

  void addDOMChild( element ) { this.dom.children.add(element); }

  void addElement( DomElement element, { bool appendToDom = false }) {
    this.domElements.add( element );
    element.setDOMParent( this.dom );
    if ( appendToDom )
      addDOMChild( element.dom );
  }

  void removeElement( DomElement element, { bool hideFromDom = false }) {
    this.domElements.remove(element);
    if ( hideFromDom )
      element.hide();
  }

  void setDOMParent( Element parent ) {
    print("> DomElement ${this} -> setParent: ${parent}");
    this.parent = parent;
  }

  void deselect() { /* abstract */ this.domElements.forEach((domElement) => domElement.deselect());  }
  void select() { /* abstract */ this.domElements.forEach((domElement) => domElement.select());  }
  void update(data) { /* abstract */ this.domElements.forEach((domElement) => domElement.update(data)); }

  void show() {
    print("> DomElement ${this} -> show");
    this.domElements.forEach((domElement) => domElement.show());
    _onShown.add( this.dom );
  }

  void hide() {
    print("> DomElement ${this} -> hide");
    this.dom.remove();
    _onHidden.add(this.dom);
    print("> DomElement ${this} -> hide: dispatch on hidden");
  }

  void dispose() {
    this.domElements.forEach((domElement) => domElement.dispose());
    if (this.dom.parentNode != null)
      this.hide();

    _onShown.close();
    _onShown = null;
    _onHidden.close();
    _onHidden = null;
    this.domElements = null;
    this.dom = null;
    this.parent = null;
  }
}
