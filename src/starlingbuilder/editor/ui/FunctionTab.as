/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.TextInput;
    import feathers.layout.VerticalLayout;

    import flash.utils.getDefinitionByName;

    import starling.events.Event;

    public class FunctionTab extends LayoutGroup
    {
        public function FunctionTab()
        {
            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = 10;

            this.layout = layout;

            var clsInput:TextInput = new TextInput();
            clsInput.text = "Math";

            var functionInput:TextInput = new TextInput();
            functionInput.text = "abs";

            var paramsInput:TextInput = new TextInput();
            paramsInput.text = "[-1]";

            var button:Button = FeathersUIUtil.buttonWithLabel("calculate", onCalculate);

            var resultLabel:Label = FeathersUIUtil.labelWithText("");

            addChild(clsInput);
            addChild(functionInput)
            addChild(paramsInput);
            addChild(button);
            addChild(resultLabel);

            function onCalculate(event:Event):void
            {
                var cls:Class = getDefinitionByName(clsInput.text) as Class;
                var func:Function = cls[functionInput.text];
                var params:Array = JSON.parse(paramsInput.text) as Array;

                if (cls && func && params)
                {
                    var result:Object = func.apply(null, params)
                    resultLabel.text = JSON.stringify(result);
                }

            }
        }
    }
}
