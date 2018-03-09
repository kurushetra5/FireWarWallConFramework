//
//  ViewController.swift
//  Kuru_Threads-timers-Task
//
//  Created by Kurushetra on 28/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//


import Cocoa

class ViewController: NSViewController {

    
    
    var netStatQueues:NetStatQueues = NetStatQueues()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        testPrintMethods()
//        queueTest2()
//         blockOperationsTest1()
//        sampleCodeOne()
//        netstat()
        queueTest7()
    }
    
    func netstat() {
        netStatQueues.getFireWallState { (state) in
            print(state)
        }
    }
    
    
    
    
    
    //The below methods prints the thread on which they are being executed Main Thread or Background?
    func printApples(){
        print("printApples is running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        for i in 0..<3{
            print("🍏\(i)")
        }
    }
    
    func printStrawberries(){
        print("printStrawberries is running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        for i in 0..<3{
            print("🍓\(i)")
        }
    }
    
    func printBalls(){
        print("printBalls is running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        for i in 0..<3{
            print("🎱\(i)")
        }
    }
    
    
    
    
    /* Output
     printApples running on = Main Thread
     🍏0
     🍏1
     🍏2
     printStrawberries running on = Main Thread
     🍓0
     🍓1
     🍓2
     printBalls running on = Main Thread
     🎱0
     🎱1
     🎱2
     */
    func testPrintMethods() {
        printApples()
        printStrawberries()
        printBalls()
    }
    
    
    
    
    
    
    
    /* Output - Note all the methods are running in the background thread, but as the same queue is being used they are running in serial.
     printApples is running on = Background Thread
     🍏0
     🍏1
     🍏2
     printStrawberries is running on = Background Thread
     🍓0
     🍓1
     🍓2
     printBalls is running on = Background Thread
     🎱0
     🎱1
     🎱2
     */
    func queueTest1() {
        let queue = DispatchQueue(label: "com.knowstack.queue1")
        queue.async {
            self.printApples()
        }
        queue.async {
            self.printStrawberries()
        }
        queue.async {
            self.printBalls()
        }
        
    }
    
    
    
    
    
    /*
     Output - All the tasks are running in parallel
     printStrawberries is running on = Background Thread
     printApples is running on = Background Thread
     printBalls is running on = Background Thread
     🎱0
     🍓0
     🍏0
     🎱1
     🍓1
     🍏1
     🎱2
     🍓2
     🍏2
     */
    
    func queueTest2(){
        let queue1 = DispatchQueue(label: "com.knowstack.queue1")
        let queue2 = DispatchQueue(label: "com.knowstack.queue2")
        let queue3 = DispatchQueue(label: "com.knowstack.queue3")
        queue1.async {
            self.printApples()
        }
        queue2.async {
            self.printStrawberries()
        }
        queue3.async {
            self.printBalls()
        }
        
    }
    
    
    /*
     Output
     printApples is running on = Main Thread
     🍏0
     🍏1
     🍏2
     printStrawberries is running on = Background Thread
     printBalls is running on = Background Thread
     🍓0
     🎱0
     🍓1
     🎱1
     🍓2
     🎱2
     */
    
    func queueTest3() {
        let queue1 = DispatchQueue(label: "com.knowstack.queue1")
        let queue2 = DispatchQueue(label: "com.knowstack.queue2")
        let queue3 = DispatchQueue(label: "com.knowstack.queue3")
        queue1.sync {
            self.printApples()
        }
        queue2.async {
            self.printStrawberries()
        }
        queue3.async {
            self.printBalls()
        }
    }
    
    
    
    
    /* Output - When we are using a global queue we can see that the three different tasks are running in parallel
     printStrawberries is running on = Background Thread
     printApples is running on = Background Thread
     printBalls is running on = Background Thread
     🍓0
     🍏0
     🎱0
     🍓1
     🍏1
     🎱1
     🍓2
     🍏2
     🎱2
     */
    func queueTest4(){
        let globalQueue = DispatchQueue.global()
        globalQueue.async {
            self.printApples()
        }
        globalQueue.async {
            self.printStrawberries()
        }
        globalQueue.async {
            self.printBalls()
        }
        
    }
    
    
    
    /*Output
     printApples is running on = Main Thread
     🍏0
     🍏1
     🍏2
     printStrawberries is running on = Background Thread
     printBalls is running on = Background Thread
     🍓0
     🎱0
     🍓1
     🎱1
     🍓2
     🎱2
     */
    func queueTest5(){
        let globalQueue = DispatchQueue.global()
        globalQueue.sync {
            self.printApples()
        }
        globalQueue.async {
            self.printStrawberries()
        }
        globalQueue.async {
            self.printBalls()
        }
        
    }
    
    
    //In the above sample, as all the tasks are running on the main thread
    /* Output
     printApples is running on = Main Thread
     🍏0
     🍏1
     🍏2
     printStrawberries is running on = Main Thread
     🍓0
     🍓1
     🍓2
     printBalls is running on = Main Thread
     🎱0
     🎱1
     🎱2
     */
    
    func queueTest6(){
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            self.printApples()
        }
        
        mainQueue.async {
            self.printStrawberries()
        }
        mainQueue.async {
            self.printBalls()
        }
    }
    
    
    
    
    
    
    /*
     Output - In the above sample. The thread priority or quality of service plays a key role as User Interactive is of highest priority and although both the queues are configured to run on the background thread, the print strawberries completes faster
     printStrawberries is running on = Background Thread
     printBalls is running on = Background Thread
     🍓0
     🍓1
     🍓2
     🎱0
     🎱1
     🎱2
     */
    
    func queueTest7(){
        let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        queue1.async {
//            self.printStrawberries()
             
        }
        queue2.async {
            self.printBalls()
            
        }
        
    }
    
    
    
    /*
     Output - Utility is of higher priority than the background QoS
     
     printStrawberries is running on = Background Thread
     printBalls is running on = Background Thread
     🍓0
     🎱0
     🍓1
     🍓2
     🎱1
     🎱2
     
     */
    
    
    
    
    func queueTest8(){
        let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos:.utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        queue1.async {
            self.printStrawberries()
        }
        queue2.async {
            self.printBalls()
        }
        
    }
    
    
    
    /*
     Output
     In Print Balls = 2017-05-22 19:03:37 +0000
     printBalls is running on = Background Thread
     🎱0
     🎱1
     🎱2
     In Print Strawberries = 2017-05-22 19:03:42 +0000
     printStrawberries is running on = Background Thread
     🍓0
     🍓1
     🍓2
     */
    
    
    func queueTest9(){
        let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos:.utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        queue1.asyncAfter(deadline: .now()+5.0) {
            print("In Print Strawberries = \(Date())")
            self.printStrawberries()
            
        }
        
        queue2.async {
            print("In Print Balls = \(Date())")
            self.printBalls()
            
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK: ---------------  NSBlockOperation ------------------
    func blockOperationsTest1 (){
        
        let operationQueue = OperationQueue()
        
        let operation1 : BlockOperation = BlockOperation (block: {
            self.doCalculations()
            
            let operation2 : BlockOperation = BlockOperation (block: {
                
                self.doSomeMoreCalculations()
                
            })
            operationQueue.addOperation(operation2)
        })
        operationQueue.addOperation(operation1)
    }
    
    func doCalculations(){
        NSLog("do Calculations")
        for i in 100...105{
            print("i in do calculations is \(i)")
            sleep(1)
        }
    }
    
    func doSomeMoreCalculations(){
        NSLog("do Some More Calculations")
        for j in 1...5{
            print("j in do some more calculations is \(j)")
            sleep(1)
        }
        
    }
    
    
    
    
    
    func sampleCodeOne() {
        
        let operationQueue: OperationQueue = OperationQueue.main
        let completionBlockOperation: BlockOperation = BlockOperation.init(
            block: {
            print("completion Block is getting called")
            }
        )
        
        let workerBlockOperation:BlockOperation = BlockOperation.init(
            block: {
            print("worker block")
            self.sampleCodeOneWorkerMethod()
            }
        )
        completionBlockOperation.addDependency(workerBlockOperation)
        operationQueue.addOperation(workerBlockOperation)
        operationQueue.addOperation(completionBlockOperation)
    }
    
    func sampleCodeOneWorkerMethod ()
    {
        print("Actual Worker Block")
//        for (var i = 0; i<5; i++)
//        {
//            sleep(1)
//            print(i)
//        }
        
    }
    
    
    
    
    
    
    func sampleCodeTwo(){
        let customOperation : MyCustomOperation = MyCustomOperation()
        
        customOperation.completionBlock = {
            print("Both the Block Operation and the Custom Operation is completed")
        }
        
        let workerBlockOperation:BlockOperation = BlockOperation.init(
            block: {
                print("Primary Worker block")
        }
        )
        customOperation.addDependency(workerBlockOperation)
        
        let operationQueue = OperationQueue.main
        operationQueue.addOperation(customOperation)
        operationQueue.addOperation(workerBlockOperation)
    }
    
    
}










class MyCustomOperation:  Operation {
    
//    var executing = false
//    var finished = false
    
    override func main() {
        if self.isCancelled {
            return
        }
        else
        {
            NSLog("custom operation work is done here.")
//            for (var i = 0; i<5; i++)
//            {
//                NSLog("i%d",i)
//                sleep(1)
//            }
        }
        self.willChangeValue(forKey: "executing")
//        executing = false
        self.didChangeValue(forKey: "executing")
        
        self.willChangeValue(forKey: "finished")
//        finished = true
        self.didChangeValue(forKey: "finished")
        
        if(isFinished)
        {
            NSLog("completed")
        }
        else
        {
            NSLog("Not completed")
        }
    }
}












