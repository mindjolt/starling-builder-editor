/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starlingbuilder.editor.data.EmbeddedData;

    public class TemplateLoader
    {
        public static function load(workspaceDir:File, fileName:String, cls:Class):void
        {
            var file:File = workspaceDir.resolvePath("settings/" + fileName + ".json");

            var data:String;

            if (file.exists)
            {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                data = fs.readUTFBytes(fs.bytesAvailable);
            }
            else
            {
                data = new EmbeddedData[fileName]();

                var fs2:FileStream = new FileStream();
                fs2.open(file, FileMode.WRITE);
                fs2.writeUTFBytes(data);
                fs2.close();
            }

            cls.template = JSON.parse(data);
        }
    }
}
