/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import starling.events.Event;

    public class ColorPickerPropertyComponent extends BasePropertyComponent
    {
        protected var _colorPicker:ColorPicker;

        public function ColorPickerPropertyComponent()
        {
            _colorPicker = new ColorPicker();
            addChild(_colorPicker);
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

        override public function init(args:Array):void
        {
            super.init(args);

            update();

            _colorPicker.addEventListener(Event.CHANGE, onColorPick);
        }

        override public function recycle():void
        {
            _colorPicker.removeEventListener(Event.CHANGE, onColorPick);

            super.recycle();
        }
    }
}
