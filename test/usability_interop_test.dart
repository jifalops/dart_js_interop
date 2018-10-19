@JS()
@TestOn('browser')
library test.changeability_interop;

import 'package:js/js.dart';
import 'package:test/test.dart';

// Hack to detect whether we are running in DDC or Dart2JS.
@JS(r'$dartLoader')
external Object get _$dartLoader;
final bool isDartDevC = _$dartLoader != null;
final bool isDart2JS = !isDartDevC;

@JS()
class Animal {
  external factory Animal(String name);
  external String get name;
  external void set name(String value);
  external String talk();
  external String get nameGetSet;
  external void set nameGetSet(String value);
  external static String get staticName;
  external static void set staticName(String value);
  external static String staticTalk();

  Animal.dart(this.dartName, this.dartName2);
  String dartName = 'Dart';
  String dartName2;
  final dartName3 = 'Dart3';

  // Getters, Setters, and methods all cause Dart2JS build failures.

  // String get dartNameGetSet => dartName;
  // void set dartNameGetSet(String value) => dartName = value;
  // String dartTalk() => 'I am a $dartName';
  // String dartTalkJS() => 'I am a $name';

  static String dartStaticName = 'Animal';
  static const String dartStaticConstName = 'Animal';
  static String dartStaticTalk() => 'I am an $dartStaticName';
}

@JS('Animal')
abstract class AbstractAnimal {
  external factory AbstractAnimal(String name);
  String name;
  String talk();
  String nameGetSet;
  static String staticName;
  external static String staticTalk();

  // Animal.dart(this.dartName, this.dartName2);
  String dartName = 'Dart';
  String dartName2;
  final dartName3 = 'Dart3';

  // Getters, Setters, and methods all cause Dart2JS build failures.

  // String get dartNameGetSet => dartName;
  // void set dartNameGetSet(String value) => dartName = value;
  // String dartTalk() => 'I am a $dartName';
  // String dartTalkJS() => 'I am a $name';

  static String dartStaticName = 'Animal';
  static const String dartStaticConstName = 'Animal';
  static String dartStaticTalk() => 'I am an $dartStaticName';
}

// @JS()
// class AnimalClass {
//   external factory AnimalClass(String name);
//   external String get name;
//   external void set name(String value);
//   external String talk();
//   external String get nameGetSet;
//   external void set nameGetSet(String value);
//   external static String get staticName;
//   external static String staticTalk();

//   AnimalClass.dart(this.dartName);
//   String dartName;
//   // String get dartNameGetSet => dartName;
//   // void set dartNameGetSet(String value) => dartName = value;
//   // String dartTalk() => 'I am a $dartName';
//   // String dartTalkJS() => 'I am a $name';
//   static String dartStaticName = 'Animal';
//   // static final String dartStaticFinalName = 'Animal';
//   static const String dartStaticConstName = 'Animal';
//   // static String dartStaticTalk() => 'I am an $dartStaticName';
//   // static String dartStaticFinalTalk() => 'I am an $dartStaticFinalName';
//   // static String dartStaticConstTalk() => 'I am an $dartStaticConstName';
// }

