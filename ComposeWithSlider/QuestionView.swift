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
							.frame(width:400, height:400)
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
										DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
											makeSentence.append(rememberWord)
											animateSentence = false
											isSentenceFinished()
										}
									})
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
									if (makeSentence.joined(separator: "")==lessonToday.quiz[lessonToday.at].answer.joined(separator: "")) && lessonToday.at==lessonToday.quiz.count-1 {
										goToView = "FinishedView"
									}else{
										showAnswer = true
									}
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
								Text(minValueLabel())
									.foregroundColor(Color.gray)
									.font(.system(size:24))
								
								Slider(value: $sideBarValue, in:0.0...Double(lessonToday.quiz[lessonToday.at].answer.count-1), onEditingChanged: { editing in
									print(sideBarValue)
									
									if editing == false {
										//stop dragging
										//self.pickAWord()
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
								
								Text(maxValueLabel())
									.foregroundColor(Color.gray)
									.font(.system(size:24))
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
					Image(lessonToday.myTheme.contentPageBackground)
						.resizable()
				)
				.sheet(isPresented: $showAnswer){
					if makeSentence.joined(separator: "")==lessonToday.quiz[lessonToday.at].answer.joined(separator: "") {
						CorrectAnswerView(isPresented: $showAnswer)
							.onDisappear(perform: {
								lessonToday.at = lessonToday.at + 1
								resetQuestionValue()
							})
					}else{
						WrongAnswerView(isPresented:$showAnswer, getMakeSentence: makeSentence)
							.onDisappear(perform: {
								lessonToday.quiz.append(lessonToday.quiz[lessonToday.at])
								lessonToday.at = lessonToday.at + 1
								resetQuestionValue()
							})
					}
					
				}
		}else{
			if goToView=="FinishedView" {
				FinishedView()
			}
		}
	}
	
	private func pickAWord(){
		let chooseWord = lessonToday.quiz[lessonToday.at].answer[Int(sideBarValue.rounded())]
		if makeSentence.contains(chooseWord){
			//word exists. play ding sound
			SoundManager.instance.playSound(sound: lessonToday.myTheme.duplicatedWord)
		}else{
			//makeSentence.append(chooseWord)
			rememberWord = chooseWord
			print(chooseWord)
			print(makeSentence.count)
			SoundManager.instance.playSound(sound: lessonToday.myTheme.chooseWord)
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
	
	private func resetQuestionValue(){
		makeSentence = []
		showAnswerBtn = false
		sideBarValue = 0.0
	}
	
	private func minValueLabel()->String{
		return String(Int(sideBarValue.rounded())+1)+"/"+String(lessonToday.quiz[lessonToday.at].answer.count)
	}
	
	private func maxValueLabel()->String{
		return String(lessonToday.quiz[lessonToday.at].answer.count)+"/"+String(lessonToday.quiz[lessonToday.at].answer.count)
	}
}

struct QuestionView_Previews: PreviewProvider {
	static var previews: some View {
		QuestionView().environmentObject(LessonToday())
	}
}
