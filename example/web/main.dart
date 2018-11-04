@JS()
library example;

import 'dart:html';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js;
import 'package:meta/meta.dart';
import 'package:meta/dart2js.dart';

void main() {
  querySelector('#output').text = 'Your Dart app is running.';

  final animal = AnimalClass('Dog');
  final dart = DartAnimal(animal);
  var a = #f;

  print('animal $animal');
  print('dart $dart');

  print('AnimalClass $AnimalClass');
  print('DartAnimal $DartAnimal');

  // passCtor(() => AnimalClass);
  // passCtor(() => DartAnimal);

  // passCtor(customElement);
  // passCtor(DartAnimal);

  // defineElement('custom-el', allowInterop(() => CustomElement));
  // define('custom-el', customElement);
  // define('custom-el', allowInterop(() => CustomElement()));

  // document.registerElement('dart-el', DartElement);

  js.newObject();

  defineElement('dart-el', allowInterop(() => DartElement));

  document.body.append(Element.tag('custom-el'));
  document.body.append(Element.tag('dart-el'));
}

class DartElement extends HtmlElement {

  DartElement.created() : super.created();
  void attach() => innerHtml = '<div>Dart connected</div>';
}

class DartAnimal {
  DartAnimal(AnimalClass animal) : this._js = animal;
  final AnimalClass _js;
  String get name => _js.name;
  void set name(String value) => _js.name = value;
  String talk() => _js.talk();
  String get nameGetSet => _js.nameGetSet;
  void set nameGetSet(String value) => _js.nameGetSet = value;
  static String get staticName => AnimalClass.staticName;
  static String staticTalk() => AnimalClass.staticTalk();
}

@JS()
class AnimalClass {
  external factory AnimalClass(String name);
  external String get name;
  external void set name(String value);
  external String talk();
  external String get nameGetSet;
  external void set nameGetSet(String value);
  external static String get staticName;
  external static String staticTalk();
}

@JS()
external void passCtor(ctor);

@JS('customElements.define')
external define(String tag, Function f);

@noInline
@JS('CustomElement')
external customElement();

@JS()
class CustomElement {}

@JS('defineElement')
external void defineElement(String name, Function constructor);

