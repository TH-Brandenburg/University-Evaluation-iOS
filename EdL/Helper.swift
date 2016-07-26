//
//  Helper.swift
//  EdL
//
//  Created by Daniel Weis on 20.06.16.
//
//

import SwiftyJSON
import SSZipArchive

class Helper {
    
    /// Parse questions JSON from server
    /// - returns: QuestionsDTO containing parsed JSON content
    class func parseJSON(data: JSON) -> QuestionsDTO{
        let questions = QuestionsDTO()
        
        for (_, subJson):(String,JSON) in data["studyPaths"]{
            if let studyPath: String = subJson.string{
                questions.studyPaths.append(studyPath)
            }
        }
        
        for (_, mcqDtoJson):(String,JSON) in data["multipleChoiceQuestionDTOs"]{
            let mcqDto = MultipleChoiceQuestionDTO()
            if let question: String = mcqDtoJson["question"].string{
                mcqDto.question = question
            }
            for (_, qDtoJson):(String,JSON) in mcqDtoJson["choices"]{
                if qDtoJson["choiceText"].string != nil && qDtoJson["grade"].int != nil {
                    mcqDto.choices.append(ChoiceDTO(choiceText: qDtoJson["choiceText"].string!, grade: qDtoJson["grade"].int!))
                }
            }
            questions.multipleChoiceQuestions.append(mcqDto)
        }
        
        for (_, tqDtoJson):(String,JSON) in data["textQuestions"]{
            if tqDtoJson["questionID"].int != nil && tqDtoJson["questionText"].string != nil && tqDtoJson["onlyNumbers"].bool != nil && tqDtoJson["maxLength"].int != nil{
                let tqDto = TextQuestionDTO(questionID: tqDtoJson["questionID"].int!, questionText: tqDtoJson["questionText"].string!, onlyNumbers: tqDtoJson["onlyNumbers"].bool!, maxLength: tqDtoJson["maxLength"].int!)
                questions.textQuestions.append(tqDto)
            }
            
        }
        
        if let textQuestionsFirst: Bool = data["textQuestionsFirst"].bool{
            questions.textQuestionsFirst = textQuestionsFirst
        }
        return questions
    }
    
    
    class func createAnswersDTO(questions: QuestionsDTO, voteToken: String, deviceID: String) -> AnswersDTO{
        let answers = AnswersDTO(voteToken: voteToken, deviceID: deviceID)
        
        for textQuestion in questions.textQuestions{
            let textAnswer = TextAnswerDTO(questionID: textQuestion.questionID, questionText: textQuestion.questionText)
            answers.textAnswers.append(textAnswer)
        }
        
        for mcQuestion in questions.multipleChoiceQuestions{
            let mcAnswer = MultipleChoiceAnswerDTO(questionText: mcQuestion.question)
            answers.mcAnswers.append(mcAnswer)
        }
        
        return answers
    }
    
    
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func zipImages() -> NSData? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let dataPath = documentsPath.stringByAppendingPathComponent("images")
        SSZipArchive.createZipFileAtPath("\(documentsPath)/images.zip", withContentsOfDirectory: dataPath, keepParentDirectory: false)
        return NSData(contentsOfFile: "\(documentsPath)/images.zip")
    }
    
    class func deleteAll() {
        let fileMgr = NSFileManager()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        if let directoryContents = try? fileMgr.contentsOfDirectoryAtPath(dirPath) {
            for path in directoryContents {
                let fullPath = (dirPath as NSString).stringByAppendingPathComponent(path)
                _ = try? fileMgr.removeItemAtPath(fullPath)
            }
        }
    }
    
}
