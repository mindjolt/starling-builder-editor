/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    public class LeftPanel extends TabPanel
    {
        public function LeftPanel()
        {
            super();

            createTabs([{"label":"layout"}, {"label":"asset"}, {"label":"text"}, {"label":"container"}, {"label":"feathers"}, {"label":"bg"}], [new LayoutTab(), new AssetTab(), new TextTab(), new ContainerTab(), new FeathersTab(), new BackgroundTab()]);
        }
    }
}
