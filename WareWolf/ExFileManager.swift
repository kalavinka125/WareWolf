//
//  FileManager.swift
//  KneesNeeds-Release
//
//  Created by falcon@mac on H29/05/29.
//  Copyright © 平成29年 falcon-lab. All rights reserved.
//

import UIKit

class ExFileManager: NSObject {
    
    func createDir(dirName : String){
        // ドキュメントのパス
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do {
            try FileManager.default.createDirectory(atPath: docDir + dirName, withIntermediateDirectories: false, attributes: nil)
        } catch { print("DIR MAKE NG") }
    }
    
    func removeDir(dirName : String){
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do {
            try FileManager.default.removeItem(atPath: docDir + dirName)
        } catch { print("DIR MAKE NG") }
    }
    
    func outputTxtFile(fileName : String , text : String){
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString? {
            let path_file_name = dir.appending("\(fileName)")
            do {
                try text.write( toFile: path_file_name, atomically: false, encoding: String.Encoding.utf8 )
            } catch {print("FILE MAKE NG")}
        }
    }
    
    func outputTxtFile(dirName : String, fileName : String , text : String){
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString? {
            let path_file_name = dir.appending("\(dirName)/\(fileName)")
            do {
                try text.write( toFile: path_file_name, atomically: false, encoding: String.Encoding.utf8 )
            } catch { print("FILE MAKE NG") }
        }
    }
    
    class func createFileName(date : NSDate) -> String{
        return self.createFileName(date: date, name: "")
    }
    
    class func createFileName(date : NSDate , name : String) -> String{
        let outputDateFormatter : DateFormatter = DateFormatter()
        let outputDateFormatterStr : String = "yyyyMMddHHmmss"
        outputDateFormatter.timeZone = NSTimeZone.system
        outputDateFormatter.dateFormat = outputDateFormatterStr
        if(name.characters.count > 0){
            return outputDateFormatter.string(from: date as Date) + "_\(name)" + ".txt"
        }else{
            return outputDateFormatter.string(from: date as Date) +  ".txt"
        }
    }
    
    /**
     * Date型を綺麗な文字列に変換する
     **/
    class func date2String(date : Date) -> String {
        let formatter = DateFormatter()
        // yyyy年MM月dd日' 'HH:mm:ss"
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分ss秒"
        return formatter.string(from: date)
    }
    
    class func date2FDirName(date : Date) -> String {
        let formatter = DateFormatter()
        // yyyy年MM月dd日' 'HH:mm:ss"
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
    
    class func date2FDirName2(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // yyyy-MM-dd' 'HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /// 指定した名前、拡張子のファイルを読み込む
    ///
    /// - Parameters:
    ///   - forResource: 指定したいファイル名
    ///   - fileExtension: 拡張子
    class func readFile(forResource:String,fileExtension:String) -> [String]{
        if let txtBundle = Bundle.main.path(forResource: forResource, ofType: fileExtension) {
            do {
                let data = try String(contentsOfFile: txtBundle, encoding: String.Encoding.utf8)
                let split = data.components(separatedBy: "\n")
                return split
            }catch { return [] }
        }
        return []
    }
    
    /// Resourcesにあるテキストファイルを読み込む命令
    ///
    /// - Parameters:
    ///   - forResource: Resourcesにあるファイル名
    ///   - separatedBy: 一行を何でセパレートするか
    ///   - method: 分割したものをどう処理するか（一行ごとに呼ばれる）
    /// - Returns:改行で分割したテキストファイル
    class func readTxtFile(forResource:String,separatedBy:String,method:([String])->()){
        if let txtBundle = Bundle.main.path(forResource: forResource, ofType: "tsv") {
            do {
                let data = try String(contentsOfFile: txtBundle, encoding: String.Encoding.utf8)
                let split = data.components(separatedBy: "\n")
                for s in split {
                    if s != "" {
                        let sc = s.components(separatedBy: separatedBy)
                        method(sc)
                    }
                }
            }catch {}
        }
    }
    
    class func readTxtFile(forResource:String) -> [String]{
        if let txtBundle = Bundle.main.path(forResource: forResource, ofType: "tsv") {
            do {
                let data = try String(contentsOfFile: txtBundle, encoding: String.Encoding.utf8)
                let split = data.components(separatedBy: "\n")
                return split
            }catch { return [] }
        }
        return []
    }
    
    class func readCSVFile(forResource:String,separatedBy:String,method:([String])->()){
        if let txtBundle = Bundle.main.path(forResource: forResource, ofType: "csv") {
            do {
                let data = try String(contentsOfFile: txtBundle, encoding: String.Encoding.utf8)
                let split = data.components(separatedBy: "\n")
                for s in split {
                    if s != "" {
                        let sc = s.components(separatedBy: separatedBy)
                        method(sc)
                    }
                }
            }catch {}
        }
    }
    
}
