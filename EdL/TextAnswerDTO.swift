//
//  TextAnswerDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import EVReflection

class TextAnswerDTO: EVObject {
    
    var questionID: Int
    var questionText: String
    var answerText: String = ""
    
    init(questionID: Int, questionText: String) {
        self.questionID = questionID
        self.questionText = questionText
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}
