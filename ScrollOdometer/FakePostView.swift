//
//  FakePostView.swift
//  ScrollOdometer
//
//  Created by Andriy Kachalo on 9/1/24.
//

import SwiftUI
import LoremSwiftum

struct FakePostView: View
{
	let post: FakePost

	var body: some View
	{
		HStack(alignment: .top)
		{
//			RoundedRectangle(cornerRadius: 8)
			ZStack
			{
				Circle()
					.fill(.gray.opacity(0.16))
				
				Image(systemName: "person.fill")
					.foregroundColor(.gray.opacity(0.56))
					.font(.title2)
			}
				.frame(width: 40, height: 40)
	
			VStack(alignment: .leading, spacing: 4)
			{
				HStack(spacing: 2)
				{
					Text(post.author.name)
						.fontWeight(.semibold)
						.fixedSize()
				
					if post.author.isVerified
					{
						Image(systemName: "checkmark.seal.fill")
							.foregroundColor(.blue)
							.font(.caption.weight(.bold))
					}
					
					Text("@" + post.author.handle)
						.foregroundColor(.secondary)
					
					Spacer()
					
					Text(post.timestamp, format: .relative(presentation: .numeric))
						.foregroundColor(.secondary)
						.font(.caption)
				}
				.lineLimit(1)
			
				Text(post.text)
				
				if case .image(let width, let height) = post.content
				{
					RoundedRectangle(cornerRadius: 8)
						.fill(.gray.opacity(0.18))
//						.frame(height: 200)
						.frame(maxWidth: .infinity)
						.aspectRatio(width / height, contentMode: .fit)
						.overlay
						{
							Image(systemName: "photo")
								.font(.largeTitle)
								.foregroundColor(.gray.opacity(0.25))
						}
				}
				else if case .link(let title, let domain) = post.content
				{
					VStack(alignment: .leading)
					{
						ZStack(alignment: .bottomLeading)
						{
							RoundedRectangle(cornerRadius: 8)
								.fill(.gray.opacity(0.18))
								.frame(height: 200)
								.overlay
								{
									Image(systemName: "link")
										.font(.largeTitle)
										.foregroundColor(.gray.opacity(0.25))
								}
						
							Text(title)
								.font(.caption)
								.shadow(color: .white, radius: 1)
								.padding(.vertical, 6)
								.padding(.horizontal)
						}
						Text("From " + domain)
							.font(.caption)
							.foregroundColor(.secondary)
							.padding(.horizontal)
					}
					.padding(.top, 6)
				}
			
				HStack(spacing: 16)
				{
					Label(post.comments.formatted(.number), systemImage: "bubble.right")
					Label(post.reposts.formatted(.number), systemImage: "arrow.2.squarepath")
					Label(post.likes.formatted(.number), systemImage: "heart")
					Label(post.views.formatted(.number), systemImage: "chart.bar")
					Label(post.bookmarks.formatted(.number), systemImage: "bookmark")
				}
				.font(.caption)
				.foregroundColor(.secondary)
				.labelStyle(CustomLabelStyle())
				.padding(.top, 8)
			}
			.font(.callout)
			
			Spacer()
		}
		.padding()
		.overlay(alignment: .bottom)
		{
			Divider()
		}
	}
}

struct CustomLabelStyle: LabelStyle
{
	func makeBody(configuration: Configuration) -> some View
	{
		HStack(spacing: 2)
		{
			configuration.icon
			configuration.title
		}
	}
}

// swiftlint:disable line_length

#Preview("Text")
{
	FakePostView(post: FakePost(timestamp: Date(timeIntervalSinceNow: 60 * 60 * -5), author: FakePerson(name: "John Doe", handle: "johndoe", isVerified: true), text: Lorem.sentences(4), content: .none, comments: Int.random(in: 1...25), likes: Int.random(in: 1...100), reposts: Int.random(in: 1...10), views: Int.random(in: 100...1000), bookmarks: Int.random(in: 1...5)))
}

#Preview("Link")
{
	FakePostView(post: FakePost(timestamp: Date(timeIntervalSinceNow: 60 * 60 * -10), author: FakePerson(name: "John Doe", handle: "johndoe", isVerified: true), text: Lorem.sentences(4), content: .link(title: "Title", domain: "host.com"), comments: Int.random(in: 1...25), likes: Int.random(in: 1...100), reposts: Int.random(in: 1...10), views: Int.random(in: 100...1000), bookmarks: Int.random(in: 1...5)))
}

#Preview("Image - Landscape")
{
	FakePostView(post: FakePost(timestamp: Date(timeIntervalSinceNow: 60 * 60 * -15), author: FakePerson(name: "John Doe", handle: "johndoe", isVerified: true), text: Lorem.sentences(4), content: .image(width: 640, height: 480), comments: Int.random(in: 1...25), likes: Int.random(in: 1...100), reposts: Int.random(in: 1...10), views: Int.random(in: 100...1000), bookmarks: Int.random(in: 1...5)))
}

#Preview("Image - Portrait")
{
	FakePostView(post: FakePost(timestamp: Date(timeIntervalSinceNow: 60 * 60 * -20), author: FakePerson(name: "John Doe", handle: "johndoe", isVerified: true), text: Lorem.sentences(4), content: .image(width: 320, height: 480), comments: Int.random(in: 1...25), likes: Int.random(in: 1...100), reposts: Int.random(in: 1...10), views: Int.random(in: 100...1000), bookmarks: Int.random(in: 1...5)))
}

// swiftlint:enable line_length