void main() {
  print('isDartDevC: $isDartDevC, isDart2JS: $isDart2JS');

  group('JS class-like object, using external.', () {
    test('should access JS members', () {
      final animal = new Animal('Dog');
      expect(animal.name, 'Dog');
      expect(animal.nameGetSet, 'Dog');
      expect(animal.talk(), 'I am a Dog');
      expect(Animal.staticName, 'Animal');
      expect(Animal.staticTalk(), 'I am an Animal');
    });
    test('should reflect changes from JS-defined modifiers', () {
      final animal = new Animal('Dog');
      animal.name = 'Cat';
      expect(animal.name, 'Cat');
      expect(animal.nameGetSet, 'Cat');
      expect(animal.talk(), 'I am a Cat');
      animal.nameGetSet = 'Fox';
      expect(animal.name, 'Fox');
      expect(animal.nameGetSet, 'Fox');
      expect(animal.talk(), 'I am a Fox');
      Animal.staticName = 'Plant';
      expect(Animal.staticName, 'Plant');
      expect(Animal.staticTalk(), 'I am an Plant');
    });

    test('should access Dart members', () {
      /// In DDC, this seems to alias the JS constructor function.
      /// In Dart2JS, this seems to create an object that does not contain
      /// the JS methods.
      final animal = Animal.dart('Dog', 'Cat');
      final animalJs = Animal('Dog');
      /// @JS() classes cannot add properties.
      expect(animal.dartName, null);
      expect(animal.dartName2, null);
      expect(animal.dartName3, null);
      expect(animalJs.dartName, null);
      expect(animalJs.dartName2, null);
      expect(animalJs.dartName3, null);
      if (isDartDevC) {
        expect(animal.name, 'Dog');
        /// In DDC, static properties are null and static methods throw
        /// `NoSuchMethodError`. However, the talk() method still works.
        expect(Animal.dartStaticName, null);
        expect(Animal.dartStaticConstName, null);
        // TODO: catch this error
        // expect(Animal.dartStaticTalk(), throwsNoSuchMethodError);
        expect(animal.talk(), 'I am a Dog');
      } else if (isDart2JS) {
        expect(animal.name, null);
        /// Static properties and methods work in Dart2JS only.
        /// However, the talk() method no longer exists.
        expect(Animal.dartStaticName, 'Animal');
        expect(Animal.dartStaticConstName, 'Animal');
        expect(Animal.dartStaticTalk(), 'I am an Animal');
        // TODO: catch this error
        // expect(animal.talk(), throwsNoSuchMethodError);
      }
      animal.name = 'Cat';
      expect(animal.name, 'Cat');
    });
  });

  group('JS class-like object, minimally external.', () {
    test('should access JS members', () {
      final animal = new AbstractAnimal('Dog');
      expect(animal.name, 'Dog');
      expect(animal.nameGetSet, 'Dog');
      expect(animal.talk(), 'I am a Dog');
      if (isDartDevC) {
        // Value changed in previous test
        expect(AbstractAnimal.staticName, 'Plant');
        expect(AbstractAnimal.staticTalk(), 'I am an Plant');
      } else if (isDart2JS) {
        expect(AbstractAnimal.staticName, null);
        // TODO: catch this error
        // expect(AbstractAnimal.staticTalk(), throwsNoSuchMethodError);
      }

    });
    test('should reflect changes from JS-defined modifiers', () {
      final animal = new AbstractAnimal('Dog');
      animal.name = 'Cat';
      expect(animal.name, 'Cat');
      expect(animal.nameGetSet, 'Cat');
      expect(animal.talk(), 'I am a Cat');
      animal.nameGetSet = 'Fox';
      expect(animal.name, 'Fox');
      expect(animal.nameGetSet, 'Fox');
      expect(animal.talk(), 'I am a Fox');
      AbstractAnimal.staticName = 'Plant';
      expect(AbstractAnimal.staticName, 'Plant');
      expect(AbstractAnimal.staticTalk(), 'I am an Plant');
    });

    test('should access Dart members', () {
      /// In DDC, this seems to alias the JS constructor function.
      /// In Dart2JS, this seems to create an object that does not contain
      /// the JS methods.
      final animal = AbstractAnimal('Dog');
      /// @JS() classes cannot add properties.
      expect(animal.dartName, null);
      expect(animal.dartName2, null);
      expect(animal.dartName3, null);
      if (isDartDevC) {
        expect(animal.name, 'Dog');
        /// In DDC, static properties are null and static methods throw
        /// `NoSuchMethodError`. However, the talk() method still works.
        expect(AbstractAnimal.dartStaticName, null);
        expect(AbstractAnimal.dartStaticConstName, null);
        // I cant seem to figure out how to catch the NoSuchMethodError.
        // expect(AbstractAnimal.dartStaticTalk(), throwsNoSuchMethodError);
        expect(animal.talk(), 'I am a Dog');
      } else if (isDart2JS) {
        expect(animal.name, 'Dog');
        /// Static properties and methods work in Dart2JS only.
        /// However, the talk() method no longer exists.
        expect(AbstractAnimal.dartStaticName, 'Animal');
        expect(AbstractAnimal.dartStaticConstName, 'Animal');
        expect(AbstractAnimal.dartStaticTalk(), 'I am an Animal');
        // I cant seem to figure out how to catch the NoSuchMethodError.
        // expect(animal.talk(), throwsNoSuchMethodError);
      }
      animal.name = 'Cat';
      expect(animal.name, 'Cat');
    });
  });
}
