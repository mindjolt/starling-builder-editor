/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starling.display.DisplayObjectContainer;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.util.history.IHistoryOperation;

    import starling.display.DisplayObject;

    public class MoveLayerOperation extends AbstractHistoryOperation
    {
        private var _oldParent:DisplayObjectContainer;
        private var _newParent:DisplayObjectContainer;

        public function MoveLayerOperation(target:Object, newParent:DisplayObjectContainer, beforeLayer:int, afterLayer:int)
        {
            super(OperationType.MOVE_LAYER, target, beforeLayer, afterLayer);

            _target = target;
            _oldParent = _target.parent;
            _newParent = newParent;
        }

        override public function undo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                _oldParent.addChildAt(obj, int(_beforeValue));
            }

            setChanged();
        }

        override public function redo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                _newParent.addChildAt(obj, int(_afterValue));
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
