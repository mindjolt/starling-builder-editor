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
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class TemplateLoader
    {
        public static function load(workspaceDir:File, fileName:String, cls:Class):void
        {
            var file:File = workspaceDir.resolvePath("settings/" + fileName + ".json");

            var data:String;

            if (file.exists)
            {
                try
                {
                    var fs:FileStream = new FileStream();
                    fs.open(file, FileMode.READ);
                    data = fs.readUTFBytes(fs.bytesAvailable);
                    cls.template = JSON.parse(data);
                }
                catch (e:Error)
                {
                    InfoPopup.show("Invalid " + fileName + ".json. Default template loaded.");

                    data = new EmbeddedData[fileName]();
                    cls.template = JSON.parse(data);
                }
            }
            else
            {
                data = new EmbeddedData[fileName]();
                cls.template = JSON.parse(data);

                var fs2:FileStream = new FileStream();
                fs2.open(file, FileMode.WRITE);
                fs2.writeUTFBytes(data);
                fs2.close();
            }
        }
    }
}
