/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.feathers
{
    import starlingbuilder.util.ObjectUtil;

    import feathers.controls.Button;
    import feathers.controls.Callout;
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.ScrollContainer;
    import feathers.controls.TextInput;
    import feathers.data.ListCollection;
    import feathers.events.FeathersEventType;
    import feathers.layout.MultiColumnGridLayout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class KeyValueDataGrid extends ScrollContainer
    {
        private static const MIN_INPUT_WIDTH:int = 100;

        private var _data:Object = {};

        private var _container:ScrollContainer;

        private var _gridLayout:MultiColumnGridLayout;

        private var _callout:Callout;

        private var _editable:Boolean = true;

        private var _dataTemplate:Object = {"default": 0};


        public function KeyValueDataGrid()
        {
            super();

            init();
        }

        private function init():void
        {
            _container = new ScrollContainer();

            _gridLayout = new MultiColumnGridLayout();
            _container.layout = _gridLayout;

            //_container.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);

            addChild(_container);

            reloadData();
        }

        private function onFocusOut(event:Event):void
        {
            if (!_editable) return;

            var textInput:TextInput = event.target as TextInput;

            if (textInput)
            {
                var index:int = _container.getChildIndex(textInput);

                var rowIndex:int = index / _gridLayout.columnCount - 1;
                var columnIndex:int;
                if (_editable)
                    columnIndex = index % _gridLayout.columnCount - 1;
                else
                    columnIndex = index % _gridLayout._columnCount;

                var keys:Array = getSortedKeys(_data);

                var oldKey:String = keys[rowIndex];
                var newKey:String = textInput.text;

                if (columnIndex == 0) //change key
                {
                    var value:Object = _data[oldKey];
                    delete _data[oldKey];
                    _data[newKey] = value;

                }
                else //change value
                {
                    _data[oldKey] = convertFromText(textInput.text);
                }
            }

            reloadData();
        }

        public function get data():Object
        {
            return clone(_data) as Object;
        }

        public function set data(value:Object):void
        {
            _data = clone(value) as Object;

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
            for (var i:int = 0; i < _container.numChildren; ++i)
            {
                var obj:DisplayObject = _container.getChildAt(i);
                obj.removeEventListeners(FeathersEventType.FOCUS_OUT);
            }

            _container.removeChildren(0, -1, true);

            if (_data == null) return;

            var listLabels:Array = getSortedKeys(_data);

            if (_editable)
            {
                _gridLayout.columnCount = 2 + 1;
            }
            else
            {
                _gridLayout.columnCount = 2
            }

            _container.width = MIN_INPUT_WIDTH * _gridLayout.columnCount;

            var i:int;

            var input:TextInput;

            var button:Button;

            if (_editable)
            {
                button = new Button;
                button.label = "+";
                button.addEventListener(Event.TRIGGERED, onAddButton);
                _container.addChild(button);
            }

            var label:Label = new Label();
            label.text = "key";
            var container:ScrollContainer = new ScrollContainer();
            container.addChild(label);
            _container.addChild(container);

            label = new Label();
            label.text = "value";
            container = new ScrollContainer();
            container.addChild(label);
            _container.addChild(container);


            for (i = 0; i < listLabels.length; i++)
            {
                if (_editable)
                {
                    button = new Button;
                    button.label = "-";
                    button.addEventListener(Event.TRIGGERED, onRemoveButton);
                    _container.addChild(button);
                }

                //key
                input = new TextInput();
                var key:String = listLabels[i];
                input.text = key;
                input.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
                input.isEnabled = _editable;
                _container.addChild(input);


                //value
                input = new TextInput();

                var item:Object = _data[key];

                if (item is String) input.text = item as String;
                else if (item != undefined)
                {
                    input.text = JSON.stringify(item);
                }

                input.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);

                input.isEnabled = _editable;

                _container.addChild(input);


            }

            invalidate();
        }

        private function onAddButton(event:Event):void
        {
            var list:List = new List();
            list.addEventListener(Event.CHANGE, onListSelect);
            list.dataProvider = new ListCollection(getSortedKeys(_dataTemplate));
            _callout = Callout.show(list, event.target as DisplayObject);
        }

        private function onListSelect(event:Event):void
        {
            _callout.close();

            var list:List = event.target as List;

            var id:String = list.selectedItem as String;

            _data[id] = _dataTemplate[id];

            reloadData();
        }


        private function onRemoveButton(event:Event):void
        {
            var displayObject:DisplayObject = event.target as DisplayObject;

            var index:int = _container.getChildIndex(displayObject);

            var keys:Array = getSortedKeys(_data);

            var rowIndex:int = index / _gridLayout.columnCount - 1;

            delete _data[keys[rowIndex]];

            //_data.splice(rowIndex, 1);
            //remove the current key

            reloadData();
        }

        override protected function draw():void
        {
            _container.validate();

            width = _container.width;
            height = _container.height + 10;
        }


        public function get editable():Boolean
        {
            return _editable;
        }

        public function set editable(value:Boolean):void
        {
            _editable = value;

            reloadData();
        }

        private function clone(object:Object):Object
        {
            return JSON.parse(JSON.stringify(object));
        }

        public function set dataTemplate(value:Object):void
        {
            _dataTemplate = clone(value);
        }

        private function convertFromText(text:String):Object
        {

            var target:Object;

            if (isNaN(Number(text)))
            {
                if (ObjectUtil.validJSON(text))
                {
                    target = JSON.parse(text);
                }
                else
                    target = text;
            }
            else
                target = Number(text);

            return target;

        }
    }
}
