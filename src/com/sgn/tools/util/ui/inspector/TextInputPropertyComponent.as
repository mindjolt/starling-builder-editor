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

        public function TextInputPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            var name:String = param.name;

            _textInput = new AutoCompleteWithDropDown();
            update();
            _textInput.addEventListener(FeathersEventType.FOCUS_OUT, onTextInput);
            _textInput.addEventListener(FeathersEventType.ENTER, onTextInput);
            _textInput.addEventListener(Event.CLOSE, onTextInput);

            if (param.width)
            {
                _textInput.width = param.width;
            }

            if (param.disable)
            {
                _textInput.isEnabled = false;
            }

            if (param.options)
            {
                _textInput.autoCompleteSource = param.options;
            }

            function onTextInput(event):void
            {
                _oldValue = _propertyRetriever.get(name);
                _propertyRetriever.set(name, _textInput.text);
                setChanged();
            }

            addChild(_textInput);
        }

        override public function update():void
        {
            _textInput.text = String(_propertyRetriever.get(_param.name));
        }




    }
}
