//
//  Test.swift
//  Discite
//
//  Created by Jessie Li on 12/14/23.
//

import SwiftUI

class TestVM: ObservableObject {
    @Published var tasks: [Int] = []
    @Published var count: Int = 0
    
    // like load
    func doTasks() async {
        
        tasks = await withTaskGroup(of: Int.self) { group in
            for i in 1...5 {
                group.addTask {
                    print("basic task 1.\(i)")
                    return i
                }
            }
            
            var newTasks: [Int] = []
            for await j in group {
                newTasks.append(j)
            }
            
            return newTasks
        }
    }
    
    func doTasksAsync() async {
        await withTaskGroup(of: Void.self) { group in
            for i in 1...5 {
                group.addTask {
                    await self.basicTaskAsync(value: i)
                }
            }
        }
    }
    
    func basicTask(value: Int) {
        Task {
            tasks.append(value)
            print("basic task 1.\(value)")
        }
    }
    
    func basicTaskAsync(value: Int) async {
        async let i = value
        let result = await i
        
        tasks.append(result)
        print("basic task 2.\(result)")
    }
    
    // like addPlaylist
    func countAsync() async {
        async let before = count
        let result = await before
        print("before count was \(result)")
        count += 1
    }
    
    func addTaskAsync() async {
        async let task = count
        count += 1
        
        let result = await task
        tasks.append(result)
        
        print(tasks)
    }
    
    func increaseCount() async {
        count += 1
    }
}

struct Test: View {
    
    @StateObject var vm = TestVM()
    
    var body: some View {
        Button {
            Task { 
                // await vm.doTasks()
                await vm.doTasks()
                print("tasks: \(vm.tasks)")
            }
        } label: {
            Text("Tasks")
        }
        
        Button {
            Task {
                await vm.addTaskAsync()
                // print("final count: \(vm.count)")
            }
        } label: {
            Text("Count")
        }

        ForEach(vm.tasks, id: \.self) { i in
            Text("task \(i)")
        }
    }
    
}

#Preview {
    Test()
}
