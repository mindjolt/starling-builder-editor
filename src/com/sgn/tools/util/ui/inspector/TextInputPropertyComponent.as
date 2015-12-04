/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import com.sgn.tools.util.feathers.AutoCompleteWithDropDown;

    import feathers.events.FeathersEventType;

    import starling.events.Event;

    public class TextInputPropertyComponent extends BasePropertyComponent
    {
        protected var _textInput:AutoCompleteWithDropDown;

        public function TextInputPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);

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
        }

        private function onTextInput(event:Event):void
        {
            _oldValue = _propertyRetriever.get(_param.name);
            _propertyRetriever.set(_param.name, _textInput.text);
            setChanged();
        }

        override public function update():void
        {
            _textInput.text = String(_propertyRetriever.get(_param.name));
        }
    }
}
