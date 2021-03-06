//
//  CoreCentralManager.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/27.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//


import CoreBluetooth
import UIKit

@objc protocol CoreCentralManagerDelegate{
    
    /**
    学生端末を発見した際通知/
    */
    optional func discoverStudent(peripheral: CBPeripheral, name: String)
    
    /**
    学生端末に接続失敗した際通知/
    */
    optional func disConnectStudent(peripheral: CBPeripheral)
    
    /**
    学生がログインした際通知/
    */
    optional func getStudentLogin(peripheral: CBPeripheral)
    
    /**
    学生が解答した際通知
    */
    optional func quizAnswerRequest(questionNumber: Int)
    
    /**
    学生が解答した際通知
    */
    optional func quizStudentAnswerRequest(UUID: NSUUID)
    
    /**
    学生が更新通知をリクエストした際通知/
    */
    optional func subscribe(peripheralNameList: [String])
    
    /**
    学生が更新通知を解除するリクエストした際通知
    */
    optional func unSubscribe(peripheral: String)
    
    /**
    
    */
    optional func notificationFinish(peripheral: String)
    
    /**
    学生の解答を取得した際通知
    */
    optional func didGetStudentAnswer(answer: QuestionAnswer, student: StudentInfo)
    
    /**
    学生がSSアップロード終了時に通知
    */
    optional func ssUploadFinish(userID: String)
    
    /**
    クリッカーの通知
    */
    optional func clickerNotification(userID: String, beforMark: String?)
}

@objc protocol SecondViewCoreCentralManagerDelegate {
    
    /**
    学生端末を発見した際通知/
    */
    optional func discoverStudent(peripheral: CBPeripheral, name: String)
    
    /**
    学生端末に接続失敗した際通知/
    */
    optional func disConnectStudent(peripheral: CBPeripheral)
    
    /**
    学生がログインした際通知/
    */
    optional func getStudentLogin(peripheral: CBPeripheral)
    
    /**
    学生が解答した際通知
    */
    optional func quizAnswerRequest(questionNumber: Int)
    
    /**
    学生が解答した際通知
    */
    optional func quizStudentAnswerRequest(UUID: NSUUID)
    
    /**
    学生が更新通知をリクエストした際通知/
    */
    optional func subscribe(peripheralNameList: [String])
    
    /**
    学生が更新通知を解除するリクエストした際通知
    */
    optional func unSubscribe(peripheral: String)
    
    /**
    
    */
    optional func notificationFinish(peripheral: String)
    
    /**
    学生の解答を取得した際通知
    */
    optional func didGetStudentAnswer(answer: QuestionAnswer, student: StudentInfo)
    
    /**
    学生がSSアップロード終了時に通知
    */
    optional func ssUploadFinish(userID: String)
    
    /**
    クリッカーの通知
    */
    optional func clickerNotification(userID: String, beforMark: String?)
}

