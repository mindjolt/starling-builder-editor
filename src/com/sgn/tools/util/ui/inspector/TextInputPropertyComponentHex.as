/**
 * Created by hyh on 8/14/15.
 */
package com.sgn.tools.util.ui.inspector
{
    public class TextInputPropertyComponentHex extends TextInputPropertyComponent
    {
        public function TextInputPropertyComponentHex(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);
        }

        override public function update():void
        {
            var obj:Object = _propertyRetriever.get(_param.name);

            obj = int(obj).toString(16);

            _textInput.text = "0x" + String(obj);
        }
    }
}
