//
//  LessonToday.swift
//  LessonToday
//
//  Created by Leonore Yardimli on 2021/11/10.
//

import Foundation
import SwiftUI

class LessonToday: ObservableObject {
	@Published var subject:String = "我們來組句子！"
	@Published var quiz: [Quiz] = [
		Quiz(asking: "草是什麼顏色？", answer: ["草是","綠色的","。"], picture:"", status: 0),
		Quiz(asking: "雲是什麼顏色？", answer: ["雲是","白色的","。"], picture:"", status: 0)
	]
	@Published var at = 0
	@Published var myTheme:MyTheme = MyTheme()
	@Published var userFolderPath = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.path+"/Ege/class_writing/macos/ComposeWithSlider").path
	
	init() {
		loadLocalFile(forName: "lesson-type_simple_answer")
	}
	
	private func loadLocalFile(forName name: String) {
		do {
			let lessonFile = userFolderPath+"/lesson_today.json"
			if let jsonData = try String(contentsOfFile: lessonFile).data(using: .utf8) {
				let decodedData = try JSONDecoder().decode(Lesson.self, from: jsonData)
				subject = decodedData.subject
				quiz = decodedData.quiz
				//quiz.shuffle()
				
				myTheme = MyTheme(setThemeName: decodedData.theme)
			}
		} catch {
			print(error)
		}
	}
	
	
}
