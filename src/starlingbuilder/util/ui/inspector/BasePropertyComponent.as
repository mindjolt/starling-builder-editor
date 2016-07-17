/**
 * Created by hyh on 7/16/15.
 */
package starlingbuilder.util.ui.inspector
{
    import starlingbuilder.util.pool.IPoolable;

    import feathers.controls.LayoutGroup;
    import feathers.core.IFeathersControl;

    import starling.events.Event;

    public class BasePropertyComponent extends LayoutGroup implements IUIMapper
    {
        protected var _propertyRetriever:IPropertyRetriever;
        protected var _param:Object;
        protected var _oldValue:Object;
        protected var _customParam:Object;

        public function BasePropertyComponent(propertyRetriver:IPropertyRetriever, param:Object, customParam:Object = null)
        {
            super();

            _propertyRetriever = propertyRetriver;
            _param = param;
            _customParam = customParam;
        }

        public function set target(value:Object):void
        {
            _propertyRetriever.target = value;
        }

        public function set customParam(value:Object):void
        {
            _customParam = value;
        }

        public function update():void
        {
        }

        public function setChanged():void
        {
            if (_propertyRetriever.target is IFeathersControl)
            {
                IFeathersControl(_propertyRetriever.target).validate();
            }

            var data:Object;

            if (hasChanges())
            {
                data = {oldValue:_oldValue};
            }

            dispatchEventWith(Event.CHANGE, false, data);
        }

        private function hasChanges():Boolean
        {
            //TODO: better change detection
            if (_oldValue is Number)
            {
                return Math.abs(Number(_propertyRetriever.get(_param.name)) - Number(_oldValue)) >= 0.0001;
            }
            else
            {
                return _oldValue !== _propertyRetriever.get(_param.name)
            }
        }

        public function get param():Object
        {
            return _param;
        }
    }
}
