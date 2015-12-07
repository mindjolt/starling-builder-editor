package com.sgn.tools.util.ui.inspector
{

import com.sgn.starlingbuilder.editor.data.EmbeddedData;

import feathers.controls.Label;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ScrollableLabelPropertyComponent extends BasePropertyComponent
{
    protected var _label:Label;

    public function ScrollableLabelPropertyComponent(propertyRetriever:IPropertyRetriever, param:Object)
    {
        super(propertyRetriever, param);

        _label = new Label();
        _label.width = 70;
        _label.text = _param.name;

        _label.addEventListener(TouchEvent.TOUCH, onTouch);

        addChild(_label);
    }

    private function onTouch(event:TouchEvent):void
    {
        var touch:Touch = event.getTouch(_label);
        if (touch)
        {
            switch (touch.phase)
            {
                case TouchPhase.HOVER:
                    Mouse.cursor = EmbeddedData.HORIZONTAL_ARROWS;
                    break;

                case TouchPhase.MOVED:
                    _oldValue = _propertyRetriever.get(_param.name);
                    _propertyRetriever.set(_param.name, _oldValue + touch.getMovement(_label).x);
                    setChanged();
                    break;

                case TouchPhase.ENDED:
                    Mouse.cursor = MouseCursor.AUTO;
                    break;
            }
        }
        else
        {
            Mouse.cursor = MouseCursor.AUTO;
        }
    }

    override public function dispose():void
    {
        _label.removeEventListener(TouchEvent.TOUCH, onTouch);

        super.dispose();
    }
}
}
