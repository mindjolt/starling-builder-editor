/**
 * Created by hyh on 7/9/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.Check;

    import starling.events.Event;

    public class LinkedPropertyPanel extends PropertyPanel
    {
        protected var _linkCheck:Check;

        private var _initValues:Object = {};

        private var _condition:Function;

        public function LinkedPropertyPanel(target:Object = null, params:Array = null, propertyRetrieverFactory:Function = null, condition:Function = null)
        {
            super(target, params, propertyRetrieverFactory);

            _condition = condition;

            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);
        }



        override public function reloadData(target:Object = null, params:Array = null):void
        {
            super.reloadData(target, params);

            if (!_linkCheck)
            {
                _linkCheck = new Check();
                _linkCheck.label = "link";

                for each (var param:Object in _params)
                {
                    _initValues[param.name] = target[param.name];
                }
            }

            _container.addChild(_linkCheck);
        }

        private function onPropertyChange(event:Event):void
        {
            if (_linkCheck.isSelected && (_condition == null || _condition(_target)))
            {
                var name:String = event.data.propertyName;

                var found:Boolean = false;
                for each (var param:Object in _params)
                {
                    if (param.name == name)
                    {
                        found = true;
                        break;
                    }
                }

                if (found)
                {
                    for each (var param:Object in _params)
                    {
                        if (param.name == name)
                        {
                            continue;
                        }

                        var ratio:Number = _target[name] / _initValues[name];
                        _target[param.name] = _initValues[param.name] * ratio;
                    }
                }

                BasePropertyUIMapper.updateAll(this);

            }
        }

        override public function dispose():void
        {
            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            super.dispose();
        }
    }
}
