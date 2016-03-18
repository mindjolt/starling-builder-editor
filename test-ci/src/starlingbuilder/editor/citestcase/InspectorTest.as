/**
 * Created by hyh on 1/18/16.
 */
package starlingbuilder.editor.citestcase
{
    import org.flexunit.asserts.assertEquals;

    import starling.display.DisplayObject;
    import starling.text.TextField;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.assertNumericEquals;

    public class InspectorTest extends AbstractTest
    {
        public function InspectorTest()
        {
        }

        public static const TEST:Array = [
            function():void{
                documentManager.clear();
                selectTab("text");
                selectList(0);
            },

            function():void{
                changeInspectorProperty({name:"textField", x:50, y:50, width:300, height:200, alpha:0.5}, UIEditorScreen.instance.rightPanel);
                var target:TextField = selectedObject as TextField;
                assertNumericEquals(target.x, 50);
                assertNumericEquals(target.y, 50);
                assertNumericEquals(target.width, 300);
                assertNumericEquals(target.height, 200);
                assertNumericEquals(target.alpha, 0.5);
            },

            function():void{
                var target:TextField = selectedObject as TextField;
                changeInspectorProperty({text:"12345"}, UIEditorScreen.instance.rightPanel);
                assertEquals(target.text, "12345");
            },

            function():void{
                var target:TextField = selectedObject as TextField;
                changeInspectorProperty({autoScale:true});
                assertEquals(target.autoScale, true);
            },

            function():void{
                var target:TextField = selectedObject as TextField;
                changeInspectorProperty({autoSize:"bothDirections"});
                assertEquals(target.autoSize, "bothDirections");
            },

            function():void{
                documentManager.clear();
                selectTab("asset");
                selectGroupList(0, 0);

                clickLinkButton();
            },

            function():void{

                var target:DisplayObject = selectedObject;
                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;

                changeInspectorProperty({width:oldWidth * 2});
                assertNumericEquals(target.width, oldWidth * 2);
                assertNumericEquals(target.height, oldHeight * 2);

            },

            function():void{
                clickButton("reset");

                var target:DisplayObject = selectedObject;

                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;

                changeInspectorProperty({height:oldHeight * 2});
                assertNumericEquals(target.width, oldWidth * 2);
                assertNumericEquals(target.height, oldHeight * 2);
            },

            function():void{

                clickLinkButton();
                clickButton("reset");

                var target:DisplayObject = selectedObject;

                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;

                changeInspectorProperty({width:oldWidth * 2});
                assertNumericEquals(target.width, oldWidth * 2);
                assertNumericEquals(target.height, oldHeight);
            }
        ]
    }
}
