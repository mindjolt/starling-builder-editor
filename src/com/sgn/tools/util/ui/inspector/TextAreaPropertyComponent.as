/**
 * Created by hyh on 8/14/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.TextArea;
    import feathers.events.FeathersEventType;

    public class TextAreaPropertyComponent extends BasePropertyComponent
    {
        protected var _textArea:TextArea;

        public function TextAreaPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            var name:String = param.name;

            _textArea = new TextArea();
            _textArea.maxWidth = 200;
            _textArea.addEventListener(FeathersEventType.FOCUS_OUT, onTextInput);
            _textArea.addEventListener(FeathersEventType.ENTER, onTextInput);

            if (param.disable)
            {
                _textArea.isEnabled = false;
            }

            function onTextInput(event):void
            {
                try
                {
                    var value:Object = JSON.parse(_textArea.text);
                    _oldValue = _propertyRetriever.get(name);
                    _propertyRetriever.set(name, value);
                    setChanged();
                }
                catch(e:Error)
                {
                    trace("Invalid JSON object!")
                }
            }

            addChild(_textArea);

            update();
        }

        override public function update():void
        {
            var value:Object = _propertyRetriever.get(_param.name);

            if (value is String)
            {
                _textArea.text = String(_propertyRetriever.get(_param.name));
            }
            else
            {
                _textArea.text = JSON.stringify(value);
            }
        }
    }
}
