library dva_generator.builder;

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:dva_annotation/dva_annotation.dart';


const String _kPrefix = "\$dva";



class DvaAnnotation extends Builder{

  TypeChecker routerType = new TypeChecker.fromRuntime(Router);
  TypeChecker modelType = new TypeChecker.fromRuntime(Model);
  TypeChecker configurationType = new TypeChecker.fromRuntime(Configuration);

  Iterable<ClassElement> withAnnotation(LibraryReader reader,TypeChecker typeChecker) sync*{
    for (AnnotatedElement annotatedElement in reader.annotatedWith(typeChecker)) {
      if(annotatedElement is ClassElement){
        yield annotatedElement.element as ClassElement;
      }
    }
  }

  Iterable<String> handleModel(ClassElement modelClass,DartObject a ) sync*{
    String superName = modelClass.supertype.name;
    if(superName == 'BaseModel'){
      String name = a.getField("name").toStringValue();
      if(name == null || name.isEmpty){
        //没有名字
        print("Mode must have a name");
      }

      print("typeparamter:${modelClass.supertype.typeArguments}");


      DartType stateType;
      List<DartType>  typeArguments = modelClass.supertype.typeArguments;
      if(typeArguments!=null && typeArguments.isNotEmpty){
        stateType = typeArguments[0];
      }else{
        print("A type parameter must be supplied");
        return;
      }
      print("============================$modelClass");
      yield "void $_kPrefix${modelClass.name}(ModelProxy proxy,dynamic model){";

      // just public methods
      for(MethodElement method in modelClass.methods){
        if(method.name.startsWith("_")){
          print("Skip private method ${method.name}");
          continue;
        }
        if(method.name=='getInitialState'){

          continue;
        }
        List<ParameterElement> parameters = method.parameters;
        DartType returnType = method.returnType;
          if(returnType == stateType){
            //this is a sync method
            yield "\tproxy.registerSync(\"$name/${method.name}\",model.${method.name});";
          }else if(returnType.name.startsWith("Future") || method.isAsynchronous){
            print("method is a future");
            yield "\tproxy.registerAsync(\"$name/${method.name}\",model.${method.name});";

          }
      }
      yield "}";
    }else{
      print("Model is not a BaseModel");
    }
  }

  Iterable<String> generateContent( LibraryReader reader,BuildStep buildStep){
    //yield "import package:dva/dva.dart;";
   // yield "import \"package:${ buildStep.inputId.package}/${buildStep.inputId.path.substring(4)}\";";
    List<String> codes = [];
    for(ClassElement element in reader.classElements){
      print(element);

      print(element.metadata);

      for(ElementAnnotation annotation in element.metadata){
        DartObject a = modelType.firstAnnotationOf(element,
            throwOnUnresolved: true);
        if(a!=null){
          codes.addAll(handleModel(element,a)) ;
          //model
          continue;
        }
      }

    }


    return codes;

  }


  @override
  Future build(BuildStep buildStep) async{

    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;
    LibraryElement library = await buildStep.inputLibrary;
    LibraryReader reader = new LibraryReader(library);

    Iterable<String> content = generateContent(reader,buildStep);
    if(content.length > 0)
      buildStep.writeAsString(buildStep.inputId.changeExtension(".dva.dart"), content.join("\n"));
    /*
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
*/




  }

  @override
  Map<String, List<String>> get buildExtensions => {
    ".dart":[".dva.dart"]
  };

}



Builder dvaAnnotation(BuilderOptions opts)=>new DvaAnnotation();