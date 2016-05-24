/**
 * Created by hyh on 5/16/16.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.Button;

    import flash.filesystem.File;

    import starling.events.Event;

    import starlingbuilder.editor.UIEditorScreen;

    import starlingbuilder.util.FileLoader;

    public class EditPathPropertyComponent extends BasePropertyComponent
    {
        protected var _button:Button;

        public function EditPathPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);

            _button = new Button();
            _button.label = "Edit";
            _button.addEventListener(Event.TRIGGERED, onButton);
            addChild(_button);
        }

        protected function onButton(event:Event):void
        {
            FileLoader.browseForDirectory("Select folder:", function(file:File):void{

                var dir:String = UIEditorScreen.instance.workspaceDir.getRelativePath(file, true);
                var value:String = _propertyRetriever.get(_param.name) as String;

                value = processPath(value, dir);

                _oldValue = _propertyRetriever.get(_param.name);
                _propertyRetriever.set(_param.name, value);
                setChanged();
            });
        }

        protected function processPath(path:String, value:String):String
        {
            return value;
        }
    }
}
