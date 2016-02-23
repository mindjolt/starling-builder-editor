/**
 * Created by hyh on 1/6/16.
 */
package starlingbuilder.util.ui.inspector
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.ui.Mouse;
    import flash.ui.MouseCursorData;

    public class CursorRegister
    {
        [Embed(source="horizontal_arrow.png")]
        private static const HORIZONTAL_ARROW_BITMAP:Class;

        [Embed(source="vertical_arrow.png")]
        private static const VERTICAL_ARROW_BITMAP:Class;

        public static const HORIZONTAL_ARROW:String = "horizontalArrow";
        public static const VERTICAL_ARROW:String = "verticalArrow";

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
            data.hotSpot = new Point(image.width / 2, image.height / 2);
            Mouse.registerCursor(HORIZONTAL_ARROW, data);

            image = new VERTICAL_ARROW_BITMAP();
            data = new MouseCursorData();
            data.data = new <BitmapData>[image.bitmapData];
            data.hotSpot = new Point(image.width / 2, image.height / 2);
            Mouse.registerCursor(VERTICAL_ARROW, data);
        }
    }
}
