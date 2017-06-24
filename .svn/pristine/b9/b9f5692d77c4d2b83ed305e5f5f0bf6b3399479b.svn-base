//
//  BLEModule.swift
//  SampleClassList
//
//  Created by Toshiki Higaki on 2015/08/2.
//  Copyright (c) 2015年 Toshiki Higaki. All rights reserved.
//


import CoreBluetooth
import UIKit

//@objc protocol CoreCentralManagerDelegate{
//    
//    optional func statePoweredOn()
//    optional func didGetCharacteristic()
//    optional func quizReady(URL: String)
//    optional func quizStart()
//    optional func quizSelectQuestion()
//    optional func didDiscoveryTeacher(teacherNameList: [String!])
//    
//}

class CoreCentralManagera:NSObject, CBCentralManagerDelegate, CBCentralDelegate {
    
    static var coreCentralInstance = CoreCentralManager()
    
    var delegate: CoreCentralManagerDelegate!
    
    var centralManager: CBCentralManager!
    
    var Central: CBCentral!
    
    var service: CBService!
    
    var characteristic: CBCharacteristic!
    
    var CentralList: [CBCentral] = []
    
    var serviceList: [CBService] = []
    
    var characteristicList: Dictionary <CBUUID, CBCharacteristic> = [:]
    
    var teacherNameList: [String!] = []
    
    var serviceUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B6")
    
    var loginUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B7")
    
    var answerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B8")
    
    var quizFinishUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B9")
    
    var quizStartUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BA")
    
    var quizReadyUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BB")
    
    var quizSelectQuestionUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BC")
    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    
    /**
    ペリフェラルのスキャンを開始する
    */
    func scanStart(){
        self.centralManager.scanForCentralsWithServices(nil, options: nil)
    }
    
    /**
    ペリフェラルのスキャンを停止する
    */
    func scanStop(){
        self.centralManager.stopScan()
    }
    
    /**
    ペリフェラルにつなげる
    */
    func connectTeacher(indexPath: Int) {
        self.centralManager.stopScan()
        self.centralManager.connectCentral(self.CentralList[indexPath], options: nil)
    }
    
    /**
    発見したペリフェラルを返す
    */
    func getCentralList() -> [CBCentral]{
        return CentralList
    }
    
    /**
    発見したサービスを返す
    **/
    func getServiceList() -> [CBService]{
        return self.serviceList
    }
    
    /**
    ログイン情報送信
    
    :param: userID 学籍番号
    :param: name 学生の名前
    */
    func login(studentInfo: StudentInfo) {
        // NSDataにアーカイブ
        var sendData: NSData = studentInfo.archiveNSData()
        
        let sendCharacteristic: CBCharacteristic = self.characteristicList[self.loginUUID]!
        // 書き込みを開始する
        self.Central.writeValue(sendData, forCharacteristic: sendCharacteristic, type: CBCharacteristicWriteType.WithResponse)
        
    }
    
    /**
    解答を送信する
    
    :param: questionAnswer 解答
    */
    func sendAnser(questionAnswer: QuestionAnswer){
        
        // NSData型に変換
        let sendData: NSData = questionAnswer.archiveNSData()
        //        let d = NSKeyedUnarchiver.unarchiveObjectWithData(sendData) as! StudentInfo
        
        // 書き込みを開始する
        self.Central.writeValue(sendData, forCharacteristic: self.characteristicList[self.answerUUID], type: CBCharacteristicWriteType.WithResponse)
    }
    
    /**
    テスト終了を送信する
    */
    func sendFinish(){
        let str = "Finish"
        let sendData: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
        
        // 書き込みを開始する
        self.Central.writeValue(sendData, forCharacteristic: self.characteristicList[self.quizFinishUUID], type: CBCharacteristicWriteType.WithResponse)
    }
    
