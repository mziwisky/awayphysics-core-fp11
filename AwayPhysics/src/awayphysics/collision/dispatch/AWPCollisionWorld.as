package awayphysics.collision.dispatch {
	import flash.utils.Dictionary;
	
	import AWPC_Run.addCollisionObjectInC;
	import AWPC_Run.contactTestInC;
	import AWPC_Run.removeCollisionObjectInC;
	
	import awayphysics.AWPBase;
	import awayphysics.collision.dispatch.AWPCollisionObject;
		
	public class AWPCollisionWorld extends AWPBase{
		
		protected var m_collisionObjects:Dictionary;
		
		public function AWPCollisionWorld(){
			m_collisionObjects =  new Dictionary(true);
		}
		
		public function get collisionObjects() : Dictionary {
			return m_collisionObjects;
		}
		
		/**
		 * add a collisionObject to collision world
		 */
		public function addCollisionObject(obj:AWPCollisionObject, group:int = 1, mask:int = -1):void{
			if(!m_collisionObjects.hasOwnProperty(obj.pointer.toString())){
				m_collisionObjects[obj.pointer.toString()] = obj;
				addCollisionObjectInC(obj.pointer, group, mask);
			}
		}
		
		/**
		 * remove a collisionObject from collision world, if cleanup is true, release pointer in memory.
		 */
		public function removeCollisionObject(obj:AWPCollisionObject, cleanup:Boolean = false) : void {			
			if(m_collisionObjects.hasOwnProperty(obj.pointer.toString())){
				delete m_collisionObjects[obj.pointer.toString()];
				removeCollisionObjectInC(obj.pointer);
				
				if (cleanup) {
					obj.dispose();
				}
			}
		}
		
		/**
		 * Return a Vector of all collisionObjects that are currently contacting the passed in collisionObject.
		 */
		public function contactTest(obj:AWPCollisionObject): Vector.<AWPCollisionObject> {
			var ptrs: Vector.<uint> = contactTestInC(obj.pointer);
			if (!ptrs) return null;
			else {
				var hits: Vector.<AWPCollisionObject> = new Vector.<AWPCollisionObject>(ptrs.length);
				for (var i:int = 0; i < ptrs.length; i++) {
					hits[i] = m_collisionObjects[ptrs[i].toString()];
				}
				return hits;
			}
		}
	}
}