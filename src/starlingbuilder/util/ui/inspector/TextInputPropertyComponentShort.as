/**
 * Created by hyh on 8/11/15.
 */
package starlingbuilder.util.ui.inspector
{
    public class TextInputPropertyComponentShort extends TextInputPropertyComponent
    {
        public function TextInputPropertyComponentShort(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object = null)
        {
            super(propertyRetriver, param, customParam);

            _textInput.width = 50;
        }
    }
}
