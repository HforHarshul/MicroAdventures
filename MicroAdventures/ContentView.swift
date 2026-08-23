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
    
    @State private var currentAdventureIndex = 0
    @State private var adventures: [Adventure] = [
        Adventure(title: "Tower Bridge Sunset Walk", description: "Stroll across Tower Bridge at golden hour and soak in panoramic views of the Thames.", category: .nature, effortLevel: .low, isComplete: false),
        Adventure(title: "Borough Market Food Tour", description: "Graze your way through one of London's oldest food markets and try something you've never eaten before.", category: .food, effortLevel: .low, isComplete: false),
        Adventure(title: "Regent's Park Picnic", description: "Pack a blanket and lunch, find a quiet spot in Regent's Park, and spend an hour completely off your phone.", category: .nature, effortLevel: .low, isComplete: false),
        Adventure(title: "Brick Lane Street Art Walk", description: "Wander the backstreets of Brick Lane and photograph the ever-changing murals and paste-ups.", category: .urban, effortLevel: .low, isComplete: false),
        Adventure(title: "Thames Path Morning Jog", description: "Run a stretch of the Thames Path from Waterloo Bridge to Blackfriars and back as the city wakes up.", category: .fitness, effortLevel: .medium, isComplete: false),
        Adventure(title: "Tate Modern Wander", description: "Spend an hour in the free permanent collection at Tate Modern — no plan, just wander and see what stops you.", category: .culture, effortLevel: .low, isComplete: false),
        Adventure(title: "Camden Market Exploration", description: "Get lost in Camden's labyrinth of stalls, pick up something bizarre, and grab street food from a vendor you've never tried.", category: .food, effortLevel: .medium, isComplete: false),
        Adventure(title: "Greenwich Park Hill Climb", description: "Hike up to the Royal Observatory, catch your breath, and take in one of the best skyline views in London.", category: .fitness, effortLevel: .medium, isComplete: false),
        Adventure(title: "Notting Hill Neighbourhood Wander", description: "Explore the pastel-coloured streets of Notting Hill, duck into independent bookshops and cafés.", category: .urban, effortLevel: .low, isComplete: false),
        Adventure(title: "Open Mic Night in Soho", description: "Find an open mic night in a Soho pub, order a drink, and cheer on strangers performing for the first time.", category: .social, effortLevel: .medium, isComplete: false),
    ]

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
                    Image(systemName: adventures[currentAdventureIndex].category.icon)
                        .font(.caption2)
                    Text(adventures[currentAdventureIndex].category.rawValue)
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
                    Image(systemName: adventures[currentAdventureIndex].effortLevel.icon)
                        .font(.caption2)
                    Text(adventures[currentAdventureIndex].effortLevel.rawValue)
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
            Text(adventures[currentAdventureIndex].title)
                .font(.title3)
                .fontWeight(.bold)
            
            // Adventure description
            Text(adventures[currentAdventureIndex].description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Bottom row: Status button
            HStack {
                Spacer()
                Button {
                    adventures[currentAdventureIndex].isComplete.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: adventures[currentAdventureIndex].isComplete ? "checkmark.circle.fill" : "circle")
                        Text(adventures[currentAdventureIndex].isComplete ? "Completed" : "Mark Complete")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(adventures[currentAdventureIndex].isComplete ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                    .foregroundStyle(adventures[currentAdventureIndex].isComplete ? .green : .primary)
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
