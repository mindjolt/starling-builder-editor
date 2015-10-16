/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.Slider;

    import starling.events.Event;

    public class SliderPropertyComponent extends BasePropertyComponent
    {
        private var _slider:Slider;

        public function SliderPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            var name:String = param.name;

            var min:Number = param["min"];
            var max:Number = param["max"];
            var default_value:Number = param["default"];
            var step:Number = param["step"];
            var component:String = param["component"];

            if (!isNaN(min) && !isNaN(max))
            {
                _slider = new Slider();
                _slider.addEventListener(Event.CHANGE, function(event):void{
                    _oldValue = _propertyRetriever.get(name);
                    _propertyRetriever.set(name, _slider.value);
                    setChanged();
                });
                _slider.minimum = min;
                _slider.maximum = max;
                _slider.value = Number(_propertyRetriever.get(name));

                addChild(_slider);
                if (!isNaN(step))
                    _slider.step = step;
            }
            else
            {
                throw new Error("Min and Max have to be defined!")
            }
        }

        override public function update():void
        {
            //Setting to NaN on slider will always dispatch a change, we need to do this workaround
            var value:Number = Number(_propertyRetriever.get(_param.name));

            if (!isNaN(value))
            {
                _slider.value = value;
            }
        }
    }
}