class CoreCentralManager:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static var coreCentralInstance = CoreCentralManager()
    
    var delegate: CoreCentralManagerDelegate!
    
    var secondViewDelegate: SecondViewCoreCentralManagerDelegate!
    
    var centralManager: CBCentralManager!
    
    var service: CBService!
    
    var characteristic: CBCharacteristic!
    
    var peripheralList: Dictionary<NSUUID, CBPeripheral> = [:]
    
    // 学生のサービスリスト　valueとしてcharacteristicList
    var serviceList: Dictionary<NSUUID, Dictionary <CBUUID, CBCharacteristic>> = [:]
    
    var characteristicList: Dictionary <CBUUID, CBCharacteristic> = [:]
    
    var connectStudentList: Dictionary <NSUUID, StudentInfo> = [:]
    
    var status: String = ""
    
    var serviceUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B6")
    
    var loginUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B7")
    
    var answerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B8")
    
    var quizFinishUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B9")
    
    var quizStartUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BA")
    
    var quizReadyUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BB")
    
    var quizSelectQuestionUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BC")
    
    var monitoringUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BD")
    
    var lockUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BE")
    
    var homeUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BF")
    
    var soundEffectUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C0")
    
    var clickerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C1")
    
    var freeClickerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C4")
    
    var clickerStatusUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C5")
    
    var statusUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C2")
    
    var webUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C3")
    
    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    func setEmpty() {
        self.peripheralList = [:]
        
        self.serviceList = [:]
        
        self.characteristicList = [:]
        
        self.connectStudentList = [:]
        
        self.status = ""
        
    }
    
    
    /**
    ペリフェラルのスキャンを開始する
    */
    func scanStart(){
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
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
    func connectStudent(peripheral: CBPeripheral) {
        self.centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    
    /**
    更新された時に呼ばれる
    
    :param: updateCharacteristic 更新されたキャラクタリスティック
    :param: peripheral 更新された端末情報
    */
    func getUpdateValue(updateCharacteristic: CBCharacteristic, peripheral: CBPeripheral){
        //        println("get data : ", updateCharacteristic.value)
        switch(updateCharacteristic.UUID){
            // login情報取得
        case loginUUID:
            // NSdataからStudentInfoに変換
            if updateCharacteristic.value != nil{
                let studentInfo: StudentInfo = StudentInfo(data: updateCharacteristic.value)
                studentInfo.UUID = peripheral.identifier
                
                // 画像の取得を行う
                var url = NSURL(string: studentInfo.profileImageURL)
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                var req = NSMutableURLRequest(URL: url!)
                req.HTTPMethod = "POST"
                var task = session.dataTaskWithRequest(req, completionHandler: {
                    (data, resp, err) in
                    let profileImage = UIImage(data: data)
                    studentInfo.profileImage = profileImage
                    
                    // 学生追加
                    if self.connectStudentList.updateValue(studentInfo, forKey: peripheral.identifier) == nil {
                        StudentInfoBox.studentInfoBoxInstance.studentList.append(studentInfo)
                    }
                        // 出席設定
                    else {
                        let studentIndex = StudentInfoBox.studentInfoBoxInstance.getStudentIndex(peripheral.identifier)
                        StudentInfoBox.studentInfoBoxInstance.studentList[studentIndex].absent = false
                    }
                    
                    self.delegate?.getStudentLogin?(peripheral)
                    self.secondViewDelegate?.getStudentLogin?(peripheral)
                })
                
                task.resume()
                
            }
            
            
            // 問題の解答情報取得
        case answerUUID:
            let str = "Notify"
            let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
            
            // Readが必要かどうか
            if updateCharacteristic.value != data {
                
                //                let answerData: QuestionAnswer = QuestionAnswer(data: updateCharacteristic.value)
                
                if let answerData: QuestionAnswer = NSKeyedUnarchiver.unarchiveObjectWithData(updateCharacteristic.value) as? QuestionAnswer {
                    let student: StudentInfo = self.connectStudentList[peripheral.identifier]!
                    
                    
                    // 回答数をカウント
                    var answerCount: [Int]
                    
                    var studentsAnswerMarkCount: [Int] = [Int](count: 8, repeatedValue: 0)
                    
                    // 問題ごとの正答率集計
                    var questionCorrectCount: [Int]
                    
                    // 学生ごとの正答率集計
                    var studentCorrectCount: [Int]
                    
                    let q = QuestionBox.questionBoxInstance.questions
                    
                    let qa = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount
                    // ------マークパターン------
                    
                    // 学生の解答を取得
                    if QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]?.studentsAnswerMarkCount != nil {
                        studentsAnswerMarkCount = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]!.studentsAnswerMarkCount
                        studentCorrectCount =  QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]!.studentsAnswerMarkCount
                    }
                    
                    // 過去の解答があった場合
                    if QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]?.studentAnswer[answerData.questionNumber] != nil {
                        // カウント配列を取得
                        answerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber]!
                        
                        // 前回の回答を取得
                        let beforeQuestionAnswer = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]?.studentAnswer[answerData.questionNumber]
                        
                        // 前回の回答群のindexを取得（配列番号)
                        var beforeIndex = 0
                        
                        
                        for var i = 0; i < QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count; i++ {
                            if QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers[i].mark == beforeQuestionAnswer!.mark {
                                beforeIndex = i
                                break
                            }
                        }
                        // 前回の解答からindex取得
                        let beforeMarkIndex = getMarkNumber(beforeQuestionAnswer!.mark)
                        
                        // 配列の中の数値の[index]を-1
                        answerCount[beforeIndex] -= 1
                        studentsAnswerMarkCount[beforeMarkIndex] -= 1
                        
                    }
                        
                        // 過去の解答がなかった場合
                    else if QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber] != nil {
                        answerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber]!
                    }
                        
                        // 初めての書き込みだった場合
                    else {
                        // カウント配列作成
                        answerCount = [Int](count: QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count, repeatedValue: 0)
                    }
                    
                    var afterIndex = 0
                    // 今回の回答群のindexを取得
                    for var i = 0; i < QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count; i++ {
                        if QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers[i].mark == answerData.mark {
                            afterIndex = i
                            break
                        }
                    }
                    
                    //                println("afterIndex ", afterIndex.description)
                    
                    
                    var afterMarkIndex = getMarkNumber(answerData.mark)
                    
                    // 配列の中の数値の[index]を+1
                    answerCount[afterIndex] += 1
                    studentsAnswerMarkCount[afterMarkIndex] += 1
                    
                    
                    // ------回答文パターン------
                    /*
                    // 過去の解答があった場合
                    if (QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]?.studentAnswer[answerData.questionNumber] != nil) {
                    
                    // カウント配列を取得
                    answerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber]!
                    // 前回の回答を取得
                    let beforeQuestionAnswer = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]?.studentAnswer[answerData.questionNumber]
                    
                    // 前回の回答群のindexを取得（配列番号)
                    var beforeIndex = 0
                    for var i = 0; i < QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count; i++ {
                    if QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers[i].questionText == beforeQuestionAnswer!.questionText {
                    beforeIndex = i
                    break
                    }
                    }
                    println("beforeIndex ", beforeIndex.description)
                    
                    // 配列の中の数値の[index]を-1
                    answerCount[beforeIndex] -= 1
                    }
                    
                    // 過去の解答がなかった場合
                    else if QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber] != nil {
                    answerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[answerData.questionNumber]!
                    }
                    
                    // 初めての書き込みだった場合
                    else {
                    // カウント配列作成
                    answerCount = [Int](count: QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count, repeatedValue: 0)
                    }
                    
                    var afterIndex = 0
                    // 今回の回答群のindexを取得
                    for var i = 0; i < QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers.count; i++ {
                    if QuestionBox.questionBoxInstance.questions[answerData.questionNumber-1].answers[i].questionText == answerData.questionText {
                    afterIndex = i
                    break
                    }
                    }
                    println("afterIndex ", afterIndex.description)
                    
                    // 配列の中の数値の[index]を+1
                    answerCount[afterIndex] += 1
                    
                    */
                    
                    
                    // 配列をセット
                    QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount.updateValue(answerCount, forKey: answerData.questionNumber)
                    
                    
                    // 学生の解答データを保存
                    if (QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier] != nil) {
                        // QuestionAnswerBoxのなかのstudentsAnswerを取得
                        var studentsAnswer = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]
                        
                        // データをアップデート
                        studentsAnswer?.studentAnswer.updateValue(answerData, forKey: answerData.questionNumber)
                        QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer.updateValue(studentsAnswer!, forKey: peripheral.identifier)
                        println("update")
                    }
                    else {
                        var studentQuestionAnswers = StudentQuestionAnswers()
                        studentQuestionAnswers.studentAnswer[answerData.questionNumber] = answerData
                        QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer.updateValue(studentQuestionAnswers, forKey: peripheral.identifier)
                        
                        println("new")
                    }
                    
                    // 学生のグラフビュー配列をセット
                    QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[peripheral.identifier]!.studentsAnswerMarkCount = studentsAnswerMarkCount
                    
                    println(answerCount)
                    
                    // selectQuestionの問題番号を取得
                    var i = 0
                    for obj in QuestionBox.questionBoxInstance.selectQuestion {
                        if(obj.questionNumber == answerData.questionNumber) {
                            break
                        }
                        i++
                    }
                    
                    // デリゲート
                    self.delegate?.quizAnswerRequest?(i)
                    self.delegate?.quizStudentAnswerRequest?(peripheral.identifier)
                    self.secondViewDelegate?.quizAnswerRequest?(i)
                    self.secondViewDelegate?.quizStudentAnswerRequest?(peripheral.identifier)
                }
            }
                
            else {
                peripheral.readValueForCharacteristic(updateCharacteristic)
            }
            
            // 監視時のSSアップロード終了の通知
        case monitoringUUID:
            let state: String = NSString(data: updateCharacteristic.value, encoding:NSUTF8StringEncoding) as! String
            self.delegate?.ssUploadFinish?(state)
            self.secondViewDelegate?.ssUploadFinish?(state)
            
            // clickerの解答情報
        case clickerUUID:
            let str = "Clicker"
            let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
            // Readが必要かどうか
            if updateCharacteristic.value != data {
                
                //                println(updateCharacteristic.value)
                if let data: ClickerInfo = NSKeyedUnarchiver.unarchiveObjectWithData(updateCharacteristic.value) as? ClickerInfo {
                    self.delegate?.clickerNotification?(data.studentUserID!, beforMark: ClickerInfo.clickerInfoInstance.studentAnswerList.updateValue(data.selectMark!, forKey: data.studentUserID!))
                    self.secondViewDelegate?.clickerNotification?(data.studentUserID!, beforMark: ClickerInfo.clickerInfoInstance.studentAnswerList.updateValue(data.selectMark!, forKey: data.studentUserID!))
                }
            }
            else {
                peripheral.readValueForCharacteristic(updateCharacteristic)
            }
            //            self.studentAnswerList.updateValue(selectMark, forKey: userID)
            //            if let data: ClickerInfo = NSKeyedUnarchiver.unarchiveObjectWithData(updateCharacteristic.value) as? ClickerInfo {
            //                self.delegate?.clickerNotification?(data.studentUserID!, beforMark: ClickerInfo.clickerInfoInstance.studentAnswerList.updateValue(data.selectMark!, forKey: data.studentUserID!))
            //                ClickerInfo.clickerInfoInstance.setData(data)
            //            }
            
        case homeUUID:
            let home = "pushHome"
            let dataHome = home.dataUsingEncoding(NSUTF8StringEncoding)!

            let ehd = "endApp"
            let dataEnd = ehd.dataUsingEncoding(NSUTF8StringEncoding)!

            let studentName = StudentInfoBox.studentInfoBoxInstance.getStudentInfoForUUId(peripheral.identifier)
            
            if dataHome == updateCharacteristic.value {
                ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.addBadgeNumber(studentName!.name, type: "pushHome")
            }

            else if dataEnd == updateCharacteristic.value {
                ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.addBadgeNumber(studentName!.name, type: "endApp")
            }
            
            
        default:
            break
        }
        println("update!!!!!!!!")
    }
    
    
    /**
    学生に対しての書き込み全般
    
    :param: UUID 送信するcharacteristicのUUID
    :param: sendURL 学生に送るデータ
    */
    func sendWritingRequest(UUID: CBUUID, sendData: AnyObject?){
        var data: NSData
        switch(UUID){
            // 選択したクイズの送信
        case quizReadyUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // クイズのスタートの通知
        case quizStartUUID:
            data = "all".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // 選択したクイズの送信
        case quizSelectQuestionUUID:
            var selectQuestionList: [Int] = sendData as! [Int]
            
            // Seed値取得
            var seed = QuestionBox.questionBoxInstance.seed
            
            
            for obj in selectQuestionList {
                println(QuestionBox.questionBoxInstance.questions)
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
            }
            
            
            // シード値追加
            selectQuestionList.append(seed)
            println("select : ", selectQuestionList.count)
            
            // Int32に変換
            var selectQuestionListInt32: [Int32] = []
            for var i=0; i < selectQuestionList.count; i++ {
                selectQuestionListInt32.append(Int32(selectQuestionList[i]))
            }
            println("data : ", selectQuestionListInt32.description)
            
            // NSData化
            data = NSData(bytes: selectQuestionListInt32, length: selectQuestionListInt32.count * sizeof(Int32))
            //            println("data HOGEEEEE\(data)")
            //            println("data : ", data.length.description)
            
            // 終了通知
        case quizFinishUUID:
            var sendMessage = sendData as! String
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            
            // 監視部分の通信
        case monitoringUUID:
            data = "please take SS".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            
            // ロック通知
        case lockUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // クリッカー通知
        case clickerUUID:
            data = NSKeyedArchiver.archivedDataWithRootObject(ClickerInfo.clickerInfoInstance)
            
        case freeClickerUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // 選択コンテンツ通知
        case statusUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // クリッカーのステータス通知
        case clickerStatusUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            
            // 選択コンテンツ通知
        case webUUID:
            data = NSKeyedArchiver.archivedDataWithRootObject(WebInfo.webInfoInstance)
            
        default:
            data = "nil".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        }
        //        println(data)
        
        
        // peripheralに単体でwrite送信
        for peripheralObj in peripheralList.values {
            var peripheralUUID = peripheralObj.identifier
            
            // キャラクタリスティックを取得
            if var quizCharacteristic = serviceList[peripheralUUID]?[UUID] {
                peripheralObj.writeValue(data, forCharacteristic: quizCharacteristic, type: CBCharacteristicWriteType.WithoutResponse)
            }
        }
    }
    
    
    /**
    指定した学生に対しての書き込み全般
    
    :param: UUID 送信するcharacteristicのUUID
    :param: sendURL 学生に送るデータ
    */
    func sendWritingRequest(UUID: CBUUID, sendData: AnyObject?, studentUUIDList: [NSUUID!]) {
        var data: NSData
        switch(UUID){
            // 指名型クイズ通知
        case quizStartUUID:
            data = "nomination".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
        case quizFinishUUID:
            var sendMessage = sendData as! String
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // ロック通知
        case lockUUID:
            var sendMessage = sendData as! String
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // 効果音通知
        case soundEffectUUID:
            var sendMessage = sendData as! String
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
            // 選択コンテンツ通知
        case statusUUID:
            data = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            
        default:
            data = "nil".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        }
        
        // peripheralに単体でwrite送信
        for studentUUID in studentUUIDList {
            var peripheral = self.peripheralList[studentUUID]
            
            // キャラクタリスティックを取得
            if var quizCharacteristic = serviceList[studentUUID]?[UUID] {
                peripheral!.writeValue(data, forCharacteristic: quizCharacteristic, type: CBCharacteristicWriteType.WithoutResponse)
            }
        }
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
            println("ok")
            //            self.scanStart()
            
        default:
            break
        }
        
    }
    
    
    /**
    スキャン後、デバイス発見時に呼び出さられる
    */
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("peripheral State: \(peripheral)")
        println("advertisementData: \(advertisementData)")
        if let peripheralName = advertisementData["kCBAdvDataLocalName"] as? String {
            
            if self.peripheralList.updateValue(peripheral, forKey: peripheral.identifier) == nil {
                self.delegate?.discoverStudent?(peripheral, name: peripheralName)
                self.secondViewDelegate?.discoverStudent?(peripheral, name: peripheralName)
            }
        }
    }
    
    
    /**
    ペリフェラル接続失敗時
    */
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("disconnect uuid : ", peripheral.identifier)
        println("接続失敗(´・ω・｀)")
        
        let indexNumber = StudentInfoBox.studentInfoBoxInstance.getStudentIndex(peripheral.identifier)
        if indexNumber != -1 {
            StudentInfoBox.studentInfoBoxInstance.studentList[indexNumber].absent = true
            // ポッパーの作成
            ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.addBadgeNumber(StudentInfoBox.studentInfoBoxInstance.studentList[indexNumber].name)
        }
        self.connectStudent(peripheral)
        // 学生端末との接続に失敗
        self.delegate?.disConnectStudent?(peripheral)
        self.secondViewDelegate?.disConnectStudent?(peripheral)
    }
    
    
    /**
    ペリフェラル接続成功時
    */
    func centralManager(central: CBCentralManager!, didConnectPeripheral connectPeripheral: CBPeripheral!) {
        println("接続成功(ﾟ∀ﾟ)")
        
        connectPeripheral.delegate = self
        //        self.peripheral = connectPeripheral
        //        self.peripheral.delegate = self
        
        // サービス検索開始
        connectPeripheral.discoverServices([serviceUUID])
    }
    
    
    /**
    サービス検索結果
    */
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error == nil {
            let services: NSArray = peripheral.services
            println("\(services.count)個のサービスを発見\(services)")
            
            for obj in services{
                if let service = obj as? CBService{
                    if service.UUID.isEqual(self.serviceUUID) {
                        // キャラクタリスティック検索
                        peripheral.discoverCharacteristics(nil, forService: service)
                    }
                }
            }
        }
    }
    
    
    /**
    キャラクタリスティック検索結果
    */
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error == nil {
            let characteristics: NSArray = service.characteristics
            
            println("\(characteristics.count)個のキャラスタリスティックを発見！ \(characteristics)")
            
            self.characteristicList = [:]
            
            // データの読み出し(Read)のみの抽出
            for obj in characteristics {
                if let characteristic = obj as? CBCharacteristic {
                    
                    // 更新通知のリクエスト
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                    
                    // キャラクタリスティックを分別　*必要であればここに追加 add
                    switch (characteristic.UUID){
                    case loginUUID:
                        self.characteristicList.updateValue(characteristic, forKey: loginUUID)
                        // 学生の情報を取得
                        peripheral.readValueForCharacteristic(characteristic)
                    case answerUUID:
                        self.characteristicList.updateValue(characteristic, forKey: answerUUID)
                    case quizFinishUUID:
                        self.characteristicList.updateValue(characteristic, forKey: quizFinishUUID)
                    case quizStartUUID:
                        self.characteristicList.updateValue(characteristic, forKey: quizStartUUID)
                    case quizReadyUUID:
                        self.characteristicList.updateValue(characteristic, forKey: quizReadyUUID)
                    case quizSelectQuestionUUID:
                        self.characteristicList.updateValue(characteristic, forKey: quizSelectQuestionUUID)
                    case monitoringUUID:
                        self.characteristicList.updateValue(characteristic, forKey: monitoringUUID)
                    case lockUUID:
                        self.characteristicList.updateValue(characteristic, forKey: lockUUID)
                    case homeUUID:
                        self.characteristicList.updateValue(characteristic, forKey: homeUUID)
                    case soundEffectUUID:
                        self.characteristicList.updateValue(characteristic, forKey: soundEffectUUID)
                    case clickerUUID:
                        self.characteristicList.updateValue(characteristic, forKey: clickerUUID)
                    case statusUUID:
                        let sendPeripheral = [peripheral.identifier]
                        self.sendWritingRequest(self.statusUUID, sendData: nil, studentUUIDList: sendPeripheral)
                        self.characteristicList.updateValue(characteristic, forKey: statusUUID)
                    case webUUID:
                        self.characteristicList.updateValue(characteristic, forKey: webUUID)
                    case freeClickerUUID:
                        self.characteristicList.updateValue(characteristic, forKey: freeClickerUUID)
                    case clickerStatusUUID:
                        self.characteristicList.updateValue(characteristic, forKey: clickerStatusUUID)
                        
                    default:
                        println("not uuid")
                        break
                    }
                }
            }
            
            self.serviceList.updateValue(self.characteristicList, forKey: peripheral.identifier)
        }
    }
    
    
    /**
    データの読み出し(Read)結果
    */
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("データ更新通知エラー: \(error)")
            return
        }
        //        println("データ更新！ characteristic UUID: \(characteristic.UUID), value: \(characteristic.value)")
        
        self.getUpdateValue(characteristic, peripheral: peripheral)
    }
    
    
    /**
    データの書き込み(Write)結果
    */
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if (error != nil) {
            println("Write失敗...error: \(error)")
            return
        }
        
        println("Write成功！")
    }
    
    
    /**
    更新通知開始時
    */
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
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
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForDescriptor descriptor: CBDescriptor!, error: NSError!) {
        if error != nil {
            println("上書き成功?")
        }
        else {
            println("上書き失敗？？")
        }
    }
    
}
