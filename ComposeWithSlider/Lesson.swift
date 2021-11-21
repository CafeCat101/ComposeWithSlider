//
//  Lesson.swift
//  Lesson
//
//  Created by Leonore Yardimli on 2021/11/10.
//

import Foundation
struct Lesson: Codable{
	var subject:String
	var theme:String
	var quiz:[Quiz]
}

struct Quiz: Codable{
	var asking:String
	var answer:[String]
	var picture:String
	var status:Int
}
