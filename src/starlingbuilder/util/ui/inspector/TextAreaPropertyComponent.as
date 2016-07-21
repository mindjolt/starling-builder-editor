/**
 * Created by hyh on 8/14/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.TextArea;
    import feathers.events.FeathersEventType;

    import starling.events.Event;

    import starlingbuilder.engine.format.StableJSONEncoder;

    public class TextAreaPropertyComponent extends BasePropertyComponent
    {
        protected var _textArea:TextArea;

        public function TextAreaPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object, customParam:Object = null, setting:Object = null)
        {
            super(propertyRetriever, param, customParam, setting);

            _textArea = new TextArea();
            _textArea.maxWidth = 400;
			_textArea.minWidth = 300;
            applySetting(_textArea, UIPropertyComponentFactory.TEXT_AREA);

            addChild(_textArea);

            if (param.disable)
            {
                _textArea.isEnabled = false;
            }
            else
            {
                _textArea.isEnabled = true;
            }

            update();

            _textArea.addEventListener(FeathersEventType.FOCUS_OUT, onTextInput);
            _textArea.addEventListener(FeathersEventType.ENTER, onTextInput);
        }

        protected function onTextInput(event:Event):void
        {
            try
            {
                var value:Object = JSON.parse(_textArea.text);
                _oldValue = _propertyRetriever.get(_param.name);
                _propertyRetriever.set(_param.name, value);
                setChanged();
            }
            catch(e:Error)
            {
                throw new Error("Invalid JSON object!");
            }
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
                _textArea.text = StableJSONEncoder.stringify(value);
            }
        }
    }
}
