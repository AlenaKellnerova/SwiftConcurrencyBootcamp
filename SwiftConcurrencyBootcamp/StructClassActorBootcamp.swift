//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Mac mini on 8/20/26.
// struct vs class 

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text("H")
            .onAppear {
//                structTest1()
//                printDivider()
//                classTest1()
                structTest2()
            }
    }
}

#Preview {
    StructClassActorBootcamp()
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

struct MyStruct {
    var title: String
}

extension StructClassActorBootcamp {
    
    private func printDivider() {
        print("""
            
            __________________________________________________
            
            """)
    }
    
    private func structTest1() {
        
        let objectA = MyStruct(title: "A")
        print("Object A title:", objectA.title)
        
        print("pass VALUE of obj A to obj B")
        
        var objectB = objectA // Both are completely distinct, only passing the same value at that time
        print("Object B title:", objectB.title)
        
        objectB.title = "Second title"
        print("Object b title changed")
        
        print("Object a title: ", objectA.title)
        print("Object b title: ", objectB.title)
        
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "A")
        print("Object A title: ", objectA.title)
        
        print("Pass REFERENCE of obj A to obj B") // Both pointing to the same object in the memory
        let objectB = objectA
        print("Object B title: ", objectB.title)
        
        objectB.title = "B"
        print("Object b title changed") // changing the underlying reference
        
        print("Object a title: ", objectA.title)
        print("Object b title: ", objectB.title)
    }
}



extension StructClassActorBootcamp {
    
    private func structTest2() {
        
        var struct1 = MyStruct(title: "A")
        print("Struct1:", struct1.title)
        struct1.title = "B"
        print("Struct1:", struct1.title)

    }
}
