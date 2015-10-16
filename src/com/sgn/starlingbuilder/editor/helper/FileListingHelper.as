/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.helper
{
    import flash.filesystem.File;

    public class FileListingHelper
    {
        public function FileListingHelper()
        {
        }

        public static function getFileList(file:File, path:String, postfix:Array = null):Array
        {
            var array:Array = [];

            var appDir:File = file.resolvePath(path);

            if (!file.exists)
            {
                return array;
            }

            var listing:Array = appDir.getDirectoryListing();
            for each (var file:File in listing)
            {
                if (file.name.charAt(0) == ".")
                    continue;

                if (postfix && postfix.indexOf(getPostfix(file.name).toLowerCase()) == -1)
                    continue;

                array.push(stripPostfix(file.name));
            }

            return array;
        }

        public static function stripPostfix(name:String):String
        {
            var index:int = name.indexOf(".");
            if (index != -1)
                return name.substring(0, index);
            else
                return name;
        }

        private static function getPostfix(name:String):String
        {
            var index:int = name.lastIndexOf(".");

            if (index == -1)
                return null;
            else
                return name.substring(index + 1);
        }
    }
}
