/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.tools.util.feathers
{
    import feathers.controls.Button;
    import feathers.controls.Callout;
    import feathers.controls.List;
    import feathers.controls.ScrollContainer;
    import feathers.data.ListCollection;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class DataList extends ScrollContainer
    {
        private static const MIN_INPUT_WIDTH:int = 300;

        private var _data:String = "";

        private var _container:ScrollContainer;

        private var _callout:Callout;

        private var _dataTemplate:Object = {"default": {"default": 0}};

        private var _labelCallbackFunction:Function;
        private var _dataPushCallbackFunction:Function;

        private var _externalIndex:String;

        private var _type:String;

        public function DataList(type:String = null)
        {
            _type = type;

            super();

            init();
        }

        private function init():void
        {
            _container = FeathersUIUtil.scrollContainerWithVerticalLayout();

            addChild(_container);

            reloadData();
        }

        public function setLabelFunction(func:Function):void
        {
            _labelCallbackFunction = func;
        }

        public function setDataPushFunction(func:Function):void
        {
            _dataPushCallbackFunction = func;
        }

        public function get data():String
        {
            return _data;
        }

        public function set data(value:String):void
        {
            _data = value;

            reloadData();
        }

        private function getSortedKeys(object:Object):Array
        {
            var array:Array = [];

            var item:Object;

            var id:String;


            if (object is Array)
            {
                for each (item in object)
                {
                    if (item is String)
                    {
                        array.push("data");
                        break;
                    }
                    else
                    {
                        for (id in item)
                        {
                            if (array.indexOf(id) == -1)
                                array.push(id);
                        }
                    }
                }
            }
            else
            {
                item = object;

                for (id in item)
                {
                    if (array.indexOf(id) == -1)
                        array.push(id);
                }
            }

            array.sort();
            return array;
        }

        private function reloadData():void
        {
            _container.removeChildren();

            if (_data == null) return;

            _container.width = MIN_INPUT_WIDTH;

            var button:Button;
            button = new Button;
            button.label = getButtonLabel(_data);
            button.addEventListener(Event.TRIGGERED, onEditButton);
            _container.addChild(button);

            invalidate();
        }

        public function getButtonLabel(object:String = null):String
        {
            if (_labelCallbackFunction is Function)
            {
                return _labelCallbackFunction(object);
            }
            else
            {
                return object ? object : "edit";
            }
        }

        /*private function rowIndex(displayObject:DisplayObject):int
         {
         var index:int = _container.getChildIndex(displayObject);

         return index - 1;
         }*/

        /*public function setPopup(popup:BasePopupDev):void
         {
         _popup = popup;
         }*/

        private function onEditButton(event:Event):void
        {
            /*_editedIndex = rowIndex((event.target as DisplayObject).parent.parent);

             if(!_popup)
             {
             _popup = new EditDataPopup(_type);
             }

             _popup.initData(_data[_editedIndex]);
             _popup.addEventListener(Event.COMPLETE, onEditDataComplete);
             PopUpManager.addPopUp(_popup);*/
            var list:List = new List();
            list.addEventListener(Event.CHANGE, onListSelect);
            list.dataProvider = new ListCollection(getSortedKeys(_dataTemplate));
            _callout = Callout.show(list, event.target as DisplayObject);
        }

        /*private function onAddButton(event:Event):void
         {
         var list:List = new List();
         list.addEventListener(Event.CHANGE, onListSelect);
         list.dataProvider = new ListCollection(getSortedKeys(_dataTemplate));
         _callout = Callout.show(list, event.target as DisplayObject);
         }*/

        private function onListSelect(event:Event):void
        {
            _callout.close();

            var list:List = event.target as List;

            var id:String = list.selectedItem as String;

            _data = dataPush(_dataPushCallbackFunction, id);

            dispatchEventWith(Event.CHANGE, false, ObjectUtil.cloneObject(_data));

            reloadData();
        }

        public function dataPush(func:Function, id:String):String
        {
            if (func is Function)
            {
                return func(id);
            }
            return _dataTemplate[id].toString();
        }

        override protected function draw():void
        {
            _container.validate();

            width = _container.width;
            height = _container.height + 10;
        }

        private function clone(object:Object):Object
        {
            return JSON.parse(JSON.stringify(object));
        }

        public function set dataTemplate(value:Object):void
        {
            _dataTemplate = clone(value);
        }

        public function get externalIndex():String
        {
            return _externalIndex;
        }

        public function set externalIndex(value:String):void
        {
            _externalIndex = value;
        }

    }
}
