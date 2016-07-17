/**
 * Created by hyh on 7/16/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.Check;

    import starlingbuilder.util.feathers.AutoCompleteWithDropDown;

    import feathers.events.FeathersEventType;

    import starling.events.Event;

    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class TextInputPropertyComponent extends BasePropertyComponent
    {
        protected var _textInput:AutoCompleteWithDropDown;

        protected var _check:Check;

        public function TextInputPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object = null)
        {
            super(propertyRetriver, param, customParam);

            layout = FeathersUIUtil.horizontalLayout();

            _textInput = new AutoCompleteWithDropDown();
            addChild(_textInput);

            if (_param.width)
            {
                _textInput.width = _param.width;
            }
            else
            {
                _textInput.width = 200;
            }

            if (_param.disable)
            {
                _textInput.isEnabled = false;
            }
            else
            {
                _textInput.isEnabled = true;
            }

            if (_param.options)
            {
                _textInput.autoCompleteSource = _param.options;
            }
            else
            {
                _textInput.autoCompleteSource = [];
            }

            update();

            _textInput.addEventListener(FeathersEventType.FOCUS_OUT, onTextInput);
            _textInput.addEventListener(FeathersEventType.ENTER, onTextInput);
            _textInput.addEventListener(Event.CLOSE, onTextInput);

            if (_param.explicitField)
            {
                _check = new Check();
                _check.label = "explicit";
                _check.addEventListener(Event.CHANGE, onCheck);
                addChild(_check);
            }
        }

        private function onTextInput(event:Event):void
        {
            changeValue(_textInput.text);
        }

        private function changeValue(value:Object):void
        {
            _oldValue = _propertyRetriever.get(_param.name);
            _propertyRetriever.set(_param.name, value);
            setChanged();
        }

        override public function update():void
        {
            _textInput.text = String(_propertyRetriever.get(_param.name));

            if (_check)
            {
                _textInput.isEnabled = _check.isSelected = _propertyRetriever.get(_param.explicitField);
            }
        }

        private function onCheck(event:Event):void
        {
            _textInput.isEnabled = _check.isSelected;

            if (_textInput.isEnabled)
            {
                changeValue(_textInput.text);
            }
            else
            {
                changeValue(NaN);
            }
        }
    }
}
