/**
 * Created by hyh on 12/7/15.
 */
package com.sgn.tools.util.ui.list
{
    import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;

    import starling.display.DisplayObject;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class ExpandableGroupListHeaderRenderer extends DefaultGroupedListHeaderOrFooterRenderer
    {
        public function ExpandableGroupListHeaderRenderer()
        {
            super();

            addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(event.target as DisplayObject);

            if (touch && touch.phase == TouchPhase.ENDED)
            {
                this.owner.dispatchEventWith(ExpandableGroupedList.HEADER_TRIGGER, false, _data.label);
            }
        }

        override public function dispose():void
        {
            removeEventListener(TouchEvent.TOUCH, onTouch);

            super.dispose();
        }
    }
}
