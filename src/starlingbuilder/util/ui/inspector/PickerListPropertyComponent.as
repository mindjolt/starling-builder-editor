/**
 * Created by hyh on 7/16/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;

    import starling.events.Event;

    public class PickerListPropertyComponent extends BasePropertyComponent
    {
        protected var _pickerList:PickerList;

        public function PickerListPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object, customParam:Object = null, setting:Object = null)
        {
            super(propertyRetriever, param, customParam, setting);

            _pickerList = new PickerList();
            applySetting(_pickerList, UIPropertyComponentFactory.PICKER_LIST);
            addChild(_pickerList);

            _pickerList.dataProvider = new ListCollection(_param["options"]);
            update();
            _pickerList.addEventListener(Event.CHANGE, onPickerList);
        }

        private function onPickerList(event:Event):void
        {
            if (_pickerList.selectedItem)
            {
                _oldValue = _propertyRetriever.get(_param.name);
                _propertyRetriever.set(_param.name, getPickerListValue());

                setChanged();
            }
        }

        private function getPickerListValue():String
        {
            var item:Object = _pickerList.selectedItem;
            if (item)
            {
                if (item is String)
                    return item as String;
                else
                    return item.value;
            }
            else
            {
                return null;
            }
        }

        override public function update():void
        {
            var value:String = getValue();

            var data:ListCollection = _pickerList.dataProvider;

            for (var i:int = 0; i < data.length; ++i)
            {
                var item:Object = data.getItemAt(i);

                if (item is String)
                {
                    _pickerList.selectedItem = getValue();
                    break;
                }
                else
                {
                    if (item.value == value)
                    {
                        _pickerList.selectedIndex = i;
                        break;
                    }
                }
            }
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
