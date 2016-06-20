//
//  MultipleCoiceAnswerDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

class MultipleChoiceAnswerDTO {
    
    var questionText: String
    var choice: ChoiceDTO?
    
    init(questionText: String) {
        self.questionText = questionText
    }
    
}
