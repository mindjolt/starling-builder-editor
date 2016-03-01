/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.desktop.NativeApplication;
    import flash.display.BitmapData;
    import flash.display.JPEGEncoderOptions;
    import flash.display.NativeWindow;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Stage;

    import starlingbuilder.editor.UIEditorScreen;

    public class SnapshotHelper
    {
        /**
         * Make a snapshot of a display object
         *
         * 1. Set stage size to display object size
         * 2. Add display object to stage
         * 3. Call Starling.current.stage.drawToBitmapData()
         * 4. Remove display object from stage
         * 5. Recover old stage size
         *
         * @param displayObject
         * @param fileName
         */
        public static function snapshot(displayObject:DisplayObject, fileName:String):void
        {
            var stage:Stage = Starling.current.stage;

            var window:NativeWindow = NativeApplication.nativeApplication.activeWindow;

            var oldWidth:Number = window.width;
            var oldHeight:Number = window.height;

            stage.addChild(displayObject);

            Starling.current.nativeStage.stageWidth = displayObject.width;
            Starling.current.nativeStage.stageHeight = displayObject.height;

            setTimeout(function():void{
                var bitmapData:BitmapData = Starling.current.stage.drawToBitmapData();
                var byteArray:ByteArray = new ByteArray();
                bitmapData.encode(new flash.geom.Rectangle(0, 0, bitmapData.width, bitmapData.height), new JPEGEncoderOptions(), byteArray);
                var file:File = UIEditorScreen.instance.workspaceDir.resolvePath(fileName);
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeBytes(byteArray);
                fs.close();

                displayObject.removeFromParent(true);

                Starling.current.nativeStage.stageWidth = oldWidth;
                Starling.current.nativeStage.stageHeight = oldHeight;
            }, 1);
        }
    }
}
