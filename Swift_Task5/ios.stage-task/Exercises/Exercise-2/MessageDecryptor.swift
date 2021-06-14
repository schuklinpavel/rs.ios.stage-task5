import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789[]")
        guard (message as NSString).length >= 1,
              (message as NSString).length <= 60,
              (message.rangeOfCharacter(from: charSet.inverted) == nil) else {
            return ""
        }
        
        let textRegEx = #"[^\d\[\]]+"#
        var result = message
        var numbersRange = result.rangeOfCharacter(from: .decimalDigits)
        var isContainBracket = result.contains("[")

        if (numbersRange == nil) {
            let textRange = result.range(of: textRegEx, options: .regularExpression)
            return String(result[textRange!])
        }
        
        while (numbersRange != nil || isContainBracket) {
            guard let range = result.range(of: #"\d*\[[^\]\[]+\]"#, options: .regularExpression) else { return "" }

            let countRange = result[range].range(of: #"\d+"#, options: .regularExpression)
            let count = (countRange != nil) ? Int(result[countRange!]) ?? 1 : 1
            
            guard count >= 1, count <= 300 else {
                return ""
            }
            
            let textRange = result[range].range(of: textRegEx, options: .regularExpression)

            if  let textR = textRange {
                let text = result[textR]
                let repeatedText = String(repeating: String(text), count: count)
                
                result.replaceSubrange(range, with: repeatedText)
            }
            numbersRange = result.rangeOfCharacter(from: .decimalDigits)
            isContainBracket = result.contains("[")
        }
        return result
    }

    
    func decryptMessageAnotherTEMPtry(_ message: String) -> String {
        guard message.count >= 4 else {
            return ""
        }
        
        let textRegEx = #"[^\d\[\]]+"#
        var result = message
        var numbersRange = result.rangeOfCharacter(from: .decimalDigits)

        if (numbersRange == nil) {
            let textRange = result.range(of: textRegEx, options: .regularExpression)
            return String(result[textRange!])
        }
        
        while (numbersRange != nil) {
            let endIndex = result.firstIndex(of: "]")
           // let startIndex = result.firstIndex(of: "[", options: .back)
            
            
           // result = temp
            numbersRange = result.rangeOfCharacter(from: .decimalDigits)
        }
        
        return result
    }
    
    func decryptMessageFromGeneralToParticular(_ message: String) -> String {
        guard message.count >= 4 else {
            return ""
        }
        
        let textRegEx = #"[^\d\[\]]+"#
        var result = message
        var numbersRange = result.rangeOfCharacter(from: .decimalDigits)

        if (numbersRange == nil) {
            let textRange = result.range(of: textRegEx, options: .regularExpression)
            return String(result[textRange!])
        }
        
        while (numbersRange != nil) {
            let countRange = result.range(of: #"\d+"#, options: .regularExpression)
            let count = (countRange != nil) ? Int(result[countRange!]) ?? 1 : 1
            
            var leftBracketCount = 0
            var temp = ""
            var textInBrackets = ""
            var isCopy = false
            
            for char in result {
                if isCopy {
                    temp += String(char)
                } else {
                    if char == "[" {
                        leftBracketCount += 1
                    } else if char == "]" {
                        leftBracketCount -= 1
                        if leftBracketCount <= 0 {
                            let repeatedText = String(repeating: String(textInBrackets), count: count)
                            temp += repeatedText
                            isCopy = true
                            // break
                        }
                    } else {
                        if leftBracketCount > 0 {
                            textInBrackets += String(char)
                        } else {
                            let strChar = String(char)
                            if (strChar.rangeOfCharacter(from: .decimalDigits) == nil) {
                                temp += strChar
                            }
                        }
                    }
                }
            }
            
            result = temp
            numbersRange = result.rangeOfCharacter(from: .decimalDigits)
        }
        
        return result
    }
    
    func decryptMessageREGEXP(_ message: String) -> String {
        guard message.count >= 4 else {
            return ""
        }
        
        do {
//            let regexp = try NSRegularExpression(pattern: #"[0-9]+\[[^\]]+\]"#, options: [])
//            let number = regexp.matches(in: message, options: [], range: NSMakeRange(0, (message as NSString).length))
            
            // let textRegEx = #"[^\d\[][^\]]+"#
            let textRegEx = #"[^\d\[\]]+"#
            
            var result = message
            
            var numbersRange = result.rangeOfCharacter(from: .decimalDigits)

            if (numbersRange == nil) {
                let textRange = result.range(of: textRegEx, options: .regularExpression)
                return String(result[textRange!])
            }
            
            while (numbersRange != nil) {
                guard let range = result.range(of: #"[0-9]*\[[^\]]+\]"#, options: .regularExpression) else { return "" }

                
                let countRange = result[range].range(of: #"\d+"#, options: .regularExpression)
                let textRange = result[range].range(of: textRegEx, options: .regularExpression)
                print("_____++++++++++____")
 
                if  let textR = textRange {
                    let count = (countRange != nil) ? Int(result[countRange!]) ?? 1 : 1
                    let text = result[textR]
                    let repeatedText = String(repeating: String(text), count: count)
                    
                    result.replaceSubrange(range, with: repeatedText)
                    print("____________________")
                    print(result)
                }
                numbersRange = result.rangeOfCharacter(from: .decimalDigits)
            }
            
            return result
            
        } catch let error as NSError {
            print("Mathing filed")
            print(error)
        }
        return ""
    }
}
