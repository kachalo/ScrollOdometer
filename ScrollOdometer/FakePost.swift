//
//  FakePost.swift
//  ScrollOdometer
//
//  Created by Andriy Kachalo on 9/1/24.
//

import Foundation

struct FakePost: Identifiable
{
	let id = UUID()

	let timestamp: Date
	let author: FakePerson
	
	let text: String
	let content: FakePostContent
	
	let comments: Int
	let likes: Int
	let reposts: Int
	let views: Int
	let bookmarks: Int
}

struct FakePerson: Identifiable
{
	let name: String
	let handle: String
	let isVerified: Bool
	
	var id: String
	{
		return handle
	}
}

enum FakePostContent
{
	case none
	case image(width: CGFloat, height: CGFloat)
	case link(title: String, domain: String)
}
