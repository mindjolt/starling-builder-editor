/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class ComponentHelpButton extends Sprite
    {
        [Embed(source="question_mark.png")]
        public static const question_mark:Class;

        public static var question_mark_texture:Texture;

        public static const STARLING_BASE_URL:String = "http://doc.starling-framework.org/current/"
        public static const FEATHERS_BASE_URL:String = "http://feathersui.com/api-reference/";

        private var _button:Button;
        private var _url:String;

        public function ComponentHelpButton()
        {
            super();

            if (question_mark_texture == null) question_mark_texture = Texture.fromBitmap(new question_mark());
            _button = new Button(question_mark_texture);
            _button.scaleX = _button.scaleY = 0.5;
            _button.addEventListener(Event.TRIGGERED, onHelp);
            addChild(_button);
            visible = false;
        }

        public function set clsName(value:String):void
        {
            url = getLibraryUrl(value);
        }

        public function set url(value:String):void
        {
            _url = value;

            if (_url == null || _url == "")
                visible = false;
            else
                visible = true;
        }

        private function getLibraryUrl(clsName:String):String
        {
            clsName = clsName.replace(/\./g, "/");

            if (clsName.substr(0, 9) == "starling/")
            {
                return STARLING_BASE_URL + clsName + ".html";
            }
            else if (clsName.substr(0, 9) == "feathers/")
            {
                return FEATHERS_BASE_URL + clsName + ".html";
            }
            else
            {
                return null;
            }
        }

        private function onHelp(event:Event):void
        {
            if (_url)
                navigateToURL(new URLRequest(_url));
        }
    }
}
