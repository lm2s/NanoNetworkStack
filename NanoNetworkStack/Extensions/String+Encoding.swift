//
//  String+Encoding.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 12/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation

extension String {
    func percentEscaped() -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        var string = self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        
        return string
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
}
