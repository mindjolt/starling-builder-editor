/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.tools.util
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileReference;

    public class FileLoader
    {
        public function FileLoader()
        {

        }

        public static function load(onComplete:Function):void
        {
            var name:String;

            var file:FileReference = new FileReference();


            file.addEventListener(Event.SELECT, onFileSelected);
            file.addEventListener(Event.CANCEL, onFileCanceled);
            file.browse();


            function onFileSelected(event:Event)
            {
                name = file["nativePath"];
                file.removeEventListener(Event.SELECT, onFileSelected);
                file.removeEventListener(Event.CANCEL, onFileCanceled);

                file.addEventListener(Event.COMPLETE, onLoadComplete);
                file.load();
            }

            function onFileCanceled(event:Event):void
            {
                file.removeEventListener(Event.SELECT, onFileSelected);
                file.removeEventListener(Event.CANCEL, onFileCanceled);

            }

            function onLoadComplete(event:Event):void
            {
                file.removeEventListener(Event.COMPLETE, onLoadComplete);

                if (isImage(name))
                {
                    var loader:Loader = new Loader();
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadTextureComplete);
                    loader.loadBytes(file.data);
                }
                else
                {
                    if (onComplete)
                        onComplete(file.data, name);
                }
            }

            function onLoadTextureComplete(event:Event):void
            {
                var loaderInfo:LoaderInfo = event.target as LoaderInfo;
                loaderInfo.removeEventListener(Event.COMPLETE, onLoadTextureComplete);

                if (onComplete)
                    onComplete(loaderInfo.content, name);
            }
        }

        private static function isImage(name:String):Boolean
        {
            var n:String = name.toLowerCase();
            return (n.indexOf(".png") >= 0 || n.indexOf(".jpg") >=0 || n.indexOf("atf") >= 0);
        }

        public static function save(data:Object, fileName:String, onComplete:Function):void
        {
            var file:FileReference = new FileReference();
            file.addEventListener(Event.COMPLETE, onSaveComplete);
            file.save(JSON.stringify(data), fileName);

            function onSaveComplete(event:*):void
            {
                file.removeEventListener(Event.COMPLETE, onComplete);

                if (onComplete)
                    onComplete();
            }
        }


        public static function browse(onComplete:Function = null):void
        {
            var file:FileReference = new FileReference();

            file.addEventListener(Event.SELECT, onFileSelected);
            file.addEventListener(Event.CANCEL, onFileCanceled);
            file.browse();

            function onFileSelected(event:Event)
            {
                file.removeEventListener(Event.SELECT, onFileSelected);
                file.removeEventListener(Event.CANCEL, onFileCanceled);

                if (onComplete)
                    onComplete(file.name);
            }

            function onFileCanceled(event:Event):void
            {
                file.removeEventListener(Event.SELECT, onFileSelected);
                file.removeEventListener(Event.CANCEL, onFileCanceled);
            }
        }

        public static function browseForDirectory(title:String, onComplete:Function = null):void
        {
            var file:File = File.documentsDirectory;

            file.addEventListener(Event.SELECT, onSelect);
            file.browseForDirectory(title);

            function onSelect(event:Event):void
            {
                file.removeEventListener(Event.SELECT, onSelect);

                if (onComplete)
                    onComplete(file);
            }

        }




    }
}
