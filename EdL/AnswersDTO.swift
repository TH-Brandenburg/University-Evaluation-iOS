//
//  AnswersDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import EVReflection

class AnswersDTO: EVObject {
    
    var voteToken: String
    var studyPath: String?
    var textAnswers: [TextAnswerDTO] = []
    var mcAnswers: [MultipleChoiceAnswerDTO] = []
    var deviceID: String
    
    init(voteToken: String, deviceID: String) {
        self.voteToken = voteToken
        self.deviceID = deviceID
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}