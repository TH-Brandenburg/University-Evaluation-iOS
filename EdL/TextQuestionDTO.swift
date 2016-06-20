//
//  TextQuestionDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

class TextQuestionDTO {
    
    var questionID: Int
    var questionText: String
    var onlyNumbers: Bool
    var maxLength: Int
    
    init(questionID: Int, questionText: String, onlyNumbers: Bool, maxLength: Int){
        self.questionID = questionID
        self.questionText = questionText
        self.onlyNumbers = onlyNumbers
        self.maxLength = maxLength
    }
    
}
