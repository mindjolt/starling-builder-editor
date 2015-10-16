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

        public function PickerListPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            var name:String = param.name;

            var options:Array = param["options"];
            var default_value:Number = param["default"];
            var component:String = param["component"];

            _pickerList = new PickerList();
            _pickerList.dataProvider = new ListCollection(options);

//                if (!isNaN(default_value))
//                {
//                    _propertyRetriever.set(name, default_value);
//                }

            _pickerList.addEventListener(Event.CHANGE, function(event):void{

                if (_pickerList.selectedItem)
                {
                    _oldValue = _propertyRetriever.get(name);
                    _propertyRetriever.set(name, _pickerList.selectedItem);

                    setChanged();
                }

            });

            _pickerList.selectedItem = getValue();

            addChild(_pickerList);
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
    }


}
