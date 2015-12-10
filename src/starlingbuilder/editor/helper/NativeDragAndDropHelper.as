/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.desktop.ClipboardFormats;
    import flash.desktop.NativeDragManager;
    import flash.display.Shape;
    import flash.display.Stage;
    import flash.events.NativeDragEvent;
    import flash.filesystem.File;

    import starling.core.Starling;

    public class NativeDragAndDropHelper
    {
        public function NativeDragAndDropHelper()
        {
        }

        public static function start(onComplete:Function):void
        {
            var stage:Stage = Starling.current.nativeStage;

            var sprite:flash.display.Sprite = new flash.display.Sprite();

            var shape:Shape = new Shape();
            shape.graphics.beginFill(0xff0000);
            shape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            shape.graphics.endFill();
            shape.alpha = 0;

            sprite.addChild(shape);

            stage.addChild(sprite);

            stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onNativeEnter);
            stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onNativeDrop);

            function onNativeEnter(e:NativeDragEvent):void
            {
                //trace("on native enter");
                NativeDragManager.acceptDragDrop(Starling.current.nativeStage);
            }

            function onNativeDrop(e:NativeDragEvent):void
            {
                //trace("on native drop");
                if (e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
                {
                    var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array

                    if (files.length == 1)
                    {
                        var f:File = File(files[0]);

                        //trace(f.url);

                        if (onComplete)
                        {
                            onComplete(f);
                        }
                    }
                }
            }
        }
    }
}
