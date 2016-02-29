/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import flash.geom.Point;

    public class MoveOperation extends SingleHistoryOperation
    {
        public function MoveOperation(target:Object, dx:Number, dy:Number)
        {
            var beforeValue:Point = new Point(target.x - dx, target.y - dy);
            var afterValue:Point = new Point(target.x, target.y);

            super(OperationType.MOVE, target, beforeValue, afterValue);
        }

        override public function undo():void
        {
            _target.x = _beforeValue.x;
            _target.y = _beforeValue.y;
            setChanged();
        }

        override public function redo():void
        {
            _target.x = _afterValue.x;
            _target.y = _afterValue.y;
            setChanged();
        }

        override public function info():String
        {
            return "Move";
        }


    }
}
