/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import starling.events.Event;

    public class ColorPickerPropertyComponent extends BasePropertyComponent
    {
        protected var _colorPicker:ColorPicker;

        public function ColorPickerPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);

            _colorPicker = new ColorPicker();
            addChild(_colorPicker);

            update();
            _colorPicker.addEventListener(Event.CHANGE, onColorPick);
        }

        private function onColorPick(event:Event):void
        {
            _oldValue = _propertyRetriever.get(_param.name);
            _propertyRetriever.set(_param.name, _colorPicker.value);
            setChanged();
        }


        override public function update():void
        {
            _colorPicker.value = uint(_propertyRetriever.get(_param.name));
        }
    }
}
