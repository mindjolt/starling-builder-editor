/**
 * Created by hyh on 1/16/16.
 */
package starlingbuilder.editor.citestcase
{
    import feathers.controls.Check;
    import feathers.controls.GroupedList;
    import feathers.controls.List;
    import feathers.controls.PickerList;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;

    import starling.core.Starling;

    import starling.display.Button;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Stage;
    import starling.events.Event;

    import starlingbuilder.editor.CITestUtil;
    import starlingbuilder.editor.UIEditorApp;

    import starlingbuilder.editor.UIEditorScreen;

    import starlingbuilder.editor.citestutil.findDisplayObject;
    import starlingbuilder.editor.citestutil.simulateTouch;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.ui.inspector.LinkButton;

    public class AbstractTest
    {
        public function AbstractTest()
        {
        }

        public static function get stage():Stage
        {
            return Starling.current.stage;
        }

        public static function get selectedObject():DisplayObject
        {
            return UIEditorApp.instance.documentManager.selectedObject;
        }

        public static function get documentManager():DocumentManager
        {
            return UIEditorApp.instance.documentManager;
        }

        public static function selectTab(name:String):void
        {
            simulateTouch(findDisplayObject({label:name}));
        }

        public static function selectPickerListComponent(cls:Class):void
        {
            var pickerList:PickerList = findDisplayObject({cls:PickerList}, UIEditorScreen.instance.leftPanel) as PickerList;
            pickerList.selectedItem = ParamUtil.getClassName(cls);
        }

        public static function selectListComponent(cls:Class):void
        {
            var list:List = findDisplayObject({cls:List}, UIEditorScreen.instance.leftPanel) as List;
            var index:int = CITestUtil.findListCollectionIndex(list.dataProvider, ParamUtil.getClassName(cls));
            list.selectedIndex = index;
        }

        public static function selectGroupList(groupIndex:int, itemIndex:int):void
        {
            var list:GroupedList = findDisplayObject({cls:GroupedList}) as GroupedList;
            list.setSelectedLocation(groupIndex, itemIndex);
        }

        public static function selectList(index:int):void
        {
            var list:List = findDisplayObject({cls:List}) as List;
            list.selectedIndex = index;
        }

        public static function selectPickerList(index:int, container:DisplayObjectContainer = null):void
        {
            var pickerList:PickerList = findDisplayObject({cls:PickerList}, container) as PickerList;
            pickerList.selectedIndex = index;
        }

        public static function selectPickerListClass(cls:Class, container:DisplayObjectContainer = null):void
        {
            var pickerList:PickerList = findDisplayObject({cls:PickerList}, container) as PickerList;

            var str:String = ParamUtil.getClassName(cls);
            trace(str);
            pickerList.selectedItem = ParamUtil.getClassName(cls);
        }

        public static function clickButton(name:String, container:DisplayObjectContainer = null):void
        {
            simulateTouch(findDisplayObject({label:name}, container));
        }

        public static function clickButtonWithName(name:String, container:DisplayObjectContainer = null):void
        {
            simulateTouch(findDisplayObject({name:name}, container));
        }

        public static function componentFunction(cls:Class):Function
        {
            return function():void{
                documentManager.clear();
                selectTab("feathers");
                selectListComponent(cls);
                trace(ParamUtil.getClassName(cls));
            }
        }

        public static function changeInspectorProperty(properties:Object, container:DisplayObjectContainer = null):void
        {
            for (var name:String in properties)
            {
                var value:Object = properties[name];

                var obj:DisplayObjectContainer = findDisplayObject({text: name}, container).parent.parent;

                const components:Array = [TextInput, TextArea, PickerList, Check];

                for each (var cls:Class in components)
                {
                    var object:DisplayObject = findDisplayObject({cls: cls}, obj);

                    if (object is TextInput)
                    {
                        var textInput:TextInput = object as TextInput;
                        textInput.text = value.toString();
                        textInput.dispatchEventWith(FeathersEventType.FOCUS_OUT);
                    }
                    else if (object is TextArea)
                    {
                        var textArea:TextArea = object as TextArea;
                        textArea.text = value.toString();
                        textArea.dispatchEventWith(FeathersEventType.FOCUS_OUT);
                    }
                    else if (object is Check)
                    {
                        var check:Check = object as Check;
                        check.isSelected = value;
                        check.dispatchEventWith(Event.CHANGE);
                    }
                    else if (object is PickerList)
                    {
                        var pickerList:PickerList = object as PickerList;
                        pickerList.selectedItem = value;
                        pickerList.dispatchEventWith(Event.CHANGE);
                    }
                }
            }
        }

        public static function clickLinkButton():void
        {
            var linkButton:LinkButton = findDisplayObject({cls:LinkButton}) as LinkButton;
            var button:Button = findDisplayObject({cls:Button}, linkButton) as Button;
            if (button)
            {
                simulateTouch(button);
            }
        }

        public static function undo():void
        {
            documentManager.historyManager.undo();
        }

        public static function redo():void
        {
            documentManager.historyManager.redo();
        }
    }
}
