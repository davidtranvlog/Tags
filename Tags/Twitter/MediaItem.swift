//
//  MediaItem.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// holds the network url and aspectRatio of an image attached to a Tweet
// created automatically when a Tweet object is created

public struct MediaItem
{
    public let url: NSURL!
    public let aspectRatio: Double
    
    public var description: String { return (url.absoluteString ?? "no url") + " (aspect ratio = \(aspectRatio))" }
    
    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        let h = data?.valueForKeyPath(TwitterKey.Height) as? NSNumber
        let w = data?.valueForKeyPath(TwitterKey.Width) as? NSNumber
        
        if h == nil || w == nil || h?.doubleValue == 0 {
            self.url = NSURL()
            self.aspectRatio = 0
            return nil
        }
        
        if let urlString = data?.valueForKeyPath(TwitterKey.MediaURL) as? NSString {
            if let url = NSURL(string: urlString as String) {
                self.url = url
                aspectRatio = w!.doubleValue / h!.doubleValue
            } else {
                self.url = NSURL()
                aspectRatio = 0
                return nil
            }
        } else {
            self.url = NSURL()
            aspectRatio = 0
            return nil
        }
    }
    
    struct TwitterKey {
        static let MediaURL = "media_url_https"
        static let Width = "sizes.large.w"
        static let Height = "sizes.large.h"
    }
}
