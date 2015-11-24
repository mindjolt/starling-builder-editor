/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;

    import starling.events.Event;

    public class PickerListPropertyComponent extends BasePropertyComponent
    {
        protected var _pickerList:PickerList;

        public function PickerListPropertyComponent()
        {
            _pickerList = new PickerList();
            addChild(_pickerList);
        }

        private function onPickerList(event:Event):void
        {
            if (_pickerList.selectedItem)
            {
                _oldValue = _propertyRetriever.get(_param.name);
                _propertyRetriever.set(_param.name, _pickerList.selectedItem);

                setChanged();
            }
        }

        override public function update():void
        {
            _pickerList.selectedItem = getValue();
        }

        private function getValue():String
        {
            var obj:Object = _propertyRetriever.get(_param.name);

            if (obj is Boolean)
            {
                return obj ? "true" : "false";
            }
            else
            {
                return String(obj);
            }
        }

        override public function init(args:Array):void
        {
            super.init(args);

            _pickerList.dataProvider = null;
            _pickerList.dataProvider = new ListCollection(_param["options"]);

            update();

            _pickerList.addEventListener(Event.CHANGE, onPickerList);
        }

        override public function recycle():void
        {
            _pickerList.removeEventListener(Event.CHANGE, onPickerList);

            super.recycle();
        }
    }


}
