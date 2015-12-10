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

    import flash.utils.setTimeout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class DataGrid extends ScrollContainer
    {
        private static const MIN_INPUT_WIDTH:int = 75;

        private var _data:Array = [];

        private var _container:ScrollContainer;

        private var _gridLayout:MultiColumnGridLayout;

        private var _callout:Callout;

        private var _editable:Boolean = true;

        private var _dataTemplate:Object = {"default": {"default": 0}};

        private var _autoCompleteTemplate:Object = {};

        public function DataGrid()
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

                var item:Object = _data[rowIndex];
                var keys:Array = getSortedKeys(_data);
                var key:String = keys[columnIndex] as String;

                var text:String = textInput.text;

                if (text == "")
                {
                    if (item is String)
                    {
                        item = text;
                    }
                    else
                    {
                        delete item[key];
                    }
                }
                else
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

                    if (item is String)
                    {
                        item = target;
                    }
                    else
                    {
                        item[key] = target;
                    }
                }
            }

            //avoid a weird timing issue with AutoComplete
            setTimeout(function():void{reloadData()}, 1);
        }

        public function get data():Array
        {
            return clone(_data) as Array;
        }

        public function set data(value:Array):void
        {
            _data = clone(value) as Array;

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
                obj.removeEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
            }

            _container.removeChildren(0, -1, true);

            if (_data == null) return;

            var listLabels:Array = getSortedKeys(_data);


            if (_editable)
            {
                _gridLayout.columnCount = listLabels.length + 1;
            }
            else
            {
                _gridLayout.columnCount = listLabels.length;
            }

            _container.width = MIN_INPUT_WIDTH * _gridLayout.columnCount;

            var j:int;

            var input:AutoCompleteWithDropDown;

            var button:Button;

            if (_editable)
            {
                button = new Button;
                button.label = "+";
                button.addEventListener(Event.TRIGGERED, onAddButton);
                _container.addChild(button);
            }

            for (j = 0; j < listLabels.length; j++)
            {
                var label:Label = new Label();

                if (listLabels[j] != undefined)
                    label.text = listLabels[j].toString();

                var container:ScrollContainer = new ScrollContainer();
                container.addChild(label);

                _container.addChild(container);
            }

            for (i = 0; i < _data.length; i++)
            {
                if (_editable)
                {
                    button = new Button;
                    button.label = "-";
                    button.addEventListener(Event.TRIGGERED, onRemoveButton);
                    _container.addChild(button);
                }

                for (j = 0; j < listLabels.length; j++)
                {
                    input = new AutoCompleteWithDropDown();
                    if (_autoCompleteTemplate[listLabels[j]])
                    {
                        input.autoCompleteSource = _autoCompleteTemplate[listLabels[j]];
                    }

                    var item:Object = _data[i];

                    if (item is String) input.text = item as String;
                    else if (item[listLabels[j]] != undefined)
                    {
                        if (item[listLabels[j]] is String)
                            input.text = item[listLabels[j]].toString();
                        else
                            input.text = JSON.stringify(item[listLabels[j]]);
                    }

                    input.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);

                    input.isEnabled = _editable;

                    _container.addChild(input);
                }
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

            _data.push(clone(_dataTemplate[id]));

            reloadData();
        }


        private function onRemoveButton(event:Event):void
        {
            var displayObject:DisplayObject = event.target as DisplayObject;

            var index:int = _container.getChildIndex(displayObject);

            var rowIndex:int = index / _gridLayout.columnCount - 1;

            _data.splice(rowIndex, 1);

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

        public function set autoCompleteTemplate(value:Object):void
        {
            _autoCompleteTemplate = value;
        }
    }
}
