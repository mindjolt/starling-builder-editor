/**
 * Created by hyh on 1/6/16.
 */
package starlingbuilder.util.ui.inspector
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.ui.Mouse;
    import flash.ui.MouseCursorData;

    public class CursorRegister
    {
        [Embed(source="horizontal_arrow.png")]
        private static const HORIZONTAL_ARROW_BITMAP:Class;

        public static const HORIZONTAL_ARROW:String = "horizontalArrow";

        private static var _init:Boolean = false;

        public static function init():void
        {
            if (!_init)
            {
                _init = true;
                registerCursor()
            }
        }

        private static function registerCursor():void
        {
            var image:Bitmap = new HORIZONTAL_ARROW_BITMAP();
            var data:MouseCursorData = new MouseCursorData();
            data.data = new <BitmapData>[image.bitmapData];
            Mouse.registerCursor(HORIZONTAL_ARROW, data);
        }
    }
}
