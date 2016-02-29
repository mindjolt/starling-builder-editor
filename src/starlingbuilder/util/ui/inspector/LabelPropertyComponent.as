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
        private var _label:Label;
        protected var _step:Number;
        private var _min:Number;
        private var _max:Number;

        private var _isNumeric:Boolean;

        public static const DEFAULT_VERTICAL_ARROW_FIELDS:Array = ["y", "height"];

        public function LabelPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, labelWidth:Number)
        {
            CursorRegister.init();

            super(propertyRetriver, param);

            _label = FeathersUIUtil.labelWithText(_param.label ? _param.label : _param.name);
            _label.width = labelWidth;
            _label.wordWrap = true;
            _label.addEventListener(TouchEvent.TOUCH, onTouch);
            addChild(_label);

            _step = _param.hasOwnProperty("step") ? _param.step : 1;
            _min = _param.hasOwnProperty("min") ? _param.min : NaN;
            _max = _param.hasOwnProperty("max") ? _param.max : NaN;

            _isNumeric = (_propertyRetriever.get(_param.name) is Number);
        }

        private function useVerticalArrow():Boolean
        {
            if ("vertical_arrow" in _param)
                return _param.vertical_arrow;
            else
                return DEFAULT_VERTICAL_ARROW_FIELDS.indexOf(_param.name) >= 0;
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this);
            if (touch)
            {
                switch (touch.phase)
                {
                    case TouchPhase.MOVED:
                        var delta:Number;

                        if (useVerticalArrow())
                            delta = Math.round(touch.globalY - touch.previousGlobalY);
                        else
                            delta = Math.round(touch.globalX - touch.previousGlobalX);

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
                            if (useVerticalArrow())
                                Mouse.cursor = CursorRegister.VERTICAL_ARROW;
                            else
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
