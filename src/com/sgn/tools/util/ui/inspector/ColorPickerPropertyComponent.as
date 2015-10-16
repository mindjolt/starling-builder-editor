/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import starling.events.Event;

    public class ColorPickerPropertyComponent extends BasePropertyComponent
    {
        protected var _colorPicker:ColorPicker;

        public function ColorPickerPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            var name:String = param.name;

            _colorPicker = new ColorPicker();

            _colorPicker.value = uint(_propertyRetriever.get(name));
            _colorPicker.addEventListener(Event.CHANGE, onColorPick);

            function onColorPick(event:Event):void
            {
                _oldValue = _propertyRetriever.get(name);
                _propertyRetriever.set(name, _colorPicker.value);
                setChanged();
            }

            addChild(_colorPicker);
        }

        override public function update():void
        {
            _colorPicker.value = uint(_propertyRetriever.get(_param.name));
        }
    }
}
