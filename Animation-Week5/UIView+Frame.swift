//
//  UIView+Frame.swift
//  swift-UI
//
//  Created by GM on 15/1/4.
//  Copyright © 2015年 LGM. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    var x : CGFloat {
        set{
            self.frame = CGRectMake(newValue, self.y, self.width, self.height)
        }
        get{
            return self.frame.origin.x
        }
    }

    var y : CGFloat {
        set{
            self.frame = CGRectMake(self.x, newValue, self.width, self.height)
        }
        get{
            return self.frame.origin.y;
        }
    }

    var width : CGFloat{

        set {
            self.frame = CGRectMake(self.x, self.y, newValue, self.height)
        }
        get{
            return self.frame.size.width
        }
    }

    var height : CGFloat{
        set{
            self.frame = CGRectMake(self.x, self.y, self.width, newValue)
        }
        get{
            return self.frame.size.height
        }
    }

    var left : CGFloat{
        set{
            self.x = newValue
        }
        get{
            return self.x
        }
    }

    var right : CGFloat{
        set{
            self.x = newValue - self.width
        }
        get{
            return self.x + self.width
        }
    }
    var top : CGFloat{
        set{
            self.y = newValue;
        }
        get{
            return self.y
        }
    }
    var bottom : CGFloat{
        set{
            self.y = newValue - self.height
        }
        get{
            return self.y + self.height
        }
    }

    var centerX : CGFloat {
        set{
            self.center = CGPointMake(newValue, self.center.y)
        }
        get{
            return self.center.x
        }
    }

    var centerY : CGFloat {

        set{
            self.center = CGPointMake(self.center.x, newValue)
        }
        get{
            return self.center.y
        }
    }
}
