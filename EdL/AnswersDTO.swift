//
//  AnswersDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

class AnswersDTO {
    
    var voteToken: String
    var studyPath: String?
    var textAnswers: [TextAnswerDTO] = []
    var mcAnswers: [MultipleChoiceAnswerDTO] = []
    var deviceID: String
    
    init(voteToken: String, deviceID: String) {
        self.voteToken = voteToken
        self.deviceID = deviceID
    }
    
}