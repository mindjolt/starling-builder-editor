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
            for each (var f:File in listing)
            {
                if (f.name.charAt(0) == ".")
                    continue;

                if (postfix && (!getPostfix(f.name) || postfix.indexOf(getPostfix(f.name).toLowerCase()) == -1))
                    continue;

                array.push(stripPostfix(f.name));
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

        public static function getFilesRecursive(file:File, referenceFile:File = null):Array
        {
            if (referenceFile == null) referenceFile = file;

            var res:Array = [];

            if (file.isDirectory)
            {
                var listing:Array = file.getDirectoryListing();

                for each (var f:File in listing)
                {
                    if (f.name.charAt(0) == ".")
                        continue;

                    if (f.isDirectory)
                    {
                        res = res.concat(getFilesRecursive(f, referenceFile));
                    }
                    else
                    {
                        res.push(referenceFile.getRelativePath(f, true));
                    }
                }
            }

            return res;
        }
    }
}
