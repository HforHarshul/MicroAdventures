//
//  ContentView.swift
//  MicroAdventures
//
//  Created by Harshul on 18/04/2026.
//

import SwiftUI
import MapKit

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
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), distance: 50000)
    )
    @State private var selectedCategories: Set<Category> = Set([Category.culture, Category.nature])
    @State private var selectedEffortLevels: Set<EffortLevel> = Set(EffortLevel.allCases)
    @State private var showingFilters = false

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
            Map(position: $cameraPosition) {
                Marker("San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
            }
            .ignoresSafeArea(edges: .bottom)
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
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    ContentView()
}
