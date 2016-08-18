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

    import starling.display.DisplayObjectContainer;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.util.history.IHistoryOperation;

    import starling.display.DisplayObject;

    public class MoveLayerOperation extends SingleHistoryOperation
    {
        private var _oldParent:DisplayObjectContainer;
        private var _newParent:DisplayObjectContainer;

        private var _beforePosition:Point;
        private var _afterPosition:Point;

        public function MoveLayerOperation(target:Object, oldParent:DisplayObjectContainer, beforeLayer:int, afterLayer:int, beforePosition:Point = null, afterPosition:Point = null)
        {
            super(OperationType.MOVE_LAYER, target, beforeLayer, afterLayer);

            _target = target;
            _oldParent = oldParent;
            _newParent = target.parent;

            _beforePosition = beforePosition;
            _afterPosition = afterPosition;
        }

        override public function undo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                _oldParent.addChildAt(obj, int(_beforeValue));
                if (_beforePosition)
                {
                    obj.x = _beforePosition.x;
                    obj.y = _beforePosition.y;
                }
            }

            setChanged();
        }

        override public function redo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                _newParent.addChildAt(obj, int(_afterValue));
                if (_afterPosition)
                {
                    obj.x = _afterPosition.x;
                    obj.y = _afterPosition.y;
                }
            }

            setChanged();
        }

        override public function info():String
        {
            return "Move Layer";
        }

        override protected function setChanged():void
        {
            UIEditorApp.instance.documentManager.setLayerChanged();
            UIEditorApp.instance.documentManager.setChanged();
        }

        override public function canMergeWith(previousOperation:IHistoryOperation):Boolean
        {
            return false;
        }

    }
}
