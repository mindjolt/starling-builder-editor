/**
 * Created by hyh on 1/31/16.
 */
package starlingbuilder.util.history
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class HistoryManagerTest
    {
        private var _historyManager:HistoryManager;
        private var _target:Object;

        [Before]
        public function setup():void
        {
            _historyManager = new HistoryManager();
            _target = {value:0};
        }

        private function doOperation():void
        {
            _target.value += 1;
            _historyManager.add(new MockHistoryOperation(_target));
        }

        private function doCanMergeOperation():void
        {
            _target.value += 1;
            var op:MockHistoryOperation = new MockHistoryOperation(_target);
            op.expects("canMergeWith").willReturn(true);
            _historyManager.add(op);
        }

        [Test]
        public function shouldUndoAndRedo():void
        {
            doOperation();
            assertEquals(_target.value, 1);
            doOperation();
            assertEquals(_target.value, 2);

            _historyManager.undo();
            assertEquals(_target.value, 1);
            _historyManager.undo();
            assertEquals(_target.value, 0);

            _historyManager.redo();
            assertEquals(_target.value, 1);
            _historyManager.undo();
            assertEquals(_target.value, 0);

            _historyManager.redo();
            assertEquals(_target.value, 1);
            _historyManager.redo();
            assertEquals(_target.value, 2);
        }

        [Test]
        public function testUndoableAndRedoable():void
        {
            assertTrue(_historyManager.undoable() == false);
            assertTrue(_historyManager.redoable() == false);

            doOperation();

            assertTrue(_historyManager.undoable() == true);
            assertTrue(_historyManager.redoable() == false);

            _historyManager.undo();

            assertTrue(_historyManager.undoable() == false);
            assertTrue(_historyManager.redoable() == true);

            _historyManager.redo();

            assertTrue(_historyManager.undoable() == true);
            assertTrue(_historyManager.redoable() == false);
        }


        [Test]
        public function shouldMergeOperationCorrectly():void
        {
            doOperation();
            doCanMergeOperation();
            assertEquals(_historyManager.numOperations, 1);
        }

        [Test]
        public function shouldCutOffHistoryInTheMiddle():void
        {
            doOperation();
            doOperation();

            _historyManager.undo();
            _historyManager.undo();

            assertEquals(_historyManager.numOperations, 2);

            doOperation();

            assertEquals(_historyManager.numOperations, 1);
        }

        [Test]
        public function shouldCutOffHistoryWhenExceedMax():void
        {
            _historyManager = new HistoryManager(2);

            doOperation();
            doOperation();
            doOperation();

            assertEquals(_target.value, 3);
            assertEquals(_historyManager.numOperations, 2);

            _historyManager.undo();
            _historyManager.undo();
            _historyManager.undo();

            assertEquals(_target.value, 1);
            assertEquals(_historyManager.numOperations, 2);
        }
    }
}