    /**
    更新された時に呼ばれる
    
    :param: updateCharacteristic 更新されたキャラクタリスティック
    */
    func updateValue(updateCharacteristic: CBCharacteristic){
        switch(updateCharacteristic.UUID){
        case quizReadyUUID:
            
            let url: String = NSString(data: updateCharacteristic.value, encoding:NSUTF8StringEncoding) as! String
            self.delegate?.quizReady?(url)
            println(url)
            
        case quizStartUUID:
            
            self.delegate?.quizStart?()
            println("start")
            
        case quizSelectQuestionUUID:
            
            // 空の配列を作成
            var selectQuestionListInt32: [Int32] = [Int32](count: updateCharacteristic.value.length / sizeof(Int32), repeatedValue: 0)
            
            println("questions", updateCharacteristic.value.length.description)
            
            // 配列一つ一つに対して値を入れる！
            updateCharacteristic.value.getBytes(&selectQuestionListInt32, length:  updateCharacteristic.value.length * sizeof(Int32))
            
            // Int32に変換
            var selectQuestionListInt: [Int32] = []
            for var i=0; i < selectQuestionListInt32.count; i++ {
                selectQuestionListInt.append(Int32(selectQuestionListInt32[i]))
            }
            
            // 配列最後のシード値を取得・削除
            var seed = selectQuestionListInt.last!
            selectQuestionListInt.removeLast()
            
            // 選択されたデータをセット
            var selectQuestion: [QuestionXML] = []
            
            println("questions", selectQuestionListInt.description)
            println("value", updateCharacteristic.value)
            
            for obj in selectQuestionListInt {
                var question = QuestionBox.questionBoxInstance.questions[Int(obj)]
                
                // 回答群をランダムに！
                if seed != 0 {
                    srand(UInt32(seed))
                    let r = rand()
                    for var i = 0; i < question.answers.count; i++  {
                        let j = Int(r) % (question.answers.count - i)
                        let tmp = question.answers[i]
                        question.answers[i] = question.answers[j]
                        question.answers[j] = tmp
                        println("ランダム :", j)
                    }
                    
                    // マーク文字列
                    let markList: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
                    
                    // Mark設定
                    for var i = 0; i < question.answers.count; i++  {
                        question.answers[i].mark = markList[i]
                    }
                }
                
                // Questionを追加
                selectQuestion.append(question)
                
                // シード値変更
                seed++
                
                
                // 空の解答をAnswerDataにセット
                var questionAnswer: QuestionAnswer = QuestionAnswer()
                
                // 値をセット
                questionAnswer.questionText = "未解答"
                questionAnswer.mark = "未解答"
                
                // 追加作業
                QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer.updateValue(questionAnswer, forKey: Int(obj))
                
            }
            
            // 上でつくったものを保存
            QuestionBox.questionBoxInstance.questionID = selectQuestionListInt
            QuestionBox.questionBoxInstance.selectQuestion = selectQuestion
            
            self.delegate?.quizSelectQuestion?()
            
        default:
            break
        }
        println("update!!!!!!!!")
    }
    
    
    
    
    
    // ----Delegate宣言----
    
    /**
    CMの状態変化を取得（使ってないけどいるみたい。どうやら必要メソッドらしい）
    */
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("State: \(central.state)")
        // 端末のBluetoothの状態を列挙
        enum CBCentralManagerState : Int {
            case Unknown
            case Resetting
            case Unsupported
            case Unauthorized
            case PoweredOff
            case PoweredOn
        }
        
