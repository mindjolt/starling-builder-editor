/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    public class PropertyChangeOperation extends AbstractHistoryOperation
    {
        protected var _propertyName:String;

        public function PropertyChangeOperation(target:Object, propertyName:String, beforeValue:Object, afterValue:Object)
        {
            super(OperationType.CHANGE_PROPERTY, target, beforeValue, afterValue);

            _target = target;
            _propertyName = propertyName;
        }

        override public function undo():void
        {
            _target[_propertyName] = _beforeValue;
            setChanged();
        }

        override public function redo():void
        {
            _target[_propertyName] = _afterValue;
            setChanged();
        }

        override public function info():String
        {
            return "Change " + _propertyName;
            //return JSON.stringify({type:_type, propertyName:_propertyName, beforeValue:_beforeValue, afterValue:_afterValue});

        }

        override protected function setChanged():void
        {
            PropertyPanel.globalDispatcher.dispatchEventWith(UIMapperEventType.PROPERTY_CHANGE, false, {target:_target, propertyName:_propertyName});
        }
    }
}
