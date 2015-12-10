/**
 * Created by hyh on 5/15/15.
 */
package starlingbuilder.util.ui.inspector
{
    import starlingbuilder.engine.util.ObjectLocaterUtil;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import starling.display.DisplayObject;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class PropertyPanel extends LayoutGroup
    {
        public static var globalDispatcher:EventDispatcher = new EventDispatcher();

        protected var _container:ScrollContainer;

        protected var _target:Object;
        protected var _params:Array;

        protected var _propertyRetrieverFactory:Function;

        public function PropertyPanel(target:Object = null, params:Array = null, propertyRetrieverFactory:Function = null)
        {
            _propertyRetrieverFactory = propertyRetrieverFactory;

            _container = FeathersUIUtil.scrollContainerWithVerticalLayout();
            addChild(_container);

            if (target && params)
                reloadData(target, params);

            globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onGlobalPropertyChange);
        }

        private function onPropertyChange(event:Event):void
        {
            reloadData(_target);
        }

        private function onGlobalPropertyChange(event:Event):void
        {
            if (event.data.target === _target)
            {
                reloadTarget(_target);
            }
        }

        public function reloadTarget(target:Object = null, force:Boolean = false):void
        {
            if (_target !== target || force)
            {
                _target = target;

                _container.removeChildren(0, -1, true);

                //_propertyMappers = [];

                for each (var param:Object in _params)
                {
                    if (param is Array)
                    {
                        var panel:PropertyPanel = new LinkedPropertyPanel(_target, param as Array, _propertyRetrieverFactory, function(target:Object):Boolean {
                            return target is DisplayObject && target.rotation == 0;
                        });
                        _container.addChild(panel);
                    }
                    else if (hasProperty(_target, param.name))
                    {
                        var mapper:BasePropertyUIMapper = new BasePropertyUIMapper(_target, param, _propertyRetrieverFactory);
                        _container.addChild(mapper);
                    }
                }
            }
            else
            {
                BasePropertyUIMapper.updateAll(this);
            }
        }

        public function reloadData(target:Object = null, params:Array = null):void
        {
            if (target !== _target)
            {
                if (params !== _params) //both target and params change
                {
                    _params = params;
                    reloadTarget(target);
                }
                else    //only target changes
                {
                    _target = target;
                    BasePropertyUIMapper.updateAll(this, _target);
                }
            }
            else
            {
                if (params !== _params) //only params changes
                {
                    _params = params;
                }
                else    //none of them change
                {
                }

                reloadTarget(target);
            }
        }

        public function reset():void
        {
            _container.removeChildren(0, -1, true);
            _target = null;
            _params = null;
        }

        private function hasProperty(target:Object, name:String):Boolean
        {
            //Always allow as3 plain object to visible even if property does not exist
            if (ParamUtil.getClassName(target) == "Object")
                return true;

            return ObjectLocaterUtil.hasProperty(target, name);
        }

        override public function dispose():void
        {
            globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onGlobalPropertyChange);

            super.dispose();
        }

    }
}
