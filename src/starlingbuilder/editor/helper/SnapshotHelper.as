/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.display.BitmapData;
    import flash.display.PNGEncoderOptions;
    import flash.display.Stage;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.display.DisplayObject;

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
        public static function snapshot(displayObject:DisplayObject, size:Point, fileName:String):void
        {
            var stage:Stage = Starling.current.nativeStage;

            var oldWidth:Number = stage.stageWidth;
            var oldHeight:Number = stage.stageHeight;

            Starling.current.stage.addChild(displayObject);

            stage.stageWidth = size.x;
            stage.stageHeight = size.y

            setTimeout(function():void{
                var bitmapData:BitmapData = Starling.current.stage.drawToBitmapData();
                var byteArray:ByteArray = new ByteArray();
                bitmapData.encode(new flash.geom.Rectangle(0, 0, bitmapData.width, bitmapData.height), new PNGEncoderOptions(), byteArray);
                var file:File = UIEditorScreen.instance.workspaceDir.resolvePath(fileName);
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeBytes(byteArray);
                fs.close();

                displayObject.removeFromParent(true);

                stage.stageWidth = oldWidth;
                stage.stageHeight = oldHeight;
            }, 1);
        }
    }
}
