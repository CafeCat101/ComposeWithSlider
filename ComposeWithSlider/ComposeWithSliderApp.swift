//
//  ComposeWithSliderApp.swift
//  ComposeWithSlider
//
//  Created by Leonore Yardimli on 2021/11/10.
//

import SwiftUI

@main
struct ComposeWithSliderApp: App {
	@StateObject var lessonToday = LessonToday()
	var body: some Scene {
		WindowGroup {
			WelcomeView().environmentObject(lessonToday)
		}
	}
}
