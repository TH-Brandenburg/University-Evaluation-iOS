//
//  MultipleCoiceAnswerDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import EVReflection

class MultipleChoiceAnswerDTO: EVObject {
    
    var questionText: String
    var choice: ChoiceDTO?
    
    init(questionText: String) {
        self.questionText = questionText
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}
