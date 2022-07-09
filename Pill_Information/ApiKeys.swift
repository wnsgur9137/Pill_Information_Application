//
//  key.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/07/08.
//

import Foundation

public class ApiKeys {
    
    private let DrbEasyDrugListKey = "LK5HxMQO7ScyFpgYc6%2BQgNRsqPfAKmnW1fczw8kHYE4BDXCaUX7uBUrZXK6wXoDnS5vivk2h0fYiboTWVjRjvQ%3D%3D"
    
    private let MdcinGrnIdntfcInfoListKey = "LK5HxMQO7ScyFpgYc6%2BQgNRsqPfAKmnW1fczw8kHYE4BDXCaUX7uBUrZXK6wXoDnS5vivk2h0fYiboTWVjRjvQ%3D%3D"
    
    public func getDrbEasyDrugListKey()->String {
        return self.DrbEasyDrugListKey
    }
    
    func getMdcinGrnIdntfcInfoListKey()->String {
        return self.MdcinGrnIdntfcInfoListKey
    }

}
