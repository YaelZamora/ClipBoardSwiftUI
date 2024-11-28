//
//  ContentView.swift
//  Clipboard
//
//  Created by Yael Javier Zamora Moreno on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var ButtonText: String = "Copy to clipboard"
    private let clipboard = UIPasteboard.general
    @State private var textPasted = UserDefaults.standard.string(forKey: "clip")
    
    var body: some View {
        VStack {
            TextField("Add some text", text: $text)
            
            HStack {
                Button {
                    copyToClipboard()
                } label: {
                    Label(ButtonText, systemImage: "doc.on.doc.fill")
                }
                
                Spacer()
                
                Button {
                    paste()
                } label: {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }.tint(.orange)
            }
            
            Text(textPasted ?? "")
        }
        .padding()
    }
    
    func paste() {
        if let string = clipboard.string {
            textPasted = string
            UserDefaults.standard.set(string, forKey: "clip")
        }
    }
    
    func copyToClipboard() {
        clipboard.string = self.text
        self.text = ""
        self.ButtonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.ButtonText = "Copy to Clipboard"
        }
    }
}

#Preview {
    ContentView()
}
