/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestcase
{
    import feathers.controls.LayoutGroup;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.FlowLayout;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;
    import feathers.layout.WaterfallLayout;

    import starling.display.DisplayObjectContainer;
    import starling.display.Image;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.citestutil.findDisplayObject;
    import starlingbuilder.editor.ui.DefaultEditPropertyPopup;

    public class LayoutTest extends AbstractTest
    {
        public function LayoutTest()
        {
        }

        public static const LAYOUTS:Array = [
            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(LayoutGroup);
            },

            function():void{
                selectTab("asset");
                selectPickerListComponent(Image);
                for (var i:int = 0; i < 4; ++i) selectGroupList(0, 0);
                documentManager.selectObject(selectedObject.parent);
            },

            function():void{
                selectLayout(HorizontalLayout);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayout(VerticalLayout);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayout(FlowLayout);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayout(TiledRowsLayout);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayout(TiledColumnsLayout);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayout(WaterfallLayout);
            },

            function():void{
                clickButton("OK");
            },
        ]

        public static const ANCHOR_LAYOUT:Array = [
            function():void{
                documentManager.clear();
                selectTab("container");
                selectListComponent(LayoutGroup);
                changeInspectorProperty({width:500, height:500}, UIEditorScreen.instance.rightPanel);
                selectLayout(AnchorLayout);
                clickButton("OK");

                selectListComponent(LayoutGroup);
            },

            function():void{
                selectTab("asset");
                selectPickerListComponent(Image);
                selectGroupList(0, 0);
                documentManager.selectObject(selectedObject.parent);
            },

            function():void{
                selectLayoutData(AnchorLayoutData);
                var popup:DefaultEditPropertyPopup = findDisplayObject({cls:DefaultEditPropertyPopup}) as DefaultEditPropertyPopup;
                changeInspectorProperty({top:0, left:0, bottom:NaN, right:NaN}, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayoutData(AnchorLayoutData);
                var popup:DefaultEditPropertyPopup = findDisplayObject({cls:DefaultEditPropertyPopup}) as DefaultEditPropertyPopup;
                changeInspectorProperty({top:0, left:NaN, bottom:NaN, right:0}, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayoutData(AnchorLayoutData);
                var popup:DefaultEditPropertyPopup = findDisplayObject({cls:DefaultEditPropertyPopup}) as DefaultEditPropertyPopup;
                changeInspectorProperty({top:NaN, left:0, bottom:0, right:NaN}, popup);
            },

            function():void{
                clickButton("OK");
            },

            function():void{
                selectLayoutData(AnchorLayoutData);
                var popup:DefaultEditPropertyPopup = findDisplayObject({cls:DefaultEditPropertyPopup}) as DefaultEditPropertyPopup;
                changeInspectorProperty({top:NaN, left:NaN, bottom:0, right:0}, popup);
            },

            function():void{
                clickButton("OK");
            },
        ]

        public static function selectLayout(cls:Class):void
        {
            clickButton("edit", findDisplayObject({text:"layout"}, UIEditorScreen.instance.rightPanel).parent.parent);
            selectPickerListClass(cls, findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer);
        }

        public static function selectLayoutData(cls:Class):void
        {
            clickButton("edit", findDisplayObject({text:"layoutData"}, UIEditorScreen.instance.rightPanel).parent.parent);
            selectPickerListClass(cls, findDisplayObject({cls:DefaultEditPropertyPopup}) as DisplayObjectContainer);
        }
    }
}
