/**
 * Created by hyh on 1/3/16.
 */
package starlingbuilder.editor
{
    import flash.ui.Keyboard;

    import org.flexunit.asserts.assertEquals;

    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.KeyboardEvent;

    import starlingbuilder.editor.citestcase.BasicTest;
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class UIEditorScreenCI extends UIEditorScreen
    {
        private var _testManager:CITestManager;

        public function UIEditorScreenCI()
        {
            super();
            _testManager = new CITestManager(100);

            var stage:Stage = Starling.current.stage;
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        override protected function initTests():void
        {
            _testManager.add(BasicTest.INTERACTION);
            _testManager.add(BasicTest.COMPONENT1);
            _testManager.add(BasicTest.COMPONENT2);
            _testManager.add(BasicTest.COMPONENT3);
            _testManager.add(function():void{
                InfoPopup.show("CI Test Complete.")
            })
            _testManager.start();
        }

        private function onKeyUp(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.T)
            {
                _testManager.start();
            }

            if (event.keyCode == Keyboard.R)
            {
                _testManager.reset();
            }
        }
    }
}
