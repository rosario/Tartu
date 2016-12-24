import SpriteKit

class LayerWorld:LayerTiles {

    var tileMap:JSTileMap? = nil
    
    override func updateLayer(delta: CFTimeInterval) {
        let offset = layerVelocity  * CGFloat(delta)
        if tileMap != nil {
            tileMap!.position += offset
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addTileMap(filename:String) {
        tileMap = JSTileMap(named: filename)
        if tileMap != nil {

            tileMap!.name = "tileMap"
            let mapBounds = tileMap!.calculateAccumulatedFrame()
            
            addGroup("walls", tilemap: tileMap!) { wall in
                if let point = self.objectPoint(wall), size = self.objectSize(wall){
                    self.tileMap!.addChild(Wall(offset: point, size: size))
                }
            }
            
            addGroup("spikes", tilemap: tileMap!) { spike in
                if let point = self.objectPoint(spike), size = self.objectSize(spike){
                    self.tileMap!.addChild(Spike(offset: point, size: size))
                }
            }
                        
            
            addGroup("triggers", tilemap:  tileMap!) {trigger in
                if let point = self.objectPoint(trigger), polyline = self.objectPolyline(trigger){
                        if let name = self.objectName(trigger) {
                            if name == "completed" {
                                self.tileMap!.addChild(Trigger(offset: point, polyline: polyline, name:name))
                            }
                        } else {
                            self.tileMap!.addChild(Edge(offset: point, polyline: polyline))
                        }
                }
                
            }
            
            addChild(tileMap!)
        }
    
    }
    
    
    init(tileSize: CGSize, gridSize: CGSize) {
        super.init(tileSize: tileSize, gridSize: gridSize)
    }
    
    func resetMap(){
        if tileMap != nil {
            tileMap!.position = CGPoint.zero
        }
    }
    
    func removeEnemies(map:JSTileMap){
        // tileMap also contains enemies sprite. I'll remove those
        map.enumerateChildNodesWithName("enemy-*") { node, stop in
            let sprite = node as! SKSpriteNode
            sprite.removeFromParent()
        }
    }
        
    func addGroup(name:String, tilemap:JSTileMap, callback:(NSDictionary)-> ()) {
        let group = tilemap.groupNamed(name)
        if group != nil {
            for object:AnyObject in group.objects {
                if let element = object as? NSDictionary {
                    callback(element)
                }
            }
        }
    }
}


