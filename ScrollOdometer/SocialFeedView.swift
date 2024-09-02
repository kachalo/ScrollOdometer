//
//  InfiniteScrollView.swift
//  ScrollOdometer
//
//  Created by Andriy Kachalo on 8/28/24.
//

import UIKit
import SwiftUI
import LoremSwiftum

class SocialFeedView: UIScrollView
{
	let stackView: UIStackView
	
	weak var socialFeedDelegate: SocialFeedViewDelegate?
	
	private var _isReady = false
	
	override init(frame: CGRect)
	{
		let posts = (0...50).map
						{ index in
							
							let fakeName = Lorem.fullName
							let fakeHandle = fakeName.lowercased().replacingOccurrences(of: " ", with: "")
							
							let content: FakePostContent
							switch Int.random(in: 0...5)
							{
							case 0:
								content = .image(width: CGFloat(Int.random(in: 320...640)), height: CGFloat(Int.random(in: 320...640)))
							case 1:
								content = .link(title: Lorem.title, domain: URL(string: Lorem.url)?.host() ?? "host.com")
							default:
								content = .none
							}
							
							let author = FakePerson(name: fakeName, handle: fakeHandle, isVerified: Bool.random())
							let timestamp = Date(timeIntervalSinceNow: TimeInterval((index + 1 + Int.random(in: 0...5)) * -60))
														
							return FakePost(timestamp: timestamp,
											author: author,
											text: Lorem.tweet,
											content: content,
											comments: Int.random(in: 1...15),
											likes: Int.random(in: 1...100),
											reposts: Int.random(in: 1...10),
											views: Int.random(in: 250...1000),
											bookmarks: Int.random(in: 1...5))
						}
	
		let postViews = posts.map { return UIHostingController(rootView: FakePostView(post: $0)).view! }
	
		stackView = UIStackView(arrangedSubviews: postViews)
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
	
		super.init(frame: frame)
		
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false
		
		addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static let kScrolledDistanceKey = "ScrolledDistance"
	
	var distance: CGFloat = CGFloat(UserDefaults.standard.float(forKey: SocialFeedView.kScrolledDistanceKey))
	{
		didSet
		{
			UserDefaults.standard.setValue(distance, forKey: Self.kScrolledDistanceKey)
		}
	}
	
	override var contentOffset: CGPoint
	{
		didSet
		{
			guard _isReady else { return }
			
			distance += abs(oldValue.y - contentOffset.y)
			scrollingInProgress = true
		
			socialFeedDelegate?.socialFeedViewDidScroll(to: distance, scrollingInProgress: scrollingInProgress)
		}
	}
	
	private var _timer: Timer?
	var scrollingInProgress: Bool = false
	{
		didSet
		{
			if scrollingInProgress != oldValue
			{
				if scrollingInProgress
				{
					_timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
						self?.scrollingInProgress = false
					}
				}
			
				socialFeedDelegate?.socialFeedViewDidScroll(to: distance, scrollingInProgress: scrollingInProgress)
			}
		}
	}
		
	override func layoutSubviews()
	{
		super.layoutSubviews()
	
		_adjustInfiniteScroll()
		
		contentSize = stackView.frame.size
	}
	
	private var kScrollThreshold: CGFloat
	{
		return (contentSize.height - bounds.height) / 3.25
	}
	
	private func _adjustInfiniteScroll()
	{
		_isReady = false
		defer
		{
			_isReady = true
		}
		
		if bounds.minY < kScrollThreshold
		{
			guard let lastView = stackView.arrangedSubviews.last else { return }
			let offset = lastView.frame.height
			stackView.removeArrangedSubview(lastView)
			stackView.insertArrangedSubview(lastView, at: 0)

			var newOffset = contentOffset
			newOffset.y += offset
			contentOffset = newOffset
		}
		else if bounds.maxY > contentSize.height - kScrollThreshold
		{
			guard let firstView = stackView.arrangedSubviews.first else { return }
			let offset = firstView.frame.height
			stackView.removeArrangedSubview(firstView)
			stackView.addArrangedSubview(firstView)

			var newOffset = contentOffset
			newOffset.y -= offset
			contentOffset = newOffset
		}
	}
}

protocol SocialFeedViewDelegate: AnyObject
{
	func socialFeedViewDidScroll(to distance: CGFloat, scrollingInProgress: Bool)
}

struct InfiniteScrollViewRep: UIViewRepresentable
{
	let distance: Binding<CGFloat>
	let scrollingInProgress: Binding<Bool>

	func makeUIView(context: Context) -> SocialFeedView
	{
		let result = SocialFeedView()
		result.socialFeedDelegate = context.coordinator
		return result
	}
	
	func updateUIView(_ uiView: SocialFeedView, context: Context)
	{
	}
	
	func makeCoordinator() -> Coordinator
	{
		Coordinator(distance: distance, scrollingInProgress: scrollingInProgress)
	}
	
	class Coordinator: SocialFeedViewDelegate
	{
		
		let bindingDistance: Binding<CGFloat>
		let bindingScrollingInProgress: Binding<Bool>

		init(distance inDistance: Binding<CGFloat>, scrollingInProgress inScrollInProgress: Binding<Bool>)
		{
			bindingDistance = inDistance
			bindingScrollingInProgress = inScrollInProgress
		}

		func socialFeedViewDidScroll(to distance: CGFloat, scrollingInProgress: Bool)
		{
			bindingDistance.wrappedValue = distance
			bindingScrollingInProgress.wrappedValue = scrollingInProgress
		}
	}
}
