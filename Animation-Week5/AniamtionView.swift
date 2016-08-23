//
//  AniamtionView.swift
//  Animation-Week5
//
//  Created by GM on 16/8/22.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit
/**
 *  这个动画由三个点以及一段曲线来构成
 *  3个点分别是左（A）右(B)两个固定的点  以及在圆弧上滑动的动态变化的点(O)
 *  第一个阶段：点O在上半圆弧滑动并控制 点A、点B的隐藏
 *  第二个阶段：动态绘制下半边的圆弧，同时改变速率，隐藏点O
 *  第三个阶段：当圆弧达到一定的弧度后，圆弧滚动，此时控制点A，点B的隐藏
 *  动画的速率通过displayLink的frameInterval属性来控制
 *  坐标系是根据贝塞尔曲线所画圆弧而定的
 */
enum AnimationStage : Int {
    case StageOne,StageTwo,StageThree
}

class AniamtionView: UIView {

    var animationStage : AnimationStage = .StageOne                         //动画所在阶段
    let color = UIColor.redColor()
    var leftPoint : UIView?
    var rightPoint : UIView?
    var movePoint : UIView?
    var displayLink : CADisplayLink?
    var shapesLayer = CAShapeLayer()

    //所用到的关键值
    let lineWid : CGFloat = 10                                              //弧线的宽度，以及原点的直径
    var moveStartAngle : CGFloat = CGFloat(M_PI) - (CGFloat(M_PI) / 12)     //点O的起止弧度
    let degreeOffset : CGFloat = CGFloat(M_PI) / 12                         //弧度偏移量
    let leftDegree = CGFloat(M_PI) + CGFloat(M_PI_4)                        //点A、B的真是弧度
    let rigthDegree = CGFloat(M_PI) * 2 - CGFloat(M_PI_4)
    let pointDegree : CGFloat = CGFloat(M_PI_4)                             //点A、点B所在圆上于X轴的夹角弧度，并不是真实弧度

