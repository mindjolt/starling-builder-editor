/**
 * Created by hyh on 7/16/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.LayoutGroup;
    import feathers.core.IFeathersControl;

    import starling.events.Event;

    public class BasePropertyComponent extends LayoutGroup
    {
        protected var _propertyRetriever:IPropertyRetriever;
        protected var _param:Object;
        protected var _oldValue:Object;

        public function BasePropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super();
            _propertyRetriever = propertyRetriever;
            _param = param;
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
