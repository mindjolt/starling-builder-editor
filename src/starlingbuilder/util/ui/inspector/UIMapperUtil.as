/**
 * Created by hyh on 12/3/15.
 */
package starlingbuilder.util.ui.inspector
{
    public class UIMapperUtil
    {
        public static function processParamsWithFonts(params:Array, fonts:Array):void
        {
            for each (var item:Object in params)
            {
                if ((item.component == PropertyComponentType.TEXT_INPUT || item.component == PropertyComponentType.PICKER_LIST) && item.name == "fontName")
                {
                    item.options = fonts;
                }
            }
        }

        public static function processParamsWithWidthAndHeight(params:Array):void
        {
            var i:int;

            var array:Array;
            var param:Object;

            for (i = 0; i < params.length; ++i)
            {
                param = params[i];

                if (param.name == "width")
                {
                    array = [param];
                    params.splice(i, 1, array);
                }
            }

            for (i = 0; i < params.length; ++i)
            {
                param = params[i];

                if (param.name == "height")
                {
                    params.splice(i, 1);
                    array.push(param);
                }
            }
        }
    }
}
