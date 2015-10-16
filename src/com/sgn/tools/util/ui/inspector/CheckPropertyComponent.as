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

        public function CheckPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
        {
            super(propertyRetriever, param);

            _check = new Check();

            _check.addEventListener(Event.CHANGE, function(event):void{
                _oldValue = _propertyRetriever.get(_param.name);
                _propertyRetriever.set(_param.name, _check.isSelected);

                setChanged();
            });

            _check.isSelected = _propertyRetriever.get(_param.name);

            addChild(_check);
        }

        override public function update():void
        {
            _check.isSelected = _propertyRetriever.get(_param.name);
        }


    }
}
