//
//  ChoiceDTO.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import EVReflection

class ChoiceDTO: EVObject {
    
    var choiceText: String
    var grade: Int
    
    init(choiceText: String, grade: Int){
        self.choiceText = choiceText
        self.grade = grade
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}
