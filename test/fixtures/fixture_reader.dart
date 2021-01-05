import 'dart:io';

/// A method which reads file and parses it as a string
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
