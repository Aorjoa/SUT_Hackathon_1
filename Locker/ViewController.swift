//
//  ViewController.swift
//  Locker
//
//  Created by Bhuridech Sudsee on 4/22/2560 BE.
//  Copyright © 2560 Bhuridech Sudsee. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let serialPort = ORSSerialPort(path: "/dev/cu.usbmodem411")
    @IBOutlet weak var imageViewQR: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serialPort?.baudRate = 9600
        serialPort?.open()
        
        DispatchQueue.global(qos: .background).async {
            while(true){
                self.readFirebase()
                sleep(3)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func lock1(_ sender: Any) {
        lock(1)
    }
    
    @IBAction func unlock1(_ sender: Any) {
        unlock(1)
    }
    
    @IBAction func lock2(_ sender: Any) {
        lock(2)
    }
    
    @IBAction func unlock2(_ sender: Any) {
        unlock(2)
    }
    
    func readFirebase(){
        let url = "https://hackathon-7d8c4.firebaseio.com/status_product.json"
        //var status: String78
        URLSession.shared.dataTask(with: (NSURL(string: url)! as URL) as URL) { data, response, error in
            // Handle result
            print(data!)
            if(String(data: data!, encoding: .utf8)!.contains("1")){
                self.unlock(1)
            }else{
                self.lock(1)
            }
         //   status = data.
            }.resume()
    }
    
    func lock(_ lockerNo: Int){
    let str = "lock\(lockerNo)@".data(using: .utf8)!
    serialPort?.send(str) // someData is an NSData object
    }
    
    func unlock(_ lockerNo: Int){
        let str = "unlock\(lockerNo)@".data(using: .utf8)!
        serialPort?.send(str) // someData is an NSData object
    }
    
    @IBAction func generateSenderQR
        (_ sender: NSButton) {
        let machineID: String = "NK1"
        let data = machineID.data(using: String.Encoding.ascii)
        
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.applying(transform) {
                let rep: NSCIImageRep = NSCIImageRep(ciImage: output)
                let nsImage: NSImage = NSImage(size: rep.size)
                nsImage.addRepresentation(rep)
                imageViewQR.image = nsImage

            }
        }
    }
}

