/**
 * Created by hyh on 8/28/15.
 */
package starlingbuilder.util.ui.inspector
{
    import starling.display.Image;

    import starlingbuilder.editor.UIEditorApp;

    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.core.PopUpManager;

    import flash.utils.getDefinitionByName;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class ButtonPropertyComponent extends BasePropertyComponent
    {
        private var _button:Button;

        public function ButtonPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object = null)
        {
            super(propertyRetriver, param, customParam);

            _button = FeathersUIUtil.buttonWithLabel("edit", onEdit);
            addChild(_button);
        }

        private function onEdit(event:Event):void
        {
            if (param.editPropertyClass)
            {
                var target:Object = _propertyRetriever.get(_param.name);

                var cls:Class = getDefinitionByName(param.editPropertyClass) as Class;
                var popup:DisplayObject = new cls(_propertyRetriever.target, target, param, _customParam, function(item:Object):void{
                    if (!_param.read_only)
                    {
                        _oldValue = _propertyRetriever.get(_param.name);
                        _propertyRetriever.set(_param.name, item);
                        setChanged();
                    }
                });

                PopUpManager.addPopUp(popup);
            }
        }




    }
}
