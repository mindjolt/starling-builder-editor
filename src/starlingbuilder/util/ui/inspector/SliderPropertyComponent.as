/**
 * Created by hyh on 7/16/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.Slider;

    import starling.events.Event;

    public class SliderPropertyComponent extends BasePropertyComponent
    {
        private var _slider:Slider;

        public function SliderPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object)
        {
            super(propertyRetriver, param, customParam);

            _slider = new Slider();
            addChild(_slider);

            var min:Number = param["min"];
            var max:Number = param["max"];
            var step:Number = param["step"];

            _slider.minimum = min;
            _slider.maximum = max;

            if (!isNaN(step))
                _slider.step = step;
            else
                _slider.step = 0;

            update();

            _slider.addEventListener(Event.CHANGE, onSliderChange);
        }

        private function onSliderChange(event:Event):void
        {
            _oldValue = _propertyRetriever.get(_param.name);
            _propertyRetriever.set(_param.name, _slider.value);
            setChanged();
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
