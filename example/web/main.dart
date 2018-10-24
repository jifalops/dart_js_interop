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

/// A Javascript [Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object).
@JS('Object')
class Obj {
  external factory Obj([value]);

  external static int get length;
  external static Obj get prototype;
  external static void set prototype(Obj value);

  /// [sources] is one or more [Obj] instance.
  external static Obj assign(Obj target, sources);
  external static Obj create(Obj proto, [Obj properties]);
  external static Obj defineProperty(
      Obj obj, /*String|Symbol*/ prop, Descriptor descriptor);

  /// [props] is an object containing one or more property -> [Descriptor]
  /// mappings.
  external static Obj defineProperties(Obj obj, Obj props);
  external static List/*<List<String>>*/ entries(Obj obj);
  external static Obj freeze(Obj obj);
  external static Obj fromEntries(Iterable entries);
  external static Descriptor getOwnPropertyDescriptor(
      Obj obj, /*String|Symbol*/ prop);
  external static Obj getOwnPropertyDescriptors(Obj obj);
  external static List/*<String>*/ getOwnPropertyNames(Obj obj);
  external static List/*<Symbol>*/ getOwnPropertySymbols(Obj obj);
  external static Obj getPrototypeOf(Obj obj);
  external static bool is_(value1, value2);
  external static bool isExtensible(Obj obj);
  external static bool isFrozen(Obj obj);
  external static bool isSealed(Obj obj);
  external static List/*<String>*/ keys(Obj obj);
  external static Obj preventExtensions(Obj obj);
  external static Obj seal(Obj obj);
  external static Obj setPrototypeOf(Obj obj, Obj proto);
  external static List<dynamic> values(Obj obj);

  external Function get constructor;
  external void set constructor(Function value);
  @experimental
  external Obj get proto__;
  external void set proto__(Obj value);
  @experimental
  external Function get noSuchMethod__;
  external void set noSuchMethod__(Function value);

  external bool hasOwnProperty(/*String|Symbol*/ prop);
  external bool isPrototypeOf(Obj obj);
  external bool propertyIsEnumerable(/*String|Symbol*/ prop);
  @experimental
  external String toSource();
  external String toLocaleString();
  external String toString();
  @experimental
  external void unwatch(/*String|Symbol*/ prop);
  external valueOf();
  @experimental
  external void watch(/*String|Symbol*/ prop);
}

@JS()
@anonymous
class Descriptor {
  external factory Descriptor({
    bool configurable,
    bool enumerable,
    value,
    bool writable,
    Function get,
    Function set,
  });
  external bool get configurable;
  external bool get enumerable;
  external get value;
  external bool get writable;
  external Function get get;
  external Function get set;
}

const experimental = _Experimental();

class _Experimental {
  const _Experimental();
}
