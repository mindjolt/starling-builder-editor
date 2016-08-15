/**
 * Created by hyh on 1/14/16.
 */
package starlingbuilder.editor
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class CITestManager
    {
        private var _queue:Array;
        private var _timer:Timer;
        private var _index:int;

        public function CITestManager(timeInterval:Number = 500)
        {
            _queue = new Array();

            _timer = new Timer(timeInterval);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
            _timer.start();
        }

        public function add(...operations):void
        {
            for each (var operation:* in operations)
            {
                if (operation is Array)
                {
                    _queue.push.apply(this, operation);
                }
                else
                {
                    _queue.push(operation);
                }
            }
        }

        public function start():void
        {
            if (!_timer.running)
            {
                _index = 0;
                _timer.start();
            }
        }

        public function stop():void
        {
            _timer.stop();
            _index = 0;
        }


        public function reset():void
        {
            _timer.stop();
            _queue.length = 0;
        }

        private function onTimer(event:TimerEvent):void
        {
            if (_index < _queue.length)
            {
                _queue[_index]();
                ++_index;
            }
            else
            {
                _timer.stop();
            }
        }

        public function running():Boolean
        {
            return _timer.running;
        }
    }
}
