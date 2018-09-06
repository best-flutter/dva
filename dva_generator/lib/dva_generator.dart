library dva_generator.builder;

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';

import 'package:dva_annotation/dva_annotation.dart';



class DvaAnnotation extends Builder{



  TypeChecker typeChecker = new TypeChecker.fromRuntime(Router);


  Iterable<ClassElement> withAnnotation(LibraryReader reader,TypeChecker typeChecker) sync*{
    for (AnnotatedElement annotatedElement in reader.annotatedWith(typeChecker)) {
      if(annotatedElement is ClassElement){
        yield annotatedElement.element as ClassElement;
      }
    }
  }






  @override
  Future build(BuildStep buildStep) async{

    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;
    LibraryElement library = await buildStep.inputLibrary;


    String path =buildStep.inputId.path;
    Completer completer = new Completer();
    if(path.contains(new RegExp(r"main\.dart"))){
      print(path);


      File file = new File(path);
      Directory directory = file.parent;
      directory.list(recursive: true).listen( (FileSystemEntity entry) async{

        print(entry.path);
        if(entry is File){
          if(entry.path.endsWith("dart")){
            AssetId id = new AssetId(buildStep.inputId.package,entry.path);
            print(await buildStep.readAsString(id));
          }
        }

      },onDone: completer.complete);

      await completer.future;


      buildStep.writeAsString(buildStep.inputId.changeExtension(".dva.dart"), "generated");
    }





  }

  @override
  Map<String, List<String>> get buildExtensions => {
    ".dart":[".dva.dart"]
  };

}



Builder dvaAnnotation(BuilderOptions opts)=>new DvaAnnotation();