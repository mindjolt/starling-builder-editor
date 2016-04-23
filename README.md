#Starling Builder

####Overview

Starling Builder is a user interface editor for Starling.

It’s built on top of Starling/Feathers UI framework. You can edit your user interfaces in Starling Builder, export them to JSON layout files, and create the starling display objects directly in the game. It provides an WYSIWYG way to create any in-game UI in minutes.

There are 2 parts in Starling Builder: the [engine](https://github.com/mindjolt/starling-builder-engine) and [editor](https://github.com/mindjolt/starling-builder-editor). The engine is a module responsible for converting layout files into display objects. Both the game and the editor rely on it. The editor is a standalone application where you create your UI layouts.

Normally you don't need to check out the editor source unless you want to expand the tool,
you can download the latest editor app and demo workspace at http://starlingbuilder.github.io/

There are 2 versions of the editors (Starling 1.x version and Starling 2.x version), please make sure to download the one you are planning to use in your project.

####Check out editor repository:
```
git clone https://github.com/mindjolt/starling-builder-editor --recursive
```


You will need to checkout the engine repo to put it into your game. It also contains a demo project, available at http://starlingbuilder.github.io/demo/demo_web.html

####Check out engine repository:
```
git clone https://github.com/mindjolt/starling-builder-engine
```

If you want to create custom UI components or feathers theme for the editor, check out the extensions repository at https://github.com/mindjolt/starling-builder-extensions

####Toubleshooting

If the editor crashes when it starts without prompting an error, it's most likely that your runtime libraries inside YOUR_WORKSPACE/libs are not compatible with the current Starling Builder version.
This happens when Starling Builder is built with a Starling/Feathers version different than the one inside your libs. You can solve the problem by either removing the problematic swf files from YOUR_WORKSPACE/libs, or recompile/download those files with the correct version of Starling/Feathers


####Documentation

For more information, please visit our wiki page at http://wiki.starling-framework.org/builder/start





