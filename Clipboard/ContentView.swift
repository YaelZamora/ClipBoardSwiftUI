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
    @State private var selectedCategory: String = "General"
    @State private var newCategory: String = ""
    @State private var showingAddCategory: Bool = false
    private let clipboard = UIPasteboard.general
    
    @State private var clipboardHistory: [String: [String]] = UserDefaults.standard.object(forKey: "clipHistory") as? [String: [String]] ?? ["General": []]
    
    private var categories: [String] {
        Array(clipboardHistory.keys).sorted()
    }
    
    var body: some View {
        VStack {
            TextField("Add some text", text: $text)
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedCategory == category ? 
                                            Color.blue : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        selectedCategory == category ? 
                                            .white : .primary
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.trailing, 10)
                }
                
                Button(action: { showingAddCategory = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
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
                ForEach(categories, id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(clipboardHistory[category] ?? [], id: \.self) { item in
                            Text(item)
                        }
                        .onDelete { indexSet in
                            deleteItems(at: indexSet, in: category)
                        }
                    }
                }
            }
        }
        .padding()
        .alert("Add New Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategory)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                if !newCategory.isEmpty {
                    clipboardHistory[newCategory] = []
                    UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
                    newCategory = ""
                }
            }
        }
    }
    
    func paste() {
        if let string = clipboard.string {
            clipboardHistory[selectedCategory]?.insert(string, at: 0)
            UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
        }
    }
    
    func copyToClipboard() {
        clipboard.string = self.text
        clipboardHistory[selectedCategory]?.insert(text, at: 0)
        UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
        self.text = ""
        self.ButtonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.ButtonText = "Copy to Clipboard"
        }
    }
    
    func deleteItems(at offsets: IndexSet, in category: String) {
        clipboardHistory[category]?.remove(atOffsets: offsets)
        UserDefaults.standard.set(clipboardHistory, forKey: "clipHistory")
    }
}

#Preview {
    ContentView()
}
