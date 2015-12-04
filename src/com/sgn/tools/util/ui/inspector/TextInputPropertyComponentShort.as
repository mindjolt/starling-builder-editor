/**
 * Created by hyh on 8/11/15.
 */
package com.sgn.tools.util.ui.inspector
{
    public class TextInputPropertyComponentShort extends TextInputPropertyComponent
    {
        public function TextInputPropertyComponentShort(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);

            _textInput.width = 50;
        }
    }
}
