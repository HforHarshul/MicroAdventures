//
//  ContentView.swift
//  MicroAdventures
//
//  Created by Harshul on 18/04/2026.
//

import SwiftUI
import MapKit

struct Adventure: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: Category
    let effortLevel: EffortLevel
    var isComplete: Bool
}

enum Category: String, CaseIterable, Identifiable {
    case nature = "Nature"
    case urban = "Urban"
    case food = "Food"
    case culture = "Culture"
    case fitness = "Fitness"
    case social = "Social"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .nature: "leaf.fill"
        case .urban: "building.2.fill"
        case .food: "fork.knife"
        case .culture: "theatermasks.fill"
        case .fitness: "figure.run"
        case .social: "person.2.fill"
        }
    }
}

enum EffortLevel: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .low: "battery.25percent"
        case .medium: "battery.50percent"
        case .high: "battery.100percent"
        }
    }
}

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1017), distance: 50000)
    )
    @State private var selectedCategories: Set<Category> = Set([Category.culture, Category.nature])
    @State private var selectedEffortLevels: Set<EffortLevel> = Set(EffortLevel.allCases)
    @State private var showingFilters = false
    
    // Sample adventure data
    @State private var sampleAdventure = Adventure(
        title: "Tower Bridge Sunset Walk",
        description: "Explore the city and experience the sunset from Tower Bridge.",
        category: .nature,
        effortLevel: .low,
        isComplete: false
    )

    private var allCategoriesSelected: Bool {
        selectedCategories.count == Category.allCases.count
    }

    private var allEffortLevelsSelected: Bool {
        selectedEffortLevels.count == EffortLevel.allCases.count
    }

    private var activeFilterCount: Int {
        let categoryCount = Category.allCases.count - selectedCategories.count
        let effortCount = EffortLevel.allCases.count - selectedEffortLevels.count
        return categoryCount + effortCount
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition) {
                    Marker("London", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1017))
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Floating "Next Adventure" button
                nextAdventureButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
            .navigationTitle("Micro Adventures")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(systemName: activeFilterCount > 0 ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                filterSheet
            }
        }
    }

    private var filterSheet: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    Button {
                        if allCategoriesSelected {
                            selectedCategories.removeAll()
                        } else {
                            selectedCategories = Set(Category.allCases)
                        }
                    } label: {
                        HStack {
                            Text("Select All")
                            Spacer()
                            if allCategoriesSelected {
                                Image(systemName: "checkmark")
                            }
                        }
                    }

                    ForEach(Category.allCases) { category in
                        Button {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        } label: {
                            HStack {
                                Label(category.rawValue, systemImage: category.icon)
                                Spacer()
                                if selectedCategories.contains(category) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Section("Effort Level") {
                    Button {
                        if allEffortLevelsSelected {
                            selectedEffortLevels.removeAll()
                        } else {
                            selectedEffortLevels = Set(EffortLevel.allCases)
                        }
                    } label: {
                        HStack {
                            Text("Select All")
                            Spacer()
                            if allEffortLevelsSelected {
                                Image(systemName: "checkmark")
                            }
                        }
                    }

                    ForEach(EffortLevel.allCases) { level in
                        Button {
                            if selectedEffortLevels.contains(level) {
                                selectedEffortLevels.remove(level)
                            } else {
                                selectedEffortLevels.insert(level)
                            }
                        } label: {
                            HStack {
                                Label(level.rawValue, systemImage: level.icon)
                                Spacer()
                                if selectedEffortLevels.contains(level) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showingFilters = false
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                adventureInfoCard
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var adventureInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Category and Effort Level pills
            HStack(spacing: 8) {
                // Category pill
                HStack(spacing: 4) {
                    Image(systemName: sampleAdventure.category.icon)
                        .font(.caption2)
                    Text(sampleAdventure.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .foregroundStyle(.blue)
                .clipShape(Capsule())
                
                // Effort level pill
                HStack(spacing: 4) {
                    Image(systemName: sampleAdventure.effortLevel.icon)
                        .font(.caption2)
                    Text(sampleAdventure.effortLevel.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.15))
                .foregroundStyle(.orange)
                .clipShape(Capsule())
                
                Spacer()
            }
            
            // Adventure title
            Text(sampleAdventure.title)
                .font(.title3)
                .fontWeight(.bold)
            
            // Adventure description
            Text(sampleAdventure.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Bottom row: Status button
            HStack {
                Spacer()
                Button {
                    sampleAdventure.isComplete.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: sampleAdventure.isComplete ? "checkmark.circle.fill" : "circle")
                        Text(sampleAdventure.isComplete ? "Completed" : "Mark Complete")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(sampleAdventure.isComplete ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                    .foregroundStyle(sampleAdventure.isComplete ? .green : .primary)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var nextAdventureButton: some View {
        Button {
            // Action for next adventure
            print("Next Adventure tapped")
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Next Adventure")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
