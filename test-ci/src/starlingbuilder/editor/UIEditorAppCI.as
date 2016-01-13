/**
 * Created by hyh on 1/3/16.
 */
package starlingbuilder.editor
{
    import starling.display.Sprite;

    public class UIEditorAppCI extends UIEditorApp
    {
        public function UIEditorAppCI()
        {
            super();
        }

        override protected function createEditorScreen():Sprite
        {
            return new UIEditorScreenCI();
        }
    }
}
