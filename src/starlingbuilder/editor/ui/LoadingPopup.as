/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.ProgressBar;

    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class LoadingPopup extends InfoPopup
    {
        private var _progressBar:ProgressBar;

        public function LoadingPopup()
        {
            super();
            title = "Loading";
        }

        override protected function createContent(container:LayoutGroup):void
        {
            _progressBar = new ProgressBar();
            container.addChild(_progressBar);
        }

        public function set ratio(value:Number):void
        {
            _progressBar.value = value;
        }

        public function get ratio():Number
        {
            return _progressBar.value;
        }
    }
}
