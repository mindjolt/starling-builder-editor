/**
 * Created by hyh on 8/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;

    public class GroupTest extends AbstractTest
    {
        public function GroupTest()
        {
        }

        private static function validateGroup():void
        {
            var parent:DisplayObjectContainer = documentManager.root.getChildAt(1) as DisplayObjectContainer;

            assertTrue(parent is Sprite);

            assertEquals(parent.getChildAt(0).name, "obj1");
            assertEquals(parent.getChildAt(1).name, "obj2");
            assertEquals(parent.getChildAt(2).name, "obj3");

            assertEquals(parent.parent.getChildIndex(parent), 1);
        }

        private static function validateUngroup():void
        {
            var root:DisplayObjectContainer = documentManager.root;

            root.getChildAt(0).name = "obj0";
            root.getChildAt(1).name = "obj1";
            root.getChildAt(2).name = "obj2";
            root.getChildAt(3).name = "obj3";
            root.getChildAt(4).name = "obj4";
        }

        public static const GROUP:Array = [

            function():void
            {
                documentManager.clear();
                selectTab("asset");
            },

            function():void
            {
                selectGroupList(0, 0);
                selectedObject.name = "obj0";

                selectGroupList(0, 2);
                selectedObject.name = "obj1";

                selectGroupList(0, 3);
                selectedObject.name = "obj2";

                selectGroupList(0, 4);
                selectedObject.name = "obj3";

                selectGroupList(0, 5);
                selectedObject.name = "obj4";
            },

            function():void
            {
                var indices:Vector.<int> = new Vector.<int>();
                indices.push(3, 2, 4);
                documentManager.selectObjectAtIndices(indices);

                documentManager.group(Sprite);

                validateGroup();
            },

            function():void
            {
                undo();
                validateUngroup();
            },

            function():void
            {
                redo();
                validateGroup();
            },

            function():void
            {
                documentManager.selectObjectAtIndex(2);
                documentManager.ungroup();

                validateUngroup();
            },

            function():void
            {
                undo();
                validateGroup();
            },

            function():void
            {
                redo();
                validateUngroup();
            }
        ];
    }
}
