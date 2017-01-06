//
//  Timer+CYBlock.swift
//  SDClientsPlatformSwift
//
//  Created by Peter Lee on 2016/12/23.
//  Copyright © 2016年 ZTESoft. All rights reserved.
//

import Foundation

extension Timer {

    static func cy_scheduledTimer(withTimeInterval interval: TimeInterval, repeats:Bool, block:(Timer)->()) -> Timer {
        return self.scheduledTimer(timeInterval: interval, target: self, selector: #selector(Timer.cy_timerBlock(_:)), userInfo: block, repeats: repeats)
    }
    
    @objc static func cy_timerBlock(_ timer:Timer) {
        
        let block:((Timer)->())? = timer.userInfo as? (Timer)->()
        if block != nil {
            block!(timer)
        }
        
    }
}
