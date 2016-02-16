/**
 * Created by hyh on 1/31/16.
 */
package starlingbuilder.editor.citestcase
{
    import org.flexunit.asserts.assertTrue;
    import starling.display.DisplayObject;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.assertNumericEquals;

    public class BackgroundTest extends AbstractTest
    {
        public function BackgroundTest()
        {
            super();
        }

        public static const BACKGROUND:Array = [
            function():void {
                documentManager.clear();
                selectTab("bg");
                selectList(0);
                assertTrue(documentManager.background != null);
            },

            function():void{
                changeInspectorProperty({x:20, y:30, width:40, height:50}, UIEditorScreen.instance.leftPanel);
                var target:DisplayObject = documentManager.background;
                assertNumericEquals(target.x, 20);
                assertNumericEquals(target.y, 30);
                assertNumericEquals(target.width, 40);
                assertNumericEquals(target.height, 50);

                clickLinkButton();
                changeInspectorProperty({width:256}, UIEditorScreen.instance.leftPanel);
                assertNumericEquals(target.width, 256);
                assertNumericEquals(target.width, 256);
            },

            function():void{
                clickButton("reset background", UIEditorScreen.instance.leftPanel);
                assertTrue(documentManager.background == null);
            }
        ];
    }
}
