//
//  ContentView.swift
//  ToDoApp
//
//  Created by Сергей Лукичев on 21.02.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Task]
    
    @State private var isShowingAddTaskSheet = false // Состояние для отображения Sheet
    @State private var newTaskTitle: String = "" // Текстовое поле для нового заголовка задачи
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        ZStack {
                            VStack {
                                Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                Text("Item id \(item.id)")
                                Text("\(item.title)")
                            }
                            VStack {
                                Spacer()
                                HStack {
                                    Button("Создать задачу") {
                                        print("Создать задачу")
                                    }
                                    Button("Удалить задачу") {
                                        print("Удалить задачу")
                                    }
                                    Spacer()
                                }
                                .padding([.bottom, .leading])
                            }
                        }
                    } label: {
                        Text(item.title)
                            .contextMenu(menuItems: {
                                Button("Delete", action: {
                                    deleteItem(item)
                                })
                                .keyboardShortcut(.delete, modifiers: .command)
                            })
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: showAddTaskSheet) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $isShowingAddTaskSheet) {
            AddTaskView(newTaskTitle: $newTaskTitle, onAdd: addTask, onCancel: hideAddTaskSheet)
        }
        .onAppear {
            deleteAllItems()
        }
    }
    
    private func showAddTaskSheet() {
        newTaskTitle = "" // Очищаем текстовое поле перед показом
        isShowingAddTaskSheet = true
    }
    
    private func hideAddTaskSheet() {
        isShowingAddTaskSheet = false
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return } // Проверяем, что текст не пустой
        
        withAnimation {
            let newItem = Task(title: newTaskTitle)
            modelContext.insert(newItem)
        }
        
        hideAddTaskSheet() // Скрываем Sheet после добавления
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Task(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
    
    private func deleteItem(_ item: Task) {
        withAnimation {
            modelContext.delete(item)
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            for item in items {
                modelContext.delete(item)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}

// Представление для добавления новой задачи
struct AddTaskView: View {
    @Binding var newTaskTitle: String
    var onAdd: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter task title", text: $newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack(spacing: 20) {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.cancelAction) // Горячая клавиша для отмены (Esc)
                
                Button("OK") {
                    onAdd()
                }
                .keyboardShortcut(.defaultAction) // Горячая клавиша для подтверждения (Enter)
                .disabled(newTaskTitle.isEmpty) // Отключаем кнопку, если текст пустой
            }
            .padding()
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}
