//
//  ViewController.swift
//  PrimeNumber
//
//  Created by 張書彬 on 2017/11/24.
//  Copyright © 2017年 Joshua Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var resultLable: UILabel!
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func doThePrimeTest(_ sender: UIButton) {
        /*
        //1. take out the number string from the inputTextField
        if let inputText = inputTextField.text{
            //2. convert the number String to Int
            if let inputNumber = Int(inputText){
                //3. Using the checkPrime function to get result
                //Using the resultLable to show result
                checkPrime(withNumber: inputNumber, andCompleteHandler: {
                    (result:String) in //(result:String)為是否為質數的字串
                    resultLable.text = checkPrime(withNumber: inputNumber)
                    resultLable.isHidden = false
                })
            }
        }
        */
        // above code can be simply express with
        if let inputText = inputTextField.text, let inputNumber = Int(inputText){
            checkPrime(withNumber: inputNumber){
                self.resultLable.text = $0
                self.resultLable.isHidden = false
            }
        }
        inputTextField.text = "" //let inputTextField empty after check prime number
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputTextField.becomeFirstResponder()
        //push the keyboard up
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkPrime(withNumber testNumber:Int) -> String{
        var isPrime:Bool? = true
        if testNumber <= 0 {
            isPrime = nil
        } else if testNumber == 1 {
            isPrime = false
        } else {
            for i in 2..<testNumber {
                if testNumber % i == 0 {
                    //input number is not prime
                    isPrime = false
                    break
                    //break syntax is take off the loop once the modulus is '0'
                    //for speed up this program performance
                    //if no break syntax at here, program shall check each number of less than testNumber, that's very waste time.
                }
            }
        }
        if isPrime == true {
            return "\(testNumber) is prime number"
        } else if isPrime == false {
            return "\(testNumber) is not prime number"
        } else {
            return "Please enter a number greater than 0."
        }
    }
    
    func checkPrime(withNumber number:Int, andCompleteHandler handler:(String)->()){
        //let result = checkPrime(withNumber: number)
        //handler(result)
        //simply express
        handler(checkPrime(withNumber: number))
    }
}

