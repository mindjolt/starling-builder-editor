/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;

    import starlingbuilder.editor.UIEditorApp;

    import starlingbuilder.util.history.IHistoryOperation;

    public class GroupOperation extends SingleHistoryOperation
    {
        private var _children:Array;

        public function GroupOperation(container:Object, children:Array)
        {
            super(OperationType.GROUP, container, null, null);
            _children = children;
        }

        override public function undo():void
        {
            var container:DisplayObjectContainer = _target as DisplayObjectContainer;

            var parent:DisplayObjectContainer = container.parent;
            var index:int = parent.getChildIndex(container);
            container.removeFromParent();

            for (var i:int = _children.length - 1; i >= 0; --i)
            {
                var obj:DisplayObject = _children[i];
                parent.addChildAt(obj, index);
            }

            UIEditorApp.instance.documentManager.setLayerChanged();
            UIEditorApp.instance.documentManager.setChanged();
        }

        override public function redo():void
        {
            var container:DisplayObjectContainer = _target as DisplayObjectContainer;

            var first:DisplayObject = _children[0];
            var parent:DisplayObjectContainer = first.parent;
            var firstIndex:int = parent.getChildIndex(first);

            for each (var obj:DisplayObject in _children)
            {
                container.addChild(obj);
            }

            parent.addChildAt(container, firstIndex);

            UIEditorApp.instance.documentManager.setLayerChanged();
            UIEditorApp.instance.documentManager.setChanged();
        }

        override public function canMergeWith(previousOperation:IHistoryOperation):Boolean
        {
            return false;
        }

        override public function info():String
        {
            return "Group";
        }
    }
}
