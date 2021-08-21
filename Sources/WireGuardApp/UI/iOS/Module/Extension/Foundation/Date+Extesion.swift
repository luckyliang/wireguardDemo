//
//  Date+Extesion.swift
//  Games
//
//  Created by 易 on 06/09/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation

extension Date {
    static private let _chinaFormatter = DateFormatter()
    static private let _serviceFromatter = DateFormatter()

    /// 获取当前手机时间对应的北京时间字符串
    ///
    /// - Parameter formatterString: 需要的事件字符串格式
    public static func nowTimeToChinaTimeString(formatterString: String = "yyyy-MM-dd HH:mm") -> String {
        guard let chinaTimeZone  = TimeZone(secondsFromGMT: 8 * 3600) else {
            return ""
        }
        _chinaFormatter.timeZone = chinaTimeZone
        _chinaFormatter.dateFormat = formatterString
        return _chinaFormatter.string(from: Date())
    }

    /// 将服务器返回的时间字符串转化为北京时间字符串
    /// - Parameters:
    ///   - serviceTimeString: 服务器给出的事件字符串
    ///   - serviceFormatterString: 服务器时间字符串对应的时间字符格式
    ///   - chinaForMatterString: 需要的事件字符串格式
    /// - Returns: 所需的北京时间字符串
    public static func serviceTimeStringToChinaTimeString(serviceTimeString:String, serviceFormatterString: String, chinaFormatterString: String = "yyyy-MM-dd HH:mm") -> String {
        guard let chinaTimeZone = TimeZone(secondsFromGMT: 8 * 3600), let serviceTimeZone = TimeZone(secondsFromGMT: 0) else {
            return ""
        }
        _serviceFromatter.timeZone = serviceTimeZone
        _serviceFromatter.dateFormat = serviceFormatterString

        if serviceTimeString.contains(".") {
            guard let temp = serviceTimeString.split(separator: ".").first, let serviceTime = _serviceFromatter.date(from: String(temp)) else {
                return serviceTimeString
            }
            _chinaFormatter.dateFormat = chinaFormatterString
            _chinaFormatter.timeZone     = chinaTimeZone
            return _chinaFormatter.string(from: serviceTime)
        }

        guard let serviceTime = _serviceFromatter.date(from: serviceTimeString) else {
            return serviceTimeString
        }
        _chinaFormatter.dateFormat = chinaFormatterString
        _chinaFormatter.timeZone     = chinaTimeZone
        return _chinaFormatter.string(from: serviceTime)
    }

    /// 中国时间字符串转化为对应的时间
    ///
    /// - Parameters:
    ///   - dateString: 时间字符串
    ///   - stringFormatter: 时间格式
    /// - Returns: 时间
    public static func chinaDateStringToChinaDate(dateString: String, stringFormatter: String = "yyyy-MM-dd") -> Date {
        guard let chinaTimeZone  = TimeZone(secondsFromGMT: 8 * 3600) else {
            return Date()
        }
        _chinaFormatter.dateFormat = stringFormatter
        _chinaFormatter.timeZone     = chinaTimeZone
        return _chinaFormatter.date(from: dateString) ?? Date()
    }

    public func chinaDateToString(formatterString: String) -> String {
        guard let chinaTimeZone  = TimeZone(secondsFromGMT: 8 * 3600) else {
            return ""
        }
        Date._chinaFormatter.timeZone = chinaTimeZone
        Date._chinaFormatter.dateFormat = formatterString
        return Date._chinaFormatter.string(from: self)
    }

    /// 当前时间的时间戳
    public static func nowTimeStamp() -> String {
        let temp = Date().timeIntervalSince1970 * 1000
        return String(format: "%.0f", temp)
    }


    /// 日期转时间搓字符串
    /// - Parameter dateString: 日期字符串
    /// - Parameter stringFormatter: 时间搓字符串
    public static func dateStringToTimeIntervalString(dateString: String, stringFormatter: String = "yyyy-MM-dd") -> String{
        let timeInterval = Date.chinaDateStringToChinaDate(dateString: dateString, stringFormatter: stringFormatter).timeIntervalSince1970
        return String(format: "%.0f", timeInterval)
    }

    /// 某天凌晨
    /// - Parameter dateString: 比如：2019-09-02
    /// - Parameter stringFormatter: 如：yyyy-MM-dd
    /// - Retruns: 当天凌晨时间搓
    public static func dayEarlyTimeIntervalStr(dateString: String, stringFormatter: String = "yyyy-MM-dd") -> String {
        return dateStringToTimeIntervalString(dateString: dateString, stringFormatter: stringFormatter)
    }

    /// 某天23:59:59d时的时间搓
    /// - Parameter dateString:时间
    /// - Parameter stringFormatter: 传入时间的格式
    public static func dayLatestTimeIntervalStr(dateString: String, stringFormatter: String = "yyyy-MM-dd") -> String {
        let startDate = Date.chinaDateStringToChinaDate(dateString: dateString, stringFormatter: stringFormatter)
        let endDate = startDate.addingTimeInterval(3600*24-1)

        return String(format: "%.0f", endDate.timeIntervalSince1970)
    }


    /// 时间搓转时间
    /// - Parameter interval: 时间搓
    /// - Parameter stringFormatter: 要转的时间格式
    public static func timeIntervalToChinaDate(intervalStr: String, stringFormatter: String = "yyyy-MM-dd HH:mm") -> String{
        guard let interval = intervalStr.doubleValue else { return .empty }
        let date = Date(timeIntervalSince1970: interval)
        _chinaFormatter.dateFormat = stringFormatter
        let time = _chinaFormatter.string(from: date)
        return time
    }

    public func year() -> String {
        let calendar = Calendar.current
        let dateComp = calendar.component(Calendar.Component.year, from: self)
        return NSString(format: "%4d", dateComp) as String
    }

    public func month() -> String {
        let calendar = Calendar.current
        let dateComp = calendar.component(Calendar.Component.month, from: self)
        return NSString(format: "%02d", dateComp)  as String
    }

    public func day() -> String {
        let calendar = Calendar.current
        let dateComp = calendar.component(Calendar.Component.day, from: self)
        return NSString(format: "%02d", dateComp)  as String
    }
}
