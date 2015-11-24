/**
 * Created by hyh on 5/15/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import com.sgn.starlingbuilder.engine.UIElementFactory;
    import com.sgn.tools.util.feathers.FeathersUIUtil;
    import com.sgn.tools.util.pool.IPoolable;
    import com.sgn.tools.util.pool.ObjectPoolFactory;
    import com.sgn.tools.util.ui.inspector.PoolableLabel;

    import feathers.controls.Label;
    import feathers.controls.ScrollContainer;
    import feathers.layout.HorizontalLayout;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class BasePropertyUIMapper extends ScrollContainer
    {
        protected var _gap:Number = 10;

        protected var _target:Object;
        protected var _param:Object;
        protected var _propertyRetriever:IPropertyRetriever;

        protected var _factory:UIPropertyComponentFactory;

        private var _pool:ObjectPoolFactory;

        public function BasePropertyUIMapper(target:Object, param:Object, propertyRetrieverFactory:Function = null)
        {
            var layout:HorizontalLayout = new HorizontalLayout();
            layout.gap = _gap;
            this.layout = layout;

            _target = target;
            _param = param;

            _factory = new UIPropertyComponentFactory();

            _pool = ObjectPoolFactory.instance;

            if (propertyRetrieverFactory)
            {
                _propertyRetriever = propertyRetrieverFactory(target, param);
            }
            else
            {
                _propertyRetriever = new DefaultPropertyRetriever(_target, param);
            }

            var label:PoolableLabel = _pool.getObject(PoolableLabel, [_param.label ? _param.label : _param.name]) as PoolableLabel;
            label.width = 70;
            label.wordWrap = true;
            addChild(label);

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

        public function update():void
        {

        }

        private static function getAll(array:Array, container:DisplayObjectContainer):void
        {
            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                if (child is BasePropertyComponent)
                {
                    array.push(child);
                }
                else if (child is DisplayObjectContainer)
                {
                    getAll(array, DisplayObjectContainer(child));
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

            component = ObjectPoolFactory.instance.getObject(cls, [_propertyRetriever, param]) as BasePropertyComponent;
            //component = new cls(_propertyRetriever, param);
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

        public static function updateAll(container:DisplayObjectContainer):void
        {
            var array:Array = [];
            getAll(array, container);

            sortBasePropertyComponent(array, UIElementFactory.PARAMS);

            for each (var item:BasePropertyComponent in array)
            {
                item.update();
            }
        }

        override public function dispose():void
        {
            while (numChildren)
            {
                var displayObject:DisplayObject = getChildAt(0);

                displayObject.removeFromParent();

                var poolable:IPoolable = displayObject as IPoolable;

                var component:BasePropertyComponent = displayObject as BasePropertyComponent;

                if (component)
                {
                    component.removeEventListener(Event.CHANGE, onChange);
                }

                if (poolable)
                {
                    _pool.recycleObject(poolable);
                }
                else
                {
                    displayObject.removeFromParent(true);
                }

            }

        }
    }
}
