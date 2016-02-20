/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import flash.geom.Rectangle;

    public class ResizeOperation extends SingleHistoryOperation
    {
        public function ResizeOperation(target:Object, beforeValue:Object, afterValue:Object)
        {
            super(OperationType.RESIZE, target, beforeValue, afterValue);
        }

        override public function undo():void
        {
            var rect:Rectangle = _beforeValue as Rectangle;
            _target.x = rect.x;
            _target.y = rect.y;
            _target.width = rect.width;
            _target.height = rect.height;
            setChanged();
        }

        override public function redo():void
        {
            var rect:Rectangle = _afterValue as Rectangle;
            _target.x = rect.x;
            _target.y = rect.y;
            _target.width = rect.width;
            _target.height = rect.height;
            setChanged();
        }

        override public function info():String
        {
            return "Resize";
        }
    }
}
