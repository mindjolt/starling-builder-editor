/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import flash.utils.getDefinitionByName;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.display.Sprite3D;
    import starling.filters.BlurFilter;
    import starling.filters.DropShadowFilter;
    import starling.filters.GlowFilter;
    import starling.text.TextField;

    import starlingbuilder.editor.CITestUtil;
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.assertNumericEquals;
    import starlingbuilder.editor.citestutil.findDisplayObject;
    import starlingbuilder.editor.citestutil.simulateTouch;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.ui.DefaultEditPropertyPopup;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.extensions.filters.ColorFilter;

    public class BasicTest extends AbstractTest
    {



        public static const INTERACTION:Array = [

            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);
            },

            //drag
            function():void{
                var target:DisplayObject = selectedObject;
                target.x = 0;
                target.y = 0;
                documentManager.setChanged();

                simulateTouch(target, 50, 50, 200, 200);
                assertNumericEquals(target.x, 200);
                assertNumericEquals(target.y, 200);

                //MoveOperation
                undo();
                assertNumericEquals(target.x, 0);
                assertNumericEquals(target.y, 0);
                redo();
            },

            //top left corner
            function():void{
                var target:DisplayObject = selectedObject;
                var oldX:Number = target.x;
                var oldY:Number = target.y;
                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;
                simulateTouch(target, 0, 0, -10, -10);
                assertNumericEquals(target.x, 200 - 10);
                assertNumericEquals(target.y, 200 - 10);
                assertNumericEquals(target.width, oldWidth + 10);
                assertNumericEquals(target.height, oldHeight + 10);

                //ResizeOperation
                undo();
                assertNumericEquals(target.x, oldX);
                assertNumericEquals(target.y, oldY);
                assertNumericEquals(target.width, oldWidth);
                assertNumericEquals(target.height, oldHeight);
                redo();
            },

            function():void{
                var target:DisplayObject = selectedObject;
                simulateTouch(target, 0, 0, 10, 10);
            },


            //top right corner
            function():void{
                var target:DisplayObject = selectedObject;
                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;
                simulateTouch(target, target.width / target.scaleX, 0, 10, -10);
                assertNumericEquals(target.x, 200);
                assertNumericEquals(target.y, 200 - 10);
                assertNumericEquals(target.width, oldWidth + 10);
                assertNumericEquals(target.height, oldHeight + 10);

            },

            function():void{
                var target:DisplayObject = selectedObject;
                simulateTouch(target, target.width /  target.scaleX, 0, -10, 10);
            },


            //bottom left corner
            function():void{
                var target:DisplayObject = selectedObject;
                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;
                simulateTouch(target, 0, target.height / target.scaleY, -10, 10);
                assertNumericEquals(target.x, 200 - 10);
                assertNumericEquals(target.y, 200);
                assertNumericEquals(target.width, oldWidth + 10);
                assertNumericEquals(target.height, oldHeight + 10);
            },

            function():void{
                var target:DisplayObject = selectedObject;
                simulateTouch(target, 0, target.height /  target.scaleY, 10, -10);
            },


            //bottom right corner
            function():void{
                var target:DisplayObject = selectedObject;
                var oldWidth:Number = target.width;
                var oldHeight:Number = target.height;
                simulateTouch(target, target.width / target.scaleX, target.height /  target.scaleY, 10, 10);
                assertNumericEquals(target.x, 200);
                assertNumericEquals(target.y, 200);
                assertNumericEquals(target.width, oldWidth + 10);
                assertNumericEquals(target.height, oldHeight + 10);
            },

            function():void{
                var target:DisplayObject = selectedObject;
                simulateTouch(target, target.width /  target.scaleX, target.height /  target.scaleY, -10, -10);
            },


            function():void{
                var target:DisplayObject = selectedObject;
                var oldX:Number = target.x;
                var oldY:Number = target.y;
                var oldPivotX:Number = target.pivotX;
                var oldPivotY:Number = target.pivotY;
                clickButton("set pivot to");
                assertNumericEquals(target.pivotX, target.width / 2);
                assertNumericEquals(target.pivotY, target.height / 2);
                assertNumericEquals(target.x, oldX + target.width / 2);
                assertNumericEquals(target.y, oldY + target.height / 2);

                //MovePivotOperation
                undo();
                assertNumericEquals(target.pivotX, oldPivotX);
                assertNumericEquals(target.pivotY, oldPivotY);
                redo();
            },

            function():void{
                var target:DisplayObject = selectedObject;
                var oldX:Number = target.x;
                var oldY:Number = target.y;
                simulateTouch(target, target.width /  target.scaleX / 2, target.height /  target.scaleY / 2, -10, -10);
                assertNumericEquals(target.x, oldX - 10);
                assertNumericEquals(target.y, oldY - 10);
            },

            function():void{
                var target:DisplayObject = selectedObject;
                target.rotation = Math.PI / 4;
                documentManager.setChanged();
            },

            function():void{

                var target:DisplayObject = selectedObject;
                var oldScaleX:Number = target.scaleX;
                var oldScaleY:Number = target.scaleY;
                var oldRotation:Number = target.rotation;

                clickButton("reset");

                assertNumericEquals(target.scaleX, 1);
                assertNumericEquals(target.scaleY, 1);
                assertNumericEquals(target.rotation, 0);

                undo();
                assertNumericEquals(target.scaleX, oldScaleX);
                assertNumericEquals(target.scaleY, oldScaleY);
                assertNumericEquals(target.rotation, oldRotation);
                redo();
            }
        ]


        public static const COMPONENT1:Array = [

            //Quad
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Quad);
                selectGroupList(0, 0);
                clickButton("OK");
            },

            //Button
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Button);
                selectGroupList(0, 0);
            },

