/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starlingbuilder.engine.format.StableJSONEncoder;

    import starlingbuilder.util.persist.DefaultPersistableObject;

    public class WorkspaceSetting extends DefaultPersistableObject
    {
        public var assetPath:String = "";

        public var libraryPath:String = "";

        public var backgroundPath:String = "";

        public var localizationPath:String = "";

        public static const PATH:String = "settings/workspace_setting.json";

        override public function persist():void
        {
            var data:String = StableJSONEncoder.stringify(save());

            var file:File = UIEditorScreen.instance.workspaceDir.resolvePath(PATH);
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.WRITE);
            fs.writeUTFBytes(data);
            fs.close();
        }

        override protected function recover():void
        {
            var file:File = UIEditorScreen.instance.workspaceDir.resolvePath(PATH);
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.READ);
            load(JSON.parse(fs.readUTFBytes(fs.bytesAvailable)));
        }

        public function getAssetManagerPaths():Array
        {
            var paths:Array = [];

            for each (var path:String in assetPath.split(":"))
            {
                paths.push(path);
            }

            paths.push(libraryPath);
            paths.push(backgroundPath);
            paths.push(localizationPath);

            return paths;
        }
    }
}
