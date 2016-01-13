/**
 * Created by hyh on 1/3/16.
 */
package starlingbuilder.editor
{
    [SWF(frameRate=60, width=1300, height=960, backgroundColor="#000")]
    public class MainCI extends Main
    {
        public function MainCI()
        {
            super();
        }

        override protected function getApp():Class
        {
            return UIEditorAppCI;
        }
    }
}
