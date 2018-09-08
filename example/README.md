# example

How it works

// auto manage inject.


@Cofiguration
class MyModel{

    @Bean
    NetworkModel createNetworkModel(){
        return null;
    }

}

The build system will scan all the files of your project. The class with meta Model will be considered as model class ,and will create a .part file with it.

@Model("statename")
class MyModel{



    MyModel({
        @Inject
        NetworkModel model
    });

    State event(State state){

    }

}

```

$dvaModelMyModel(ModelProxy proxy,dynamic model){
    proxy.registerSync( "statename.event",model.event);  or proxy.registerSync("statname.event",(state,payload)=>{ model.event(state)  };
    proxy.registerAsync("xxxx");
}



Dva.of(context).push("",param);
Dva.of(context).pop();

@Push();
@Pop()
@PopUntil("");
@PopOrPush("");
@PopToHome()

@Event(type="push",data="myroute");




```

@Route("")
MyClass extends Widet{

    MyClass({
        @StateValue(Constants.statename.name)
        this.value
    });
}

```

$dvaView<WidgetType>(  (buildContext c dynamic paramFromRoute){

})

```


$dvaRegisterModules();
$dvaRegisterModels();
$dvaRegisterViews();


new Dva(
    models:[],
    routes:{
        "",(c,p)=>
        "",(c,p)=>
    }
    childBuilder:( BuildContext c,dynamic param ){
        retrun Dva.connect();
    }
);
