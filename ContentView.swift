import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [Progress]

    var body: some View {
        NavigationStack {
            List {
                ForEach(logs) { log in
                    Text(log.timestamp, style: .date)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("ShapeShift")
            .toolbar {
                Button(action: addItem) {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        let newItem = Progress()
        modelContext.insert(newItem)
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(logs[index])
        }	
    }
}
