//
//  String+Extension.swift
//  Games
//
//  Created by Django on 18/08/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension Character {

    /*
     value conversion
     */
    public var stringValue: String {
        return String(self)
    }
}

extension String {

    /*
     const
     */
    public static let empty: String = ""
    public static let space: String = " "

    /*
     value conversion
     */
    public var md5Value: String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context,
                      self,
                      CC_LONG(lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        return digest.reduce(.empty) { $0 + String(format:"%02x", $1) }
    }

    public var intValue: Int? {
        return Int(self)
    }

    public var floatValue: Float? {
        return Float(self)
    }

    public var CGFloatValue: CGFloat? {
        return floatValue.map { CGFloat($0) }
    }

    public var doubleValue: Double? {
        return Double(self)
    }

    public var urlValue: URL? {
        return URL(string: self)
    }

    public var boolValue: Bool? {
        let resString = lowercased().filter()
        if resString == "true" {
            return true
        } else if resString == "false" {
            return false
        }
        return nil
    }

    public var utf8Value: String? {
        var arr = [UInt8]()
        arr += utf8
        return String(bytes: arr, encoding: .utf8)
    }

    public var dictValue: [String: Any]? {
        return self
            .data(using: .utf8)
            .flatMap { try? JSONSerialization.jsonObject(with: $0, options: .mutableContainers) as? [String: Any] }
    }
}

// MARK: - Base64
extension String {

    /// base64 加密
    public func encodeToBase64() -> String {
        return Data(utf8).base64EncodedString()
    }

    /// base64 解密
    public func decodeFromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - manipulate funcs
extension String {

    /// 滤空和换行
    public func filter(_ set: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: set).joined(separator: .empty)
    }

    /// 链式判断是否包含特定string
    public func isContains(_ string: String) -> String? {
        return contains(string) ? self : nil
    }

    /// 链式判空
    public func isEmpty(isfilter: Bool = true) -> String? {
        if isfilter {
            let filtedString = filter()
            return filtedString.count > 0 ? filtedString : nil
        }
        return count > 0 ? self : nil
    }

    /// 中文字符串转换为拼音
    public func transformToPinyin() -> String? {
        return self
            .applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripCombiningMarks, reverse: false)
    }

    /// 中文字符串转换为拼音首字母
    public func transformToPinyinHeader() -> String? {
        let pinyin = transformToPinyin()
        let pinyinCompare = pinyin?.capitalized
        var headPinyinStr = String.empty
        let _ = pinyinCompare?.map { if $0 <= "Z" && $0 >= "A" { headPinyinStr.append($0) } }
        return headPinyinStr.isEmpty()
    }

    /// 判断是否合法账号
    public func isValidAccount() -> Bool {
        let regex = "^[a-zA-Z0-9]{6,16}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 判断是否是邀请码
    public func isValidInviteCode() -> Bool {
        let regex = "^[0-9]{6}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 判断是否是QQ
    public func isValidQQ() -> Bool {
        let regex = "^[1-9][0-9]{4,12}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断密码是否合法
    public func isValidPassword() -> String? {
        return isValidPassword() ? self : nil
    }

    public func isValidPassword() -> Bool {
        let regex = "^[a-zA-Z0-9]{5,11}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断手机号码是否合法
    public func isValidMobile() -> String? {
        return isValidMobile() ? self : nil
    }

    public func isValidMobile() -> Bool {
        let regex = "^1\\d{10}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断邮箱地址是否合法
    public func isValidEmail() -> String? {
        return isValidEmail() ? self : nil
    }

    public func isValidEmail() -> Bool {
        let regex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断真实姓名是否合法
    public func isValidRealName() -> String? {
        return isValidRealName() ? self : nil
    }

    public func isValidRealName() -> Bool {
        let regex = "^[\\u4e00-\\u9fa5]{2,5}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断是否为金额
    public func isValidMoney() -> String? {
        return isValidMoney() ? self : nil
    }

    public func isValidMoney() -> Bool {
        let regex = "^([1-9]\\d{0,20}|0)([.]?|(\\.\\d{1,2})?)$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    /// 链式判断是否是纯汉字
    public func isPureChinese() -> String? {
        return isPureChinese() ? self : nil
    }

    public func isPureChinese() -> Bool {
        let regex = "^[\\u4e00-\\u9fa5]+$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    //获取字符串中所有数字
    public func toNumber() -> String {
        return filter().filter(CharacterSet.decimalDigits.inverted)
    }

    //获取字符串中所有数字和字母
    public func toNumberAndLetter() -> String {
        let temp = CharacterSet.init(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLMNBVCXZ1234567890")
        return filter().filter(temp.inverted)
    }
}

extension String {
    public enum ReplacingOptions {
        /// 正向
        case forwards
        /// 逆向
        case backwards
    }

    /// 删除一次字符串中出现的某个字符
    public func replacingOccurrenceOnce<Target, Replacement>(of target: Target,
                                                             with replacement: Replacement,
                                                             option: ReplacingOptions,
                                                             range searchRange: Range<Self.Index>? = nil,
                                                             caseInsensitive: Bool = true)
        -> String where Target : StringProtocol, Replacement : StringProtocol {
            let option1: String.CompareOptions
            switch option {
            case .backwards: option1 = .backwards
            case .forwards: option1 = .anchored
            }
            let options: String.CompareOptions
            if caseInsensitive { options = [option1, .caseInsensitive] }
            else { options = [option1] }
            if let range = range(of: target,
                                 options: options,
                                 range: searchRange,
                                 locale: nil) {
                return replacingCharacters(in: range,
                                           with: replacement)
            } else { return self }
    }
}

//MARK: 计算
extension String {
    func getTextWidth(_ textFont: UIFont) -> CGFloat {
        let temp = self as NSString
        let textRect = temp.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: textFont.lineHeight),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont],
                                         context: nil)
        return textRect.width
    }
}
