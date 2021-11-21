//
//  QuestionView.swift
//  QuestionView
//
//  Created by Leonore Yardimli on 2021/11/10.
//

import SwiftUI

struct QuestionView: View {
	@State private var goToView = "QuestionView"
	@State private var answer:String = ""
	@EnvironmentObject var lessonToday: LessonToday
	@State private var sideBarValue: Double = 0.0
	@State private var makeSentence:[String] = []
	@State private var animateSentence = false
	@State private var rememberWord = ""
	@State private var showAnswerBtn = false
	@State private var showAnswer = false
	
	var body: some View {
		if goToView == "QuestionView"{
			VStack{
				Spacer()
				
				HStack{
					Spacer()
					if let image = NSImage(contentsOf: URL(fileURLWithPath: lessonToday.userFolderPath+"/"+lessonToday.quiz[lessonToday.at].picture)) {
						Image(nsImage: image)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.shadow(color:.black, radius: 3, x:1, y: 1)
							.border(Color.white, width: 5)
							.frame(width:300, height:300)
					}
					Spacer().frame(width:20)
					
					VStack{
						HStack{
							Text(lessonToday.quiz[lessonToday.at].asking)
								.font(.system(size:50))
								.foregroundColor(Color.white)
							Spacer()
						}
						
						Spacer().frame(height:50)
						
						HStack{
							Text("\(makeSentence.joined(separator: ""))")
								.font(.system(size:55))
								.foregroundColor(Color.yellow)
							
							if animateSentence==true{
								Text(rememberWord)
									.font(.system(size:55))
									.foregroundColor(Color.white)
									.transition(.offset(x: 0, y: 50))
									.onAppear(perform: {
										DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
											makeSentence.append(rememberWord)
											animateSentence = false
											isSentenceFinished()
										}
									})
								/*
								SelectedWordView(selectedWord: $rememberWord)
									.transition(.offset(x: 0, y: 50))
									.onAppear(perform: {
										DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
											makeSentence.append(rememberWord)
											animateSentence = false
											isSentenceFinished()
										}
									})*/
							}
							
							Spacer()
							Button(action: {
								if makeSentence.count>0 {
									makeSentence.removeLast()
									isSentenceFinished()
								}
							}) {
								RoundedRectangle(cornerRadius: 22, style: .continuous)
									.strokeBorder(Color.white,lineWidth: 1)
									.background(
										RoundedRectangle(cornerRadius: 22, style: .continuous)
											.foregroundColor(Color.black.opacity(0.3)))
									.frame(width:60,height:60)
									.overlay(
										Image(systemName: "delete.left")
											.foregroundColor(Color.white)
									)
							}.buttonStyle(PlainButtonStyle())
							
							if showAnswerBtn==true {
								Button(action: {
									/*if self.answer == lessonToday.quiz[lessonToday.currentLessonAt].answer {
									 lessonToday.quiz[lessonToday.currentLessonAt].status = 1
									 }else{
									 lessonToday.quiz[lessonToday.currentLessonAt].status = -1
									 }
									 withAnimation{
									 self.goToView = "AnswerView"
									 }*/
								}) {
									RoundedRectangle(cornerRadius: 22, style: .continuous)
										.strokeBorder(Color.white,lineWidth: 1)
										.background(
											RoundedRectangle(cornerRadius: 22, style: .continuous)
												.foregroundColor(Color.black.opacity(0.3)))
										.frame(width:180,height:60)
										.overlay(
											Text("回答")
												.font(.system(size: 30))
												.fontWeight(.semibold)
												.foregroundColor(Color.white)
										)
								}
								.buttonStyle(PlainButtonStyle())
								.transition(.offset(x: 0, y: -50))
							}
						}
						.padding(20)
						.background(
							RoundedRectangle(cornerRadius: 25, style: .continuous)
								.strokeBorder(Color.white,lineWidth: 1)
						)
						
						Spacer().frame(height:50)
						
						VStack{
							Button(action:{
								self.pickAWord()
							}){
								Text("\(lessonToday.quiz[lessonToday.at].answer[Int(sideBarValue.rounded())])")
									.font(.system(size:40))
									.padding(10)
									.foregroundColor(Color.black)
									.background(
										RoundedRectangle(cornerRadius: 25, style: .continuous)
											.strokeBorder(Color.black,lineWidth: 1)
											.background(
												RoundedRectangle(cornerRadius: 25, style: .continuous)
													.foregroundColor(Color.white))
									)
							}.buttonStyle(PlainButtonStyle())
							
							HStack{
								Slider(value: $sideBarValue, in:0.0...Double(lessonToday.quiz[lessonToday.at].answer.count-1), onEditingChanged: { editing in
									print(sideBarValue)
									if editing == false {
										//stop dragging
										self.pickAWord()
									}else{
										//dragging
										animateSentence = false
									}
								}).padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
									.background(
										RoundedRectangle(cornerRadius: 25, style: .continuous)
											.strokeBorder(Color.gray,lineWidth: 1)
											.background(
												RoundedRectangle(cornerRadius: 25, style: .continuous)
													.foregroundColor(Color("sliderBackground")))
									)
							}
							.frame(width:500)
							
						}
						.padding(20)
						.background(
							RoundedRectangle(cornerRadius: 25, style: .continuous)
								.strokeBorder(Color.gray,lineWidth: 1)
							/*.background(
							 RoundedRectangle(cornerRadius: 25, style: .continuous)
							 .foregroundColor(Color.white.opacity(0.4)))*/
						)
					}
					
					Spacer()
				}
				
				
				Spacer()
			}.padding(10)
				.background(
					Image("chalkboard05")
						.resizable()
				)
				.sheet(isPresented: $showAnswer){
					AnswerView()
				}
		}else{
			
		}
	}
	
	private func pickAWord(){
		let chooseWord = lessonToday.quiz[lessonToday.at].answer[Int(sideBarValue.rounded())]
		if makeSentence.contains(chooseWord){
			//word exists. play ding sound
		}else{
			//makeSentence.append(chooseWord)
			rememberWord = chooseWord
			print(chooseWord)
			print(makeSentence.count)
			withAnimation{
				animateSentence = true
			}
		}
	}
	
	private func isSentenceFinished(){
		if makeSentence.count == lessonToday.quiz[lessonToday.at].answer.count {
			withAnimation{
				showAnswerBtn = true
			}
		}else{
			withAnimation{
				showAnswerBtn = false
			}
		}
	}
}

struct QuestionView_Previews: PreviewProvider {
	static var previews: some View {
		QuestionView().environmentObject(LessonToday())
	}
}
