/**
 * Created by hyh on 5/15/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import com.sgn.starlingbuilder.engine.UIElementFactory;
    import com.sgn.tools.util.feathers.FeathersUIUtil;

    import feathers.controls.Label;
    import feathers.controls.ScrollContainer;
    import feathers.layout.HorizontalLayout;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class BasePropertyUIMapper extends ScrollContainer implements IUIMapper
    {
        protected var _gap:Number = 10;

        protected var _target:Object;
        protected var _param:Object;
        protected var _propertyRetriever:IPropertyRetriever;

        protected var _factory:UIPropertyComponentFactory;

        public function BasePropertyUIMapper(target:Object, param:Object, propertyRetrieverFactory:Function = null)
        {
            var layout:HorizontalLayout = new HorizontalLayout();
            layout.gap = _gap;
            this.layout = layout;

            _target = target;
            _param = param;

            _factory = new UIPropertyComponentFactory();

            if (propertyRetrieverFactory)
            {
                _propertyRetriever = propertyRetrieverFactory(target, param);
            }
            else
            {
                _propertyRetriever = new DefaultPropertyRetriever(_target, param);
            }

            var name:String = _param.label ? _param.label : _param.name;
            if (isNumerical(_propertyRetriever.get(name)))
            {
                createComponent("scrollableLabel", {"name": name});
            }
            else
            {
                var label:Label = FeathersUIUtil.labelWithText(name);
                label.width = 70;
                label.wordWrap = true;
                addChild(label);
            }

            createComponents(param);
        }

        private function isNumerical(value:Object):Boolean
        {
            if (value is int)
            {
                return true;
            }
            else if (value is Number)
            {
                return true;
            }
            return false
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

        public function update():void
        {

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
                createComponent(item, param);
            }
        }

        private function createComponent(type:String, param:Object):void
        {
            var component:BasePropertyComponent;

            var cls:Class = _factory.getComponent(type);

            component = new cls(_propertyRetriever, param);
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

        public static function updateAll(container:DisplayObjectContainer, target:Object = null):void
        {
            var array:Array = [];
            getAll(array, container, BasePropertyComponent);

            sortBasePropertyComponent(array, UIElementFactory.PARAMS);

            if (target)
            {
                var array2:Array = [];
                getAll(array2, container, BasePropertyUIMapper);

                for each (var it:BasePropertyUIMapper in array2)
                {
                    if (target)
                    {
                        it.target = target;
                    }
                }
            }

            for each (var item:IUIMapper in array)
            {
                if (target)
                {
                    item.target = target;
                }
                item.update();
            }
        }
    }
}
