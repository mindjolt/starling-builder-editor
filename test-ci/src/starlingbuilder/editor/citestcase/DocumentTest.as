/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;

    import org.flexunit.asserts.assertEquals;

    import starling.display.DisplayObject;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;

    import starling.display.Image;
    import starling.display.Sprite;

    import starlingbuilder.editor.CITestUtil;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.findDisplayObject;
    import starlingbuilder.editor.citestutil.simulateTouch;
    import starlingbuilder.editor.ui.LayoutItemRenderer;
    import starlingbuilder.editor.ui.LayoutItemRenderer;
    import starlingbuilder.editor.ui.LayoutItemRenderer;

    public class DocumentTest extends AbstractTest
    {
        public function DocumentTest()
        {
        }

        public static function getListItemRendererAt(index:int):DisplayObject
        {
            var list:List = findDisplayObject({cls:List}) as List;
            var selected:Object = list.selectedItem;

            return CITestUtil.findDisplayObjectWithCondition(function(obj:DisplayObject):Boolean{
                        if (obj is IListItemRenderer)
                        {
                            var data:Object = IListItemRenderer(obj).data;
                            if (data === selected)
                            {
                                return true;
                            }
                        }

                        return false;
                    }, list);
        }

        public static const OPERATIONS:Array = [

            //create
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);

                //Create Operation
                undo();
                assertEquals(documentManager.root.numChildren, 0);
                redo();
                assertEquals(documentManager.root.numChildren, 1);
            },

            //cut
            function():void{
                selectTab("layout");
                clickButton("cut");
                assertEquals(documentManager.root.numChildren, 0);

                //Cut Operation
                undo();
                assertEquals(documentManager.root.numChildren, 1);
                redo();
                assertEquals(documentManager.root.numChildren, 0);
            },

            //paste
            function():void{
                clickButton("paste");
                assertEquals(documentManager.root.numChildren, 1);

                //Paste Operation
                undo();
                assertEquals(documentManager.root.numChildren, 0);
                redo();
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

                var name:String = documentManager.selectedObject.name;
                changeInspectorProperty({name:"new_image"}, UIEditorScreen.instance.rightPanel);

                //PropertyChangeOperation
                undo();
                assertEquals(documentManager.selectedObject.name, name);
                redo();
                assertEquals(documentManager.selectedObject.name, "new_image");
            },

            //move up
            function():void{
                var target:DisplayObject = selectedObject;
                assertEquals(target.parent.getChildIndex(target), 1);
                clickButton("up");
                assertEquals(target.parent.getChildIndex(target), 0);
                clickButton("up");
                assertEquals(target.parent.getChildIndex(target), 0);

                //MoveLayerOperation
                undo();
                assertEquals(target.parent.getChildIndex(target), 1);
                redo();
                assertEquals(target.parent.getChildIndex(target), 0);
            },

            //go down
            function():void{
                var target:DisplayObject = selectedObject;
                clickButton("down");
                assertEquals(target.parent.getChildIndex(target), 1);
                clickButton("down");
                assertEquals(target.parent.getChildIndex(target), 1);

                //MoveLayerOperation
                undo();
                assertEquals(target.parent.getChildIndex(target), 0);
                redo();
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

                //PasteOperation
                undo();
                assertEquals(documentManager.root.numChildren, 2);
                redo();
                assertEquals(documentManager.root.numChildren, 3);
            },

            function():void{
                clickButton("delete");
                assertEquals(documentManager.root.numChildren, 2);

                //DeleteOperation
                undo();
                assertEquals(documentManager.root.numChildren, 3);
                redo();
                assertEquals(documentManager.root.numChildren, 2);
            }
        ];

        public static var renderer:LayoutItemRenderer;

        public static const DRAG_DROP:Array = [

            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);
            },

            function():void{
                selectTab("container");
                selectListComponent(Sprite);
            },

            function():void{
                selectTab("layout");
                selectList(1);
            },

            //drag to bottom
            function():void{
                renderer = getListItemRendererAt(1) as LayoutItemRenderer;
                assertEquals(documentManager.root.getChildAt(0), renderer.data.obj);

                simulateTouch(renderer, renderer.width / 2, renderer.height / 2, 0, renderer.height * 1.4);
                assertEquals(documentManager.root.getChildAt(1), renderer.data.obj);
            },

            //drag to top
            function():void{
                renderer = getListItemRendererAt(2) as LayoutItemRenderer;
                simulateTouch(renderer, renderer.width / 2, renderer.height / 2, 0, -renderer.height * 1.4);
                assertEquals(documentManager.root.getChildAt(0), renderer.data.obj);
            },

            //drag to center
            function():void{
                renderer = getListItemRendererAt(1) as LayoutItemRenderer;
                simulateTouch(renderer, renderer.width / 2, renderer.height / 2, 0, renderer.height);
                assertEquals(DisplayObjectContainer(documentManager.root.getChildAt(0)).getChildAt(0), renderer.data.obj);

                //MoveLayerOperation
                undo();
                assertEquals(documentManager.root.getChildAt(0), renderer.data.obj);
                redo();
                assertEquals(DisplayObjectContainer(documentManager.root.getChildAt(0)).getChildAt(0), renderer.data.obj);
            }
        ]
    }
}
