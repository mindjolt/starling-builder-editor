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
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    public class SingleHistoryOperation extends AbstractHistoryOperation
    {
        protected var _target:Object;
        protected var _beforeValue:Object;
        protected var _afterValue:Object;

        public function SingleHistoryOperation(type:String, target:Object, beforeValue:Object, afterValue:Object)
        {
            super(type);

            _target = target;
            _beforeValue = beforeValue;
            _afterValue = afterValue;
        }

        override public function get beforeValue():Object
        {
            return _beforeValue;
        }

        override public function merge(previousOperation:IHistoryOperation):void
        {
            _beforeValue = previousOperation.beforeValue;
        }

        protected function setChanged():void
        {
            PropertyPanel.globalDispatcher.dispatchEventWith(UIMapperEventType.PROPERTY_CHANGE, false, {target:_target});
            UIEditorApp.instance.documentManager.boundingBoxContainer.reload();
        }
    }
}
