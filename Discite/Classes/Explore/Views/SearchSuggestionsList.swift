//
//  SearchSuggestionsList.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import SwiftUI

struct SearchSuggestionsList: View {
    @Binding var searchText: String
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Suggestions")
                    .font(.subtitle2)
                    .foregroundColor(.grayDark)
                    .frame(alignment: .leading)
                    .padding(.top, 18)
                
                Divider()
                
                ForEach(filteredSuggestions, id: \.self) { suggestion in
                    NavigationLink {
                        SearchDestinationPage(text: suggestion)
                        
                    } label: {
                        Text(suggestion)
                            .font(Font.body)
                            .frame(alignment: .leading)
                    }
                    .foregroundStyle(Color.primaryBlueBlack)
                    .onTapGesture {
                        searchText = suggestion
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(4)
                }
                
            }
        }
        .background(.white)
    }
    
    var filteredSuggestions: [String] {
        if searchText.isEmpty {
            return suggestions
        } else {
            return suggestions.filter { $0.contains(searchText.lowercased()) }
        }
    }
    
    private let suggestions: [String] = [
        "algorithms and data structures",
        "sorting algorithms",
        "graph theory",
        "data structures",
        "dynamic programming",
        "complexity analysis",
        "artificial intelligence (ai) and machine learning",
        "neural networks",
        "reinforcement learning",
        "natural language processing",
        "computer vision",
        "deep learning",
        "computer architecture",
        "processor design",
        "memory systems",
        "parallel computing",
        "microarchitecture",
        "computer organization",
        "data science and analytics",
        "statistical methods",
        "machine learning in analytics",
        "data visualization",
        "big data processing",
        "predictive modeling",
        "database systems and management",
        "relational databases",
        "nosql databases",
        "sql programming",
        "database design",
        "transaction management",
        "human-computer interaction (hci)",
        "user interface design",
        "user experience (ux) principles",
        "usability studies",
        "interaction design",
        "accessible design",
        "programming languages and software development",
        "object-oriented programming",
        "functional programming",
        "software testing",
        "web development frameworks",
        "version control systems",
        "software engineering and system design",
        "software development life cycle",
        "system architecture",
        "design patterns",
        "agile methodologies",
        "risk management",
        "web development and internet technologies",
        "html/css",
        "javascript",
        "web application frameworks",
        "restful services",
        "web security",
        "computer graphics and visualization",
        "3d modeling",
        "rendering techniques",
        "animation",
        "image processing",
        "visualization tools",
        "theoretical computer science",
        "computability theory",
        "complexity theory",
        "algorithmic game theory",
        "cryptography",
        "quantum computing theory",
        "quantum computing",
        "quantum algorithms",
        "quantum entanglement",
        "quantum error correction",
        "quantum cryptography",
        "quantum hardware"
    ]
}

#Preview {
    SearchSuggestionsList(searchText: .constant(""))
}
