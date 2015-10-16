/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.data
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class TemplateData
    {
        public function TemplateData()
        {
        }

        public static var editor_template_string:String;

        public static var editor_template:Object;

        public static function load(customTemplate:String = null, workspace:File = null):void
        {
            editor_template_string = mergeCustomTemplate(customTemplate);
            parseToTemplate(editor_template_string);

            loadExternalTemplate(workspace);
        }

        public static function getSupportedComponent(tag:String = null):Array
        {
            var array:Array = [];

            for each (var item:Object in editor_template.supported_components)
            {
                if (tag == null || item.tag == tag)
                {
                    array.push(item.cls);
                }
            }

            return array;
        }

        public static function loadExternalTemplate(workspace:File):void
        {
            if (workspace == null) return;

            var dir:File = workspace.resolvePath("settings");

            if (!dir.exists)
                dir.createDirectory();

            var file:File = dir.resolvePath("editor_template.json");
            if (file.exists)
            {
                var fs2:FileStream = new FileStream();
                fs2.open(file, FileMode.READ);
                var data:String = fs2.readUTFBytes(fs2.bytesAvailable);
                fs2.close();
                var template:Object = JSON.parse(data);
            }

            //if file not exist or revision property not exists or external template older than the default template, then overwrite it
            //otherwise use the external template
            if (!file.exists || !template.hasOwnProperty('revision') || template.revision < editor_template.revision)
            {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeUTFBytes(editor_template_string);
                fs.close();
            }
            else
            {
                parseToTemplate(data);
            }
        }

        private static function mergeCustomTemplate(customTemplate:String):String
        {
            var data:String = new EmbeddedData.editor_template();

            if (customTemplate == null)
            {
                return data;
            }
            else
            {
                customTemplate = stripCustomTemplate(customTemplate);
                var index:int = data.lastIndexOf("}") - 1;
                return data.substring(0, index) + ",\n" + customTemplate + data.substring(index);
            }
        }

        private static function stripCustomTemplate(customTemplate:String):String
        {
            var start:int = customTemplate.indexOf('{') + 1;
            var end:int = customTemplate.lastIndexOf('}');
            return customTemplate.substring(start, end);
        }

        private static function parseToTemplate(data:String):void
        {
            editor_template = JSON.parse(data);

            for each (var item:Object in editor_template.custom_components)
            {
                editor_template.supported_components.push(item);
            }
        }


    }
}
