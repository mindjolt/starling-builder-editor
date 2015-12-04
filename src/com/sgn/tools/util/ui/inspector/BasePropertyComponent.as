/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import com.sgn.tools.util.pool.IPoolable;

    import feathers.controls.LayoutGroup;
    import feathers.core.IFeathersControl;

    import starling.events.Event;

    public class BasePropertyComponent extends LayoutGroup implements IUIMapper
    {
        protected var _propertyRetriever:IPropertyRetriever;
        protected var _param:Object;
        protected var _oldValue:Object;

        public function BasePropertyComponent(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super();

            _propertyRetriever = propertyRetriver;
            _param = param;
        }

        public function set target(value:Object):void
        {
            _propertyRetriever.target = value;
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
                return Math.abs(Number(_propertyRetriever.get(_param.name)) - Number(_oldValue)) >= 1;
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
