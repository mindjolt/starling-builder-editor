/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import org.flexunit.asserts.assertEquals;

    import starling.display.DisplayObject;

    import starlingbuilder.editor.citestutil.assertNumericEquals;

    public class TweenTest extends AbstractTest
    {
        public function TweenTest()
        {
        }

        public static const tweenData1:Object = {"time":0.001, "properties":{"scaleX":0.5, "scaleY":0.5}};

        public static const tweenData2:Object = [{"time":0.001, "properties":{"scaleX":2, "scaleY":2}},{"time":0.002, "properties":{"alpha":0.5}}];

        public static const TWEEN:Array = [
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectGroupList(0, 0);
            },

            function():void{
                selectTab("tween");
                changeInspectorProperty({tweenData:JSON.stringify(tweenData1)});
            },

            function():void{
                clickButton("start");
            },

            function():void{
                var target:DisplayObject = selectedObject;
                assertNumericEquals(target.scaleX, 0.5);
                assertNumericEquals(target.scaleY, 0.5);

                selectTab("tween");
                changeInspectorProperty({tweenData:JSON.stringify(tweenData2)});
            },

            function():void{
                clickButton("start");
            },

            function():void{

                var target:DisplayObject = selectedObject;
                assertNumericEquals(target.scaleX, 2);
                assertNumericEquals(target.scaleY, 2);
                assertNumericEquals(target.alpha, 0.5);

                clickButton("stop");
                assertNumericEquals(target.scaleX, 1);
                assertNumericEquals(target.scaleY, 1);
                assertNumericEquals(target.alpha, 1);

                selectTab("properties");
            }
        ]


    }
}
