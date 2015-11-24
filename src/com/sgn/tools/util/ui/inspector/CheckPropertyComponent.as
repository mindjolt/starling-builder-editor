/**
 * Created by hyh on 9/14/15.
 */
package com.sgn.tools.util.ui.inspector
{
    import feathers.controls.Check;

    import starling.events.Event;

    public class CheckPropertyComponent extends BasePropertyComponent
    {
        protected var _check:Check;

        public function CheckPropertyComponent()
        {
            _check = new Check();
            addChild(_check);
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

        override public function init(args:Array):void
        {
            super.init(args);
            update();
            _check.addEventListener(Event.CHANGE, onCheck);
        }

        override public function recycle():void
        {
            _check.removeEventListener(Event.CHANGE, onCheck);
            super.recycle();
        }


    }
}
