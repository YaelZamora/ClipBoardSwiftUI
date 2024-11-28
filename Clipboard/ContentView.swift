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
    @State private var clipboardHistory: [String] = UserDefaults.standard.stringArray(forKey: "clipHistory") ?? []
    
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
            
            List {
                ForEach(clipboardHistory, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .padding()
    }
    
    func paste() {
        if let string = clipboard.string {
            clipboardHistory.insert(string, at: 0)
            UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
        }
    }
    
    func copyToClipboard() {
        clipboard.string = self.text
        clipboardHistory.insert(text, at: 0)
        UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
        self.text = ""
        self.ButtonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.ButtonText = "Copy to Clipboard"
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        clipboardHistory.remove(atOffsets: offsets)
        UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
    }
}

#Preview {
    ContentView()
}