    var startAngle : CGFloat  = CGFloat(M_PI) / 15                          //圆弧起止弧度
    var endAngle : CGFloat {
        get{
            return CGFloat(M_PI) - startAngle
        }
    }
    var r : CGFloat {                                                       //半径
        get{
            if self.width >= self.height {
                return self.height / 2
            }else{
                return self.width / 2
            }
        }
    }
    var commonPointY : CGFloat {
        get{
            return sin(pointDegree) * r
        }
    }
    var distanceX : CGFloat {                                               //点A、B距离原点的长度
        get{
            return cos(pointDegree) * r
        }
    }
    var movePointCenter : CGPoint {
        get{
            return CGPointMake(r + cos(moveStartAngle) * r, r + sin(moveStartAngle) * r)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.displayLink = CADisplayLink(target : self,selector: #selector(AniamtionView.displayAction))
        self.displayLink!.frameInterval = 3
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        self.config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(){

        self.backgroundColor = UIColor.clearColor()
        leftPoint = UIView()
        leftPoint?.frame = CGRectMake(0, 0, lineWid, lineWid)
        leftPoint?.center = CGPointMake(r - distanceX, r - commonPointY)
        leftPoint?.layer.cornerRadius = lineWid / 2
        leftPoint?.layer.masksToBounds = true
        leftPoint?.backgroundColor = color
        self.addSubview(leftPoint!)

        rightPoint = UIView()
        rightPoint?.frame = CGRectMake(0, 0, lineWid, lineWid)
        rightPoint?.center = CGPointMake(r + distanceX, r - commonPointY)
        rightPoint?.layer.cornerRadius = lineWid / 2
        rightPoint?.layer.masksToBounds = true
        rightPoint?.backgroundColor = color
        self.addSubview(rightPoint!)


        movePoint = UIView()
        movePoint?.frame = CGRectMake(0, 0, lineWid, lineWid)
        movePoint?.layer.cornerRadius = lineWid / 2
        movePoint?.layer.masksToBounds = true
        movePoint?.backgroundColor = self.color
        movePoint?.hidden = true
        self.addSubview(movePoint!)

        self.displayLink?.paused = true
        addCircleLayer(startAngle,endAngle: endAngle)
    }

    //displayLink回调
    func displayAction(){

        if moveStartAngle >= CGFloat(M_PI) * 2 {
            moveStartAngle = 0
        }
        switch self.animationStage {
        case .StageOne:
            moveStartAngle = moveStartAngle + degreeOffset
            self.oneStage()
        case .StageTwo:
            moveStartAngle = moveStartAngle + degreeOffset
            self.twoStage()
        case .StageThree:
            self.threeStage()
        }
    }

    //第一步先以此画出3个圆点
    func oneStage(){

        self.displayLink?.frameInterval = 3

        self.movePoint?.center = movePointCenter
        if moveStartAngle >=  rigthDegree - degreeOffset && moveStartAngle <= rigthDegree + degreeOffset{
            //与右边的点相遇
            rightPoint?.hidden = false
        }
        if moveStartAngle >= leftDegree - degreeOffset && moveStartAngle <= leftDegree + degreeOffset{
            //与左边的点相遇
            leftPoint?.hidden = false
        }
        if moveStartAngle >= startAngle && moveStartAngle <= startAngle + degreeOffset{
            //第一阶段完成
            movePoint?.hidden = true
            self.animationStage = .StageTwo
        }
    }
    //第二步 画弧线
    func twoStage(){
        self.displayLink?.frameInterval = 2
        addCircleLayer(startAngle,endAngle: moveStartAngle)
        if moveStartAngle >= endAngle - degreeOffset && moveStartAngle < endAngle + degreeOffset {
            self.animationStage = .StageThree
        }
    }

    func addCircleLayer(startAngle: CGFloat, endAngle : CGFloat){

        shapesLayer.frame = self.bounds
        let path = UIBezierPath(arcCenter : CGPointMake(self.width / 2, self.height / 2),radius:self.width / 2,startAngle:startAngle,endAngle:endAngle,clockwise:true)
        path.lineWidth = self.lineWid
        shapesLayer.path = path.CGPath
        shapesLayer.fillColor = UIColor.clearColor().CGColor
        shapesLayer.strokeColor = self.color.CGColor
        shapesLayer.lineWidth = self.lineWid
        shapesLayer.lineCap = "round"
        self.layer.addSublayer(shapesLayer)
    }
    //第三步 弧线把原点带走 且弧线慢慢变短
    func threeStage(){
        self.displayLink?.frameInterval = 1
        if startAngle > CGFloat(M_PI) * 2{
            startAngle = 0
        }
        startAngle = startAngle + degreeOffset
        addCircleLayer(startAngle,endAngle: moveStartAngle)

        if moveStartAngle >=  rigthDegree - degreeOffset && moveStartAngle <= rigthDegree + degreeOffset{
            //与右边的点相遇
            rightPoint?.hidden = true
        }
        if moveStartAngle >= leftDegree - degreeOffset && moveStartAngle <= leftDegree + degreeOffset{
            //与左边的点相遇
            leftPoint?.hidden = true
        }

        if moveStartAngle >= CGFloat(M_PI) / 2 - degreeOffset && moveStartAngle <= CGFloat(M_PI) / 2 + degreeOffset{
            self.displayLink?.frameInterval = 2
            if startAngle >= CGFloat(M_PI) / 2 - degreeOffset && startAngle <= CGFloat(M_PI) / 2 + degreeOffset {
                self.displayLink?.paused = true
                self.reset()
            }
        }else{
            moveStartAngle = moveStartAngle + degreeOffset
        }
    }

    func startAniamtion(){

        rightPoint?.hidden = true
        leftPoint?.hidden = true
        movePoint?.hidden = false
        startAngle = CGFloat(M_PI) / 12
        self.animationStage = .StageOne
        moveStartAngle = CGFloat(M_PI) - (CGFloat(M_PI) / 12)
        shapesLayer.path = nil
        self.displayLink?.paused = false
    }
    func reset(){

        rightPoint?.hidden = false
        leftPoint?.hidden = false
        movePoint?.hidden = true
        startAngle = CGFloat(M_PI) / 12
        addCircleLayer(startAngle,endAngle: endAngle)
        self.alpha = 0
        UIView.animateWithDuration(0.5, animations: { 
            self.alpha = 1
            }) { (finish) in
                self.startAniamtion()
        }
    }
}

