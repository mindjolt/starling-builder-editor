/**
 * Created by hyh on 9/14/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.Check;

    import starling.events.Event;

    public class CheckPropertyComponent extends BasePropertyComponent
    {
        protected var _check:Check;

        public function CheckPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object = null)
        {
            super(propertyRetriver, param, customParam);

            _check = new Check();
            addChild(_check);

            update();
            _check.addEventListener(Event.CHANGE, onCheck);
        }

        private function onCheck(event:Event):void
        {
            _oldValue = _propertyRetriever.get(_param.name);
            _propertyRetriever.set(_param.name, _check.isSelected);

            setChanged();
        }

        override public function update():void
        {
            _check.isSelected = _propertyRetriever.get(_param.name);
        }
    }
}