        // 端末のBluetoothの状態によって作業を変更
        // *三項演算子をつかっておりますのでご注意ください。
        switch (central.state){
        case .PoweredOn:
            self.delegate?.statePoweredOn?()
            
        default:
            break
        }
        
    }
    
    /**
    スキャン後、デバイス発見時に呼び出さられる
    */
    func centralManager(central: CBCentralManager!, didDiscoverCentral Central: CBCentral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Central State: \(Central)")
        
        self.teacherNameList.append(Central.name as String?)
        self.CentralList.append(Central)
        
        self.delegate?.didDiscoveryTeacher?(self.teacherNameList)
        
    }
    
    /**
    ペリフェラル接続失敗時
    */
    func centralManager(central: CBCentralManager!, didDisconnectCentral Central: CBCentral!, error: NSError!) {
        println("接続失敗(´・ω・｀)")
    }
    
    
    /**
    ペリフェラル接続成功時
    */
    func centralManager(central: CBCentralManager!, didConnectCentral connectCentral: CBCentral!) {
        println("接続成功(ﾟ∀ﾟ)")
        
        self.Central = connectCentral
        self.Central.delegate = self
        
        // サービス検索開始
        self.Central.discoverServices(nil)
    }
    
    /**
    サービス検索結果
    */
    func Central(Central: CBCentral!, didDiscoverServices error: NSError!) {
        let services: NSArray = Central.services
        println("\(services.count)個のサービスを発見\(services)")
        
        for obj in services{
            if let service = obj as? CBService{
                if service.UUID.isEqual(self.serviceUUID) {
                    // キャラクタリスティック検索
                    Central.discoverCharacteristics(nil, forService: service)
                }
            }
        }
    }
    
    /**
    キャラクタリスティック検索結果
    */
    func Central(Central: CBCentral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        let characteristics: NSArray = service.characteristics
        
        println("\(characteristics.count)個のキャラスタリスティックを発見！ \(characteristics)")
        
        // データの読み出し(Read)のみの抽出
        for obj in characteristics {
            if let characteristic = obj as? CBCharacteristic {
                
                // 更新通知のリクエスト
                Central.setNotifyValue(true, forCharacteristic: characteristic)
                
                // キャラクタリスティックを分別　*必要であればここに追加 add
                switch (characteristic.UUID){
                case loginUUID:
                    self.characteristicList.updateValue(characteristic, forKey: loginUUID)
                    println("login")
                case answerUUID:
                    self.characteristicList.updateValue(characteristic, forKey: answerUUID)
                    println("anser")
                case quizFinishUUID:
                    self.characteristicList.updateValue(characteristic, forKey: quizFinishUUID)
                    println("finish")
                case quizStartUUID:
                    self.characteristicList.updateValue(characteristic, forKey: quizStartUUID)
                    println("quizStart")
                case quizReadyUUID:
                    self.characteristicList.updateValue(characteristic, forKey: quizReadyUUID)
                    println("quizReady")
                case quizSelectQuestionUUID:
                    self.characteristicList.updateValue(characteristic, forKey: quizSelectQuestionUUID)
                    println("quizSelectQetsion")
                default:
                    println("not uuid")
                    break
                }
            }
        }
        
        // ログイン
        self.login(StudentInfo.studentInfoInstance)
        
        self.delegate?.didGetCharacteristic?()
        
    }
    
    /**
    データの読み出し(Read)結果
    */
    func Central(Central: CBCentral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("データ更新通知エラー: \(error)")
            return
        }
        
        updateValue(characteristic)
        
        println("データ更新！ characteristic UUID: \(characteristic.UUID), value: \(characteristic.value)")
        
    }
    
    /**
    データの書き込み(Write)結果
    */
    func Central(Central: CBCentral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if (error != nil) {
            println("Write失敗...error: \(error)")
            return
        }
        
        println("Write成功！")
    }
    
    /**
    更新通知開始時
    */
    func Central(Central: CBCentral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            
            println("Notify状態更新失敗...error: \(error)")
        }
        else {
            println("Notify状態更新成功！ isNotifying: \(characteristic.isNotifying)")
        }
    }
    
    /**
    よくわからんけど何か更新したときっぽい
    */
    func Central(Central: CBCentral!, didUpdateValueForDescriptor descriptor: CBDescriptor!, error: NSError!) {
        if error != nil {
            println("上書き成功?")
        }
        else {
            println("上書き失敗？？")
        }
    }
    
}