/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starlingbuilder.util.history.IHistoryOperation;
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    import flash.utils.getTimer;

    public class AbstractHistoryOperation implements IHistoryOperation
    {
        public static const MAX_OPERATION_TIME:Number = 300;

        protected var _type:String;
        protected var _timestamp:Number;

        protected var _target:Object;
        protected var _beforeValue:Object;
        protected var _afterValue:Object;

        public function AbstractHistoryOperation(type:String, target:Object, beforeValue:Object, afterValue:Object)
        {
            _type = type;
            _timestamp = getTimer();

            _target = target;
            _beforeValue = beforeValue;
            _afterValue = afterValue;
        }

        public function get type():String
        {
            return _type;
        }

        public function get timestamp():Number
        {
            return _timestamp;
        }

        public function get beforeValue():Object
        {
            return _beforeValue;
        }

        public function canMergeWith(previousOperation:IHistoryOperation):Boolean
        {
            return previousOperation.type == _type && (_timestamp - previousOperation.timestamp < MAX_OPERATION_TIME)
        }

        public function merge(previousOperation:IHistoryOperation):void
        {
            _beforeValue = previousOperation.beforeValue;
        }

        public function redo():void
        {
        }

        public function undo():void
        {
        }

        public function info():String
        {
            return "";
        }

        public function dispose():void
        {
        }

        protected function setChanged():void
        {
            PropertyPanel.globalDispatcher.dispatchEventWith(UIMapperEventType.PROPERTY_CHANGE, false, {target:_target});
        }
    }
}
