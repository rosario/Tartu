/*
* Copyright (c) 2014 Neil North.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import SpriteKit

class Layer: SKNode {
  
  var layerVelocity = CGPointZero
  
  //MARK: Loop
  func update(delta:CFTimeInterval,affectAllNodes:Bool,parallax:Bool) {

    updateLayer(delta)
    
    if affectAllNodes {
      for (childNumber, child) in children.enumerate() {
        if parallax {
          updateNodesParallax(delta, childNumber: childNumber, childNode: child )
        } else {
          updateNodes(delta, childNumber: childNumber,childNode: child)
        }
      }
    }
    
  }
  
  func updateNodes(delta:CFTimeInterval,childNumber:Int,childNode:SKNode) {
    
    // Overridden by subclasses
    
  }
  
  func updateNodesParallax(delta:CFTimeInterval,childNumber:Int,childNode:SKNode) {
    let offset = layerVelocity  * CGFloat(delta)
    childNode.position += offset
    updateNodes(delta, childNumber: childNumber, childNode: childNode)
  }
  
  func updateLayer(delta:CFTimeInterval) {
    
    // Overridden by subclasses
    
  }
  
  
}
