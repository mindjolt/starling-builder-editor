/**
 * Created by hyh on 2/22/16.
 */
package starlingbuilder.editor.citestcase
{
    import flash.ui.Keyboard;

    import org.flexunit.asserts.assertEquals;

    import starling.display.Image;
    import starling.events.KeyboardEvent;

    import starlingbuilder.editor.citestutil.assertNumericEquals;

    import starlingbuilder.editor.citestutil.simulateTouch;

    public class SelectionTest extends AbstractTest
    {
        public function SelectionTest()
        {
            super();
        }

        public static const IMAGE1:String = "image1";
        public static const IMAGE2:String = "image2";
        public static const IMAGE3:String = "image3";

        public static var image1:Image;
        public static var image2:Image;
        public static var image3:Image;

        public static var image1X:Number;
        public static var image1Y:Number;
        public static var image2X:Number;
        public static var image2Y:Number;
        public static var image3X:Number;
        public static var image3Y:Number;

        public static function save():void
        {
            image1X = image1.x;
            image1Y = image1.y;
            image2X = image2.x;
            image2Y = image2.y;
            image3X = image3.x;
            image3Y = image3.y;
        }

        public static const SELECTION:Array = [
                function():void{
                    documentManager.clear();
                    selectTab("asset");
                },

                function():void{
                    selectGroupList(0, 0);
                    selectGroupList(0, 2);
                    selectGroupList(0, 3);

                    image1 = documentManager.root.getChildAt(0) as Image;
                    image2 = documentManager.root.getChildAt(1) as Image;
                    image3 = documentManager.root.getChildAt(2) as Image;

                    image1.x = 0;
                    image1.y = 0;
                    image2.x = 200;
                    image2.y = 100;
                    image3.x = 400;
                    image3.y = 200;
                    image1.name = IMAGE1;
                    image2.name = IMAGE2;
                    image3.name = IMAGE3;

                    documentManager.setChanged();
                },

                //select 3 items
                function():void{

                    simulateTouch(image1);

                    stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.CONTROL));
                    simulateTouch(image2);
                    simulateTouch(image3);
                    stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.CONTROL));

                    assertEquals(documentManager.selectedObject, null);
                    assertEquals(documentManager.selectedObjects.length, 3);
                },

                //deselect 1 item
                function():void{
                    stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.CONTROL));
                    simulateTouch(image3, 20, 20);
                    stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.CONTROL));

                    assertEquals(documentManager.selectedObject, null);
                    assertEquals(documentManager.selectedObjects.length, 2);
                },

            //reselect 1 item
            function():void{
                stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.CONTROL, 0, true));
                simulateTouch(image3, 20, 20);
                stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.CONTROL));

                assertEquals(documentManager.selectedObject, null);
                assertEquals(documentManager.selectedObjects.length, 3);
            },

            //move
            function():void{
                var dx:Number = 50;
                var dy:Number = 60;
                save();
                simulateTouch(image1, 20, 20, dx, dy);

                assertNumericEquals(image1.x, image1X + dx);
                assertNumericEquals(image1.y, image1Y + dy);
                assertNumericEquals(image2.x, image2X + dx);
                assertNumericEquals(image2.y, image2Y + dy);
                assertNumericEquals(image3.x, image3X + dx);
                assertNumericEquals(image3.y, image3Y + dy);
            },

            function():void{
                undo();

                assertNumericEquals(image1.x, image1X);
                assertNumericEquals(image1.y, image1Y);
                assertNumericEquals(image2.x, image2X);
                assertNumericEquals(image2.y, image2Y);
                assertNumericEquals(image3.x, image3X);
                assertNumericEquals(image3.y, image3Y);
            },

            function():void{
                image1.rotation = 0.5;
                image2.rotation = 1;
                image3.rotation = 1.5;

                clickButton("reset");

                assertNumericEquals(image1.rotation, 0);
                assertNumericEquals(image2.rotation, 0);
                assertNumericEquals(image3.rotation, 0);
            },

            function():void{
                undo();

                assertNumericEquals(image1.rotation, 0.5);
                assertNumericEquals(image2.rotation, 1);
                assertNumericEquals(image3.rotation, 1.5);

                redo();
            },

            function():void{
                clickButton("set pivot to");

                assertNumericEquals(image1.pivotX, image1.width / 2);
                assertNumericEquals(image1.pivotY, image1.height / 2);
                assertNumericEquals(image2.pivotX, image2.width / 2);
                assertNumericEquals(image2.pivotY, image2.height / 2);
                assertNumericEquals(image3.pivotX, image3.width / 2);
                assertNumericEquals(image3.pivotY, image3.height / 2);
            },

            function():void{
                undo();

                assertNumericEquals(image1.pivotX, 0);
                assertNumericEquals(image1.pivotY, 0);
                assertNumericEquals(image2.pivotX, 0);
                assertNumericEquals(image2.pivotY, 0);
                assertNumericEquals(image3.pivotX, 0);
                assertNumericEquals(image3.pivotY, 0);
            },

            function():void{
                clickButtonWithName("align left");

                assertNumericEquals(image1.x, image2.x);
                assertNumericEquals(image1.x, image3.x);
            },

            function():void{
                undo();
                clickButtonWithName("align center");

                assertNumericEquals(image1.x + image1.width / 2, image2.x + image2.width / 2);
                assertNumericEquals(image1.x + image1.width / 2, image3.x + image3.width / 2);
            },

            function():void{
                undo();
                clickButtonWithName("align right");

                assertNumericEquals(image1.x + image1.width, image2.x + image2.width);
                assertNumericEquals(image1.x + image1.width, image3.x + image3.width);
            },

            function():void{
                undo();
                clickButtonWithName("align top");

                assertNumericEquals(image1.y, image2.y);
                assertNumericEquals(image1.y, image3.y);
            },

            function():void{
                undo();
                clickButtonWithName("align middle");

                assertNumericEquals(image1.y + image1.height / 2, image2.y + image2.height / 2);
                assertNumericEquals(image1.y + image1.height / 2, image3.y + image3.height / 2);
            },

            function():void{
                undo();
                clickButtonWithName("align bottom");

                assertNumericEquals(image1.y + image1.height, image2.y + image2.height);
                assertNumericEquals(image1.y + image1.height, image3.y + image3.height);
            },

            function():void{
                undo();
                clickButtonWithName("align width");

                assertNumericEquals(image1.width, image2.width);
                assertNumericEquals(image1.width, image3.width);
            },

            function():void{
                undo();
                clickButtonWithName("align height");

                assertNumericEquals(image1.height, image2.height);
                assertNumericEquals(image1.height, image3.height);
            },

            function():void{
                undo();
                clickButtonWithName("align horizontal");
                clickButton("OK");

                assertNumericEquals(image1.x + image1.width, image2.x);
                assertNumericEquals(image2.x + image2.width, image3.x);
            },

            function():void{
                undo();
                clickButtonWithName("align vertical");
                clickButton("OK");

                assertNumericEquals(image1.y + image1.height, image2.y);
                assertNumericEquals(image2.y + image2.height, image3.y);
            }
        ]
    }
}