//            //Scale3Image
//            function():void{
//                documentManager.clear();
//                selectTab("asset");
//                selectPickerListComponent(Scale3Image);
//                selectGroupList(0, 0);
//            },
//
//            function():void{
//                clickButton("OK");
//            },
//
//            function():void{
//                var target:DisplayObject = selectedObject;
//                simulateTouch(target, target.width / target.scaleX, target.height /  target.scaleY, 200, 0);
//            },
//
//            //Scale9Image
//            function():void{
//                documentManager.clear();
//                selectTab("asset");
//                selectPickerListComponent(Scale9Image);
//                selectGroupList(0, 3);
//            },
//
//            function():void{
//                clickButton("OK");
//            },
//
//            function():void{
//                var target:DisplayObject = selectedObject;
//                simulateTouch(target, target.width / target.scaleX, target.height /  target.scaleY, 200, 200);
//            },
//
//            //TiledImage
//            function():void{
//                documentManager.clear();
//                selectTab("asset");
//                selectPickerListComponent(TiledImage);
//                selectGroupList(0, 3);
//            },
//
//            function():void{
//                var target:DisplayObject = selectedObject;
//                simulateTouch(target, target.width / target.scaleX, target.height /  target.scaleY, 200, 200);
//            },

            //MovieClip
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(MovieClip);
                selectGroupList(0, 0);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                clickButton("play");
            },

            function():void{
                clickButton("stop");
            },
        ]


        public static const COMPONENT2:Array = [

            //text tab
            function():void{
                documentManager.clear();
                selectTab("text");
                selectListComponent(TextField);
            },

            //container tab
            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(Sprite);
            },

            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(Sprite3D);
            },

            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(LayoutGroup);
            },

            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(ScrollContainer);
            },
        ]

        public static function get COMPONENT3():Array
        {
            var array:Array = [];

            var components:Array = TemplateData.getSupportedComponent("feathers");

            for (var i:int = 0; i < components.length; ++i)
                array.push(componentFunction(getDefinitionByName(components[i]) as Class));

            return array;
        }

        public static const FILTERS:Array = [
            function():void{
                documentManager.clear();
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);
            },

            function():void{
                clickInspectorEditButton("filter", UIEditorScreen.instance.rightPanel);
                var popup:DisplayObjectContainer = findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer;
                selectPickerListComponent(BlurFilter, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                clickInspectorEditButton("filter", UIEditorScreen.instance.rightPanel);
                var popup:DisplayObjectContainer = findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer;
                selectPickerListComponent(DropShadowFilter, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                clickInspectorEditButton("filter", UIEditorScreen.instance.rightPanel);
                var popup:DisplayObjectContainer = findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer;
                selectPickerListComponent(GlowFilter, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                clickInspectorEditButton("filter", UIEditorScreen.instance.rightPanel);
                var popup:DisplayObjectContainer = findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer;
                selectPickerListComponent(ColorFilter, popup);
                changeInspectorProperty({"hue":1});
            },

            function():void{
                clickButton("OK");
            },
        ]
    }
}
