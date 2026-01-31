import SwiftUI
import WebKit

struct OAuthWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
//
//  OauthWebView.swift
//  OauthTask
//
//  Created by Jan Sakłak on 16/01/2026.
//

