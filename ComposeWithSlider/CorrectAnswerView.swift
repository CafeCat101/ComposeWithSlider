//
//  CorrectAnswerView.swift
//  CorrectAnswerView
//
//  Created by Leonore Yardimli on 2021/11/21.
//

import SwiftUI

struct CorrectAnswerView: View {
	@EnvironmentObject var lessonToday: LessonToday
	@Binding var isPresented:Bool
	
	var body: some View {
		VStack{
			Image("badge_correct_answer")
			
			Button(action: {
				withAnimation{
					isPresented = false
				}
			}) {
				Circle()
					.strokeBorder(Color.black, lineWidth: 1)
					.background(Circle().foregroundColor(Color.white.opacity(0.8)))
					.frame(width:70,height:70)
					.overlay(
						Image(systemName: "arrow.right")
							.resizable()
							.scaleEffect(0.6)
							.foregroundColor(Color.black)
					)
			}
			.buttonStyle(PlainButtonStyle())
		}
		.padding(20)
		.frame(minWidth:400, minHeight:400)
		.background(
			Image("chalkboard02_green")
				.resizable()
		)
		.onAppear(perform: {
			SoundManager.instance.playSound(sound: lessonToday.myTheme.correctAnswerAudio)
		})
	}
}

struct CorrectAnswerView_Previews: PreviewProvider {
	static var previews: some View {
		CorrectAnswerView(isPresented: .constant(false)).environmentObject(LessonToday())
	}
}
