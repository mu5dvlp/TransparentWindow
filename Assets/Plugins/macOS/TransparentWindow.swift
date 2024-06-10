//
//  transparent.swift
//  TransparentInSwift
//
//  Created by kriver1 on 2018/05/23.
//  Copyright © 2018年 kriver1. All rights reserved.
//

import Foundation
import Cocoa

// from: http://tatsudoya.blog.fc2.com/blog-entry-244.html
// see: https://qiita.com/mybdesign/items/fe3e390741799c1814ad

public class NativeWindowManager : NSObject {

    // style mask
    // see: https://developer.apple.com/documentation/appkit/nswindow.stylemask
    // private static let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
    private static let styleMask: NSWindow.StyleMask = [.borderless]

    /// Initialize Unity window and set it to transparent and front.
    public static func initializeTransparent() -> Void {
        // get the window used by Unity (frontmost window object)
        let unityWindow: NSWindow = NSApp.orderedWindows[0]

        // step 1: set the Unity window transparent
        transparentizeWindow(window: unityWindow)

        // step 2: set the Unity view transparent
        transparentizeContentView(window: unityWindow)

        // step 3: make the window permanently front
        frontizeWindow(window: unityWindow)

        unityWindow.ignoresMouseEvents = true

        // step 4: observe notification
        // see: https://qiita.com/mono0926/items/754c5d2dbe431542c75e
        let center = NotificationCenter.default
        center.addObserver(forName: NSWindow.didBecomeMainNotification, object: nil, queue: nil, using: becomeMainListener(notification:))
        center.addObserver(forName: NSWindow.didResignMainNotification, object: nil, queue: nil, using: resignMainListener(notification:))
    }

    /// Set the window transparent.
    ///
    /// - Parameters:
    ///   - window: window to be transparent
    ///   - mask: window style (title bar, closable, or something else)
    private static func transparentizeWindow(window: NSWindow) -> Void {
        // set its style mask
        window.styleMask = styleMask
        // make it transparent
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        // remove its shadow
        window.hasShadow = false
    }

    /// Set the view transparent.
    ///
    /// - Parameter window: its content view is transparentized.
    private static func transparentizeContentView(window: NSWindow) -> Void {
        // if content view is nil, then do nothing
        if let view: NSView = window.contentView {
            // make it layer-backed
            // see: https://blog.fenrir-inc.com/jp/2011/07/nsview_uiview.html
            view.wantsLayer = true
            // make its layer transparent
            view.layer?.backgroundColor = CGColor.clear
            view.layer?.isOpaque = false
        }
    }

    /// Make the window permanently front.
    /// see: https://qiita.com/ocadaruma/items/790e96245c99e7af42a3
    ///
    /// - Parameter window: window to be permanently front
    private static func frontizeWindow(window: NSWindow) -> Void {
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.level = .floating
    }

    /// A listener for become main notification.
    ///
    /// - Parameter notification: Notification
    @objc private static func becomeMainListener(notification: Notification) -> Void {
        if let window = getWindowFromNotification(notification: notification) {
            toggleBorderAppearance(window: window, isShow: true)
        }
    }

    /// A listener for resign main notification.
    ///
    /// - Parameter notification: Notification
    @objc private static func resignMainListener(notification: Notification) -> Void {
        if let window = getWindowFromNotification(notification: notification) {
            toggleBorderAppearance(window: window, isShow: false)
        }
    }

    /// Safely get a window object from a notification object.
    ///
    /// - Parameter notification: Notification
    private static func getWindowFromNotification(notification: Notification) -> NSWindow? {
        if let window = (notification.object as? NSWindow) {
            return window
        } else {
            return nil
        }
    }

    /// Hide or show the border of the given window.
    ///
    /// - Parameters:
    ///   - window: a window to show/hide
    ///   - isShow: boolean value to indicate show or hide
    private static func toggleBorderAppearance(window: NSWindow, isShow: Bool) {
        window.styleMask = isShow ? styleMask : [.borderless]
        window.titlebarAppearsTransparent = !isShow
        window.titleVisibility = isShow ? .visible : .hidden
    }
}

@_cdecl("MakeWindowTransparent")
public func MakeWindowTransparent(){
    NativeWindowManager.initializeTransparent()
}