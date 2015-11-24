/**
 * Created by hyh on 11/23/15.
 */
package com.sgn.tools.util.pool
{
    import flash.utils.Dictionary;

    public class ObjectPoolFactory
    {
        private const POOL_SIZE:int = 10000;

        private var _pool:Dictionary;

        private static var _instance:ObjectPoolFactory;

        public static function get instance():ObjectPoolFactory
        {
            if (_instance == null)
            {
                _instance = new ObjectPoolFactory();
            }

            return _instance;
        }

        public function ObjectPoolFactory()
        {
            _pool = new Dictionary();
        }

        public function recycleObject(obj:IPoolable):void
        {
            //trace("Checking in..");

            var cls:Class = Object(obj).constructor;

            var pool:Array = _pool[cls];

            if (pool.length < POOL_SIZE)
            {
                obj.recycle();
                pool.push(obj);
            }
            else
            {
                obj.dispose();

                //trace("Disposing one");
            }
        }

        public function getObject(cls:Class, args:Array = null):Object
        {
            if (_pool[cls] == null)
            {
                _pool[cls] = new Array();
            }

            var pool:Array = _pool[cls];

            var obj:Object;

            if (pool.length > 0)
            {
                obj = pool.pop();

                //trace("Checking out..");
            }
            else
            {
                //Let's enforced every class to have an empty constructor, since all the work can be done in init
                obj = new cls();

                //trace("Creating one");
            }

            obj.init(args);

            return obj;
        }






    }
}
