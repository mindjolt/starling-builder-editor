/**
 * Created by hyh on 1/3/16.
 */
package starlingbuilder.editor
{
    import flash.ui.Keyboard;
    import flash.utils.getTimer;

    import org.flexunit.asserts.assertEquals;

    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.KeyboardEvent;

    import starlingbuilder.editor.citestcase.BackgroundTest;

    import starlingbuilder.editor.citestcase.BasicTest;
    import starlingbuilder.editor.citestcase.DocumentTest;
    import starlingbuilder.editor.citestcase.GroupTest;
    import starlingbuilder.editor.citestcase.InspectorTest;
    import starlingbuilder.editor.citestcase.LayoutTest;
    import starlingbuilder.editor.citestcase.LocalizationTest;
    import starlingbuilder.editor.citestcase.SelectionTest;
    import starlingbuilder.editor.citestcase.TweenTest;
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
            var t:Number = getTimer();

            _testManager.add(BasicTest.INTERACTION);
            _testManager.add(BasicTest.COMPONENT1);
            _testManager.add(BasicTest.COMPONENT2);
            _testManager.add(BasicTest.COMPONENT3);
            _testManager.add(BasicTest.FILTERS);
            _testManager.add(BackgroundTest.BACKGROUND);
            _testManager.add(LayoutTest.LAYOUTS);
            _testManager.add(LayoutTest.ANCHOR_LAYOUT);
            _testManager.add(DocumentTest.DRAG_DROP);
            _testManager.add(DocumentTest.OPERATIONS);
            _testManager.add(LocalizationTest.LOCALIZE);
            _testManager.add(TweenTest.TWEEN);
            _testManager.add(InspectorTest.TEST);
            _testManager.add(SelectionTest.SELECTION);
            _testManager.add(GroupTest.GROUP);
            _testManager.add(function():void{
                InfoPopup.show("Functional Test Complete.");
                trace("Time: ", getTimer() - t);
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
                _testManager.stop();
            }
        }
    }
}
