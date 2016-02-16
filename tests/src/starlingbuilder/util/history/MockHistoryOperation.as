/**
 * Created by hyh on 1/31/16.
 */
package starlingbuilder.util.history
{
    import org.mock4as.Mock;

    public class MockHistoryOperation extends Mock implements IHistoryOperation
    {
        private var _target:Object;

        public function MockHistoryOperation(target:Object)
        {
            _target = target;
        }

        public function get type():String
        {
            return "Test";
        }

        public function get timestamp():Number
        {
            record("timestamp");
            return expectedReturnFor();
        }

        public function get beforeValue():Object
        {
            record("beforeValue");
            return expectedReturnFor();
        }

        public function canMergeWith(previousOperation:IHistoryOperation):Boolean
        {
            record("canMergeWith", previousOperation);
            return expectedReturnFor();
        }

        public function merge(previousOperation:IHistoryOperation):void
        {
            record("merge", previousOperation);
        }

        public function redo():void
        {
            _target.value += 1;
        }

        public function undo():void
        {
            _target.value -= 1;
        }

        public function info():String
        {
            return "info";
        }

        public function dispose():void
        {
            record("dispose");
        }
    }
}
