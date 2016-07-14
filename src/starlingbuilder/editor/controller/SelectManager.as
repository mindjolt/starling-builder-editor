/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.controller
{
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import starling.core.Starling;
    import starling.display.DisplayObject;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.EventDispatcher;

    import starlingbuilder.editor.events.DocumentEventType;
    import starlingbuilder.engine.IUIBuilder;

    public class SelectManager extends EventDispatcher
    {
        private var _selectedObjects:Array;

        public function SelectManager()
        {
            _selectedObjects = new Array();
        }

        public function selectObject(object:DisplayObject):void
        {
            if (object == null)
            {
                if (_selectedObjects.length != 0)
                {
                    _selectedObjects.length = 0;
                    setChanged();
                }
            }
            else
            {
                if (_selectedObjects.indexOf(object) == -1 || _selectedObjects.length != 1)
                {
                    _selectedObjects.length = 0;
                    _selectedObjects.push(object);
                    setChanged();
                }
            }
        }

        public function isSelected(object:DisplayObject):Boolean
        {
            return _selectedObjects.indexOf(object) != -1;
        }

        public function addSelectObject(object:DisplayObject):void
        {
            if (_selectedObjects.indexOf(object) == -1)
            {
                _selectedObjects.push(object);
                setChanged();
            }
        }

        public function removeSelectObject(object:DisplayObject):void
        {
            var index:int = _selectedObjects.indexOf(object);
            if (index >= 0)
            {
                _selectedObjects.splice(index, 1);
                setChanged();
            }
        }

        public function purge():void
        {
            _selectedObjects.length = 0;
            setChanged();
        }

        public function get selectedObject():DisplayObject
        {
            if (_selectedObjects.length == 1)
                return _selectedObjects[0];
            else
                return null;
        }

        public function get selectedObjects():Array
        {
            return _selectedObjects;
        }

        private function setChanged():void
        {
            dispatchEventWith(DocumentEventType.SELECTION_CHANGE);
        }

        private function allParentsTrue(obj:DisplayObject, propertyName:String):Boolean
        {
            while (obj && propertyName in obj)
            {
                if (!obj[propertyName]) return false;
                obj = obj.parent; 
            }

            return true;
        }

        public function selectByRect(rect:Rectangle, paramsDict:Dictionary, uiBuilder:IUIBuilder):void
        {
            for (var obj:DisplayObject in paramsDict)
            {
                if (!allParentsTrue(obj, "touchable") || !allParentsTrue(obj, "visible")) continue;

                var bound:Rectangle = obj.getBounds(Starling.current.stage);

                if (_selectedObjects.indexOf(obj) == -1)
                {
                    if (rect.intersects(bound) && (!uiBuilder.isContainer(paramsDict[obj])))
                    {
                        _selectedObjects.push(obj);
                    }

                    //allow empty container to be selected
                    if ((bound.width == 0 && bound.height == 0) && rect.contains(bound.x, bound.y) && isEmptyContainer(obj))
                    {
                        _selectedObjects.push(obj);
                    }
                }
            }

            setChanged();
        }

        private function isEmptyContainer(obj:DisplayObject):Boolean
        {
            return (obj is DisplayObjectContainer && (obj as DisplayObjectContainer).numChildren == 0);
        }
    }
}
