/**
 * Created by hyh on 8/11/15.
 */
package starlingbuilder.util.ui.inspector
{
    public class TextInputPropertyComponentShort extends TextInputPropertyComponent
    {
        public function TextInputPropertyComponentShort(propertyRetriever:IPropertyRetriever, param:Object, customParam:Object = null, setting:Object = null)
        {
            super(propertyRetriever, param, customParam, setting);

            _textInput.width = 50;
            applySetting(_textInput, UIPropertyComponentFactory.TEXT_INPUT_SHORT);
        }
    }
}
