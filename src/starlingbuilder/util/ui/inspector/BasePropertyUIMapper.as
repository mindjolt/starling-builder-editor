/**
 * Created by hyh on 5/15/15.
 */
package starlingbuilder.util.ui.inspector
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;
    import feathers.layout.FlowLayout;

    import starlingbuilder.engine.UIElementFactory;
    import starlingbuilder.engine.util.ObjectLocaterUtil;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class BasePropertyUIMapper extends ScrollContainer implements IUIMapper
    {
        public static const DEFAULT_COLUMN_GAP:int = 10;

        protected var _target:Object;
        protected var _param:Object;
        protected var _customParam:Object;
        protected var _propertyRetriever:IPropertyRetriever;

        protected var _factory:UIPropertyComponentFactory;
        protected var _setting:Object;

        public function BasePropertyUIMapper(target:Object, param:Object, customParam:Object = null, propertyRetrieverFactory:Function = null, setting:Object = null)
        {
            _target = target;
            _param = param;
            _customParam = customParam;
            _setting = setting;

            _factory = new UIPropertyComponentFactory();

            if (propertyRetrieverFactory)
            {
                _propertyRetriever = propertyRetrieverFactory(target, param);
            }
            else
            {
                _propertyRetriever = new DefaultPropertyRetriever(_target, param);
            }

            var layout:FlowLayout = new FlowLayout();
            layout.gap = DEFAULT_COLUMN_GAP;
            this.layout = layout;

            applySetting(this, UIPropertyComponentFactory.ROW);

            var component:LabelPropertyComponent = new LabelPropertyComponent(_propertyRetriever, _param, _customParam, _setting);
            component.addEventListener(Event.CHANGE, onChange);
            addChild(component);

            createComponents(param);
        }

        public function get propertyRetriever():IPropertyRetriever
        {
            return _propertyRetriever;
        }

        public function set propertyRetriever(value:IPropertyRetriever):void
        {
            _propertyRetriever = value;
        }

        public function set target(value:Object):void
        {
            _target = value;
        }

        public function set customParam(value:Object):void
        {
            _customParam = value;
        }

        public function update():void
        {
            updateVisibility();
        }

        private static function getAll(array:Array, container:DisplayObjectContainer, cls:Class):void
        {
            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                if (child is cls)
                {
                    array.push(child);
                }
                else if (child is DisplayObjectContainer)
                {
                    getAll(array, DisplayObjectContainer(child), cls);
                }
            }
        }

        private function createComponents(param:Object):void
        {
            var items:Array = _factory.getItems(param.component);

            for each (var item:String in items)
            {
                createComponent(item, param, _customParam, _setting);
            }
        }

        private function createComponent(type:String, param:Object, customParam:Object, setting:Object):void
        {
            var component:BasePropertyComponent;

            var cls:Class = _factory.getComponent(type);

            component = new cls(_propertyRetriever, param, customParam, setting);
            component.addEventListener(Event.CHANGE, onChange);
            addChild(component);
        }

        private function onChange(event:Event):void
        {
            var data:Object = {target:_target, propertyName:_param.name};
            if (event.data && event.data.hasOwnProperty("oldValue"))
                data.oldValue = event.data.oldValue;

            PropertyPanel.globalDispatcher.dispatchEventWith(UIMapperEventType.PROPERTY_CHANGE, false, data);
        }

        public static function sortBasePropertyComponent(array:Array, priorities:Object):void
        {
            array.sort(function(c1:BasePropertyComponent, c2:BasePropertyComponent):int
            {
                return int(priorities[c1.param.name]) - int(priorities[c2.param.name]);
            });
        }

        public function get factory():UIPropertyComponentFactory
        {
            return _factory;
        }

        public static function updateAll(container:DisplayObjectContainer, target:Object = null, customParam:Object = null):void
        {
            var array:Array = [];
            getAll(array, container, BasePropertyComponent);

            sortBasePropertyComponent(array, UIElementFactory.PARAMS);

            var array2:Array = [];
            getAll(array2, container, BasePropertyUIMapper);

            for each (var it:BasePropertyUIMapper in array2)
            {
                if (target)
                {
                    it.target = target;
                    it.customParam = customParam;
                }
                it.update();
            }

            for each (var item:IUIMapper in array)
            {
                if (target)
                {
                    item.target = target;
                    item.customParam = customParam;
                }
                item.update();
            }
        }

        protected function applySetting(obj:DisplayObject, componentName:String):void
        {
            PropertyPanel.applySetting(obj, _setting, componentName);
        }

        private function updateVisibility():void
        {
            if ("if" in _param)
            {
                //handle condition: {if:{name==value}}
                var array:Array = _param["if"].split("==");
                if (array.length == 2)
                {
                    var name:String = array[0];
                    var value:String = array[1];

                    if (_target[name].toString() == value)
                    {
                        visible = true;
                        includeInLayout = true;
                    }
                    else
                    {
                        visible = false;
                        includeInLayout = false;
                    }

                    return;
                }
            }

            visible = true;
            includeInLayout = true;
        }
    }
}
