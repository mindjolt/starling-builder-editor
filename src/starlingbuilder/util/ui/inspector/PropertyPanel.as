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
        public static const DEFAULT_ROW_GAP:int = 10;

        public static var globalDispatcher:EventDispatcher = new EventDispatcher();

        protected var _container:ScrollContainer;

        protected var _target:Object;
        protected var _params:Array;

        protected var _propertyRetrieverFactory:Function;

        protected var _linkedProperties:Array;
        protected var _linkedPropertiesInitValues:Object;
        protected var _linkButton:LinkButton;

        protected var _setting:Object;

        public function PropertyPanel(target:Object = null, params:Array = null, propertyRetrieverFactory:Function = null, setting:Object = null)
        {
            _linkedPropertiesInitValues = {};
            _linkButton = new LinkButton();

            _propertyRetrieverFactory = propertyRetrieverFactory;
            _setting = setting;

            _container = FeathersUIUtil.scrollContainerWithVerticalLayout(rowGap);
            addChild(_container);

            if (target && params)
                reloadData(target, params);

            globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onGlobalPropertyChange);
        }

        public function get rowGap():int
        {
            return (_setting && _setting.hasOwnProperty("rowGap")) ? _setting.rowGap : DEFAULT_ROW_GAP;
        }

        private function onGlobalPropertyChange(event:Event):void
        {
            if (event.data.target === _target)
            {
                changeLinkedProperties(event);

                reloadTarget(_target);
            }
        }

        public function reloadTarget(target:Object = null, force:Boolean = false):void
        {
            if (_target !== target || force)
            {
                _target = target;

                _container.removeChildren(0, -1, true);

                for each (var param:Object in _params)
                {
                    if (hasProperty(_target, param.name))
                    {
                        var mapper:BasePropertyUIMapper = new BasePropertyUIMapper(_target, param, _propertyRetrieverFactory, _setting);
                        _container.addChild(mapper);
                    }
                }

                _container.validate();

                var index:int = -1;

                if (_linkedProperties && _target && _params)
                {
                    index = findFirstLinkedPropertyIndex();
                }

                if (index >= 0)
                {
                    var obj:DisplayObject = _container.getChildAt(index);
                    addChild(_linkButton);
                    _linkButton.x = obj.x + obj.width + 3;
                    _linkButton.y = obj.y + obj.height / 2;
                }
                else
                {
                    _linkButton.removeFromParent();
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


        public function get linkedProperties():Array
        {
            return _linkedProperties;
        }

        public function set linkedProperties(value:Array):void
        {
            _linkedProperties = value;
        }

        private function findFirstLinkedPropertyIndex():int
        {
            for each (var name:String in _linkedProperties)
            {
                for (var i:int = 0; i < _params.length; ++i)
                {
                    if (_params[i].name == name && _params[i].hasOwnProperty("link"))
                    {
                        return i;
                    }
                }
            }

            return -1;
        }

        private function changeLinkedProperties(event:Event):void
        {
            var name:String = event.data.propertyName;

            if (_linkButton.isSelected && _linkedProperties.indexOf(name) != -1 && linkedCondition(_target))
            {
                for each (var item:String in _linkedProperties)
                {
                    if (item == name) continue;

                    if (_target && _target.hasOwnProperty(item))
                    {
                        //special case for locking width/height ratio
                        if (_target is DisplayObject)
                        {
                            if (name == "width")
                            {
                                _target["scaleY"] = _target["scaleX"];
                            }
                            else if (name == "height")
                            {
                                _target["scaleX"] = _target["scaleY"];
                            }
                        }
                    }
                }
            }
        }

        //special case for rotation/size race condition
        private function linkedCondition(target:Object):Boolean
        {
            return target is DisplayObject && target.rotation == 0;
        }
    }
}
