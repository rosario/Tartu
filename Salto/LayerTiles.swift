//
//  LayerTiles.swift
//  Salto
//
//  Created by Rosario Rascuna on 09/11/2015.
//  Copyright (c) 2015 Cirneco. All rights reserved.
//

import SpriteKit

let TileSize = CGSize(width: 20, height: 20)

class LayerTiles:Layer {
    let tileSize:CGSize
    let gridSize:CGSize
    let layerSize:CGSize
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tileSize: CGSize, gridSize: CGSize, layerSize: CGSize? = nil) {
        self.tileSize = tileSize
        self.gridSize = gridSize
        if layerSize != nil {
            self.layerSize = layerSize!
        } else {
            self.layerSize = CGSize(
                width: tileSize.width * gridSize.width,
                height: tileSize.height * gridSize.height)
        }
        super.init()
    }
    
    
    func objectSize(object:NSDictionary) -> CGSize? {
        let w = object.objectForKey("width") as! String
        let h = object.objectForKey("height") as! String
        var size:CGSize?
        if let
            width = NSNumberFormatter().numberFromString(w),
            height = NSNumberFormatter().numberFromString(h) {
                size = CGSize(width: Double(width), height: Double(height))
        }
        return size
    }
    
    func objectPoint(object:NSDictionary) -> CGPoint? {
        var point:CGPoint?
        if let offsetX = object.objectForKey("x") as? CGFloat,
            offsetY = object.objectForKey("y") as? CGFloat {
                point = CGPoint(x:offsetX, y:offsetY)
        }
        return point
    }
    
    func objectPolyline(object:NSDictionary) -> String? {
        let polyline = object.objectForKey("polylinePoints") as! String
        return polyline
    }

    func objectName(object:NSDictionary) -> String? {
        if let name = object.objectForKey("name") as? String {
            return name
        } else {
            return nil
        }
    }

    
}

