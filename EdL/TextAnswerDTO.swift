//
//  TextAnswerDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

class TextAnswerDTO {
    
    var questionID: Int
    var questionText: String
    var answerText: String?
    
    init(questionID: Int, questionText: String) {
        self.questionID = questionID
        self.questionText = questionText
    }
    
}
