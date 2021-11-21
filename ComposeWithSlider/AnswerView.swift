//
//  AnswerView.swift
//  AnswerView
//
//  Created by Leonore Yardimli on 2021/11/10.
//

import SwiftUI

struct AnswerView: View {
	@Binding var isPresented:Bool
	var body: some View {
		VStack{
			Image("badge_correct_answer")
		}
	}
}

struct AnswerView_Previews: PreviewProvider {
	static var previews: some View {
		AnswerView(isPresented: .constant(false))
	}
}
