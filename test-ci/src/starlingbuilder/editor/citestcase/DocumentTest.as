/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import feathers.controls.List;

    import org.flexunit.asserts.assertEquals;

    import starling.display.DisplayObject;

    import starling.display.Image;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.findDisplayObject;

    public class DocumentTest extends AbstractTest
    {
        public function DocumentTest()
        {
        }

        public static const OPERATIONS:Array = [

            //create
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);
            },

            //cut
            function():void{
                selectTab("layout");
                clickButton("cut");
                assertEquals(documentManager.root.numChildren, 0);
            },

            //paste
            function():void{
                clickButton("paste");
                assertEquals(documentManager.root.numChildren, 1);
            },

            //copy
            function():void{
                clickButton("copy");
                assertEquals(documentManager.root.numChildren, 1);
            },

            //paste
            function():void{
                clickButton("paste");
                assertEquals(documentManager.root.numChildren, 2);
                changeInspectorProperty({name:"new_image"}, UIEditorScreen.instance.rightPanel);
            },

            //move up
            function():void{
                var target:DisplayObject = selectedObject;
                assertEquals(target.parent.getChildIndex(target), 1);
                clickButton("up");
                assertEquals(target.parent.getChildIndex(target), 0);
                clickButton("up");
                assertEquals(target.parent.getChildIndex(target), 0);
            },

            //go down
            function():void{
                var target:DisplayObject = selectedObject;
                clickButton("down");
                assertEquals(target.parent.getChildIndex(target), 1);
                clickButton("down");
                assertEquals(target.parent.getChildIndex(target), 1);
            },

            //collapse all
            function():void{
                clickButton("collapse all");
                var list:List = findDisplayObject({cls:List}) as List;
                assertEquals(list.dataProvider.length, 1);
            },

            //expand all
            function():void{
                clickButton("expand all");
                var list:List = findDisplayObject({cls:List}) as List;
                assertEquals(list.dataProvider.length, 3);
            },

            //duplicate
            function():void{
                clickButton("duplicate");
                assertEquals(documentManager.root.numChildren, 3);
            },

            function():void{
                clickButton("delete");
                assertEquals(documentManager.root.numChildren, 2);
            }
        ]
    }
}
