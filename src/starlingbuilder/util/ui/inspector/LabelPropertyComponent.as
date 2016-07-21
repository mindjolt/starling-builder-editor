/**
 * Created by hyh on 1/6/16.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.Label;

    import flash.ui.Mouse;
    import flash.ui.MouseCursor;

    import starling.events.Touch;

    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class LabelPropertyComponent extends BasePropertyComponent
    {
        public static const DEFAULT_LABEL_WIDTH:int = 55;

        private var _label:Label;
        protected var _step:Number;
        private var _min:Number;
        private var _max:Number;

        private var _isNumeric:Boolean;

        public function LabelPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object, customParam:Object = null, setting:Object = null)
        {
            CursorRegister.init();

            super(propertyRetriever, param, customParam, setting);

            _label = FeathersUIUtil.labelWithText(_param.label ? _param.label : _param.name);
            _label.width = DEFAULT_LABEL_WIDTH;

            applySetting(_label, UIPropertyComponentFactory.LABEL);

            _label.wordWrap = true;
            _label.addEventListener(TouchEvent.TOUCH, onTouch);
            addChild(_label);

            _step = _param.hasOwnProperty("step") ? _param.step : 1;
            _min = _param.hasOwnProperty("min") ? _param.min : NaN;
            _max = _param.hasOwnProperty("max") ? _param.max : NaN;

            _isNumeric = (_propertyRetriever.get(_param.name) is Number);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this);
            if (touch)
            {
                switch (touch.phase)
                {
                    case TouchPhase.MOVED:
                        var delta:Number = 0;

                        delta += Math.round(touch.globalY - touch.previousGlobalY);
                        delta += Math.round(touch.globalX - touch.previousGlobalX);

                        var value:Object = _propertyRetriever.get(_param.name);

                        if (value is Number)
                        {
                            var number:Number = Number(value);

                            _oldValue = number;

                            if (isNaN(Number(number))) number = 0;

                            number += delta * _step;

                            if (!isNaN(_min)) number = Math.max(number, _min);
                            if (!isNaN(_max)) number = Math.min(number, _max);

                            _propertyRetriever.set(_param.name, number);
                            setChanged();
                        }
                    case TouchPhase.HOVER:
                        if (_isNumeric)
                        {
                            Mouse.cursor = CursorRegister.HORIZONTAL_ARROW;
                        }
                        break;
                    case TouchPhase.ENDED:
                        Mouse.cursor = MouseCursor.AUTO;
                        break;
                }
            }
            else
            {
                Mouse.cursor = MouseCursor.AUTO;
            }
        }

        override public function dispose():void
        {
            _label.removeEventListener(TouchEvent.TOUCH, onTouch);
            super.dispose();
        }
    }
}
