/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.util.history.IHistoryOperation;

    import starling.display.DisplayObject;

    public class MoveLayerOperation extends AbstractHistoryOperation
    {
        public function MoveLayerOperation(target:Object, beforeLayer:int, afterLayer:int)
        {
            super(OperationType.MOVE_LAYER, target, beforeLayer, afterLayer);

            _target = target;

        }

        override public function undo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                obj.parent.setChildIndex(obj, int(_beforeValue));
            }

            setChanged();
        }

        override public function redo():void
        {
            var obj:DisplayObject = _target as DisplayObject;

            if (obj)
            {
                obj.parent.setChildIndex(obj, int(_afterValue));
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
