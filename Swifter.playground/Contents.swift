//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func logIfTrue(f:() -> Bool){
    if f(){
        println("True");
    }
}

logIfTrue { () -> Bool in
    4>2
}

logIfTrue{4>2}


let arrary:String


let a = 1 , b = 0
let c:Int
//
c = a|b;

//qsort(<#UnsafeMutablePointer<Void>#>, <#Int#>, <#Int#>) { (<#UnsafePointer<Void>#>, <#UnsafePointer<Void>#>) -> Int32 in
//    <#code#>
//}
//qsort_b(<#UnsafeMutablePointer<Void>#>, <#Int#>, <#Int#>) { (<#UnsafePointer<Void>#>, <#UnsafePointer<Void>#>) -> Int32 in
//    <#code#>
//}

//
//println(a,b,c);


func load(a:Int) -> Int{
    return a+1;
}

load(2);

load(3);

class Toy {
    let name: String
    init(name: String){
        self.name = name
    }
}

class Pet {
    var toy: Toy?
}

class Child {
    var pet: Pet?
}

//class Toy1: Toy {
//    var name1: String?
//}

//class xiaoming: Child {
//    
//}

let xiaoming = Child()

let toyName = xiaoming.pet?.toy?.name

extension Toy{
    func play(){
    
    }
}

let playClosure = {(child:Child)->() in
    child.pet?.toy?.play()}

//

struct VD {
    var x = 0
    var y = 0
}

infix operator +* {
    associativity none
    precedence 160
}

let v1 = VD(x:2,y:1)
let v2 = VD(x:3,y:4)

func qq(left:VD ,right:VD) -> VD {
    return VD(x:left.x + right.x , y:left.y+right.y)
}
func +(left:VD ,right:VD) -> VD {
    return VD(x:left.x + right.x , y:left.y+right.y)
}

func +*(left:VD,right:Int) -> Int {
    return left.x - right
}


let v3 = qq(v1, v2)

let v4 = v1 + v2

var v5 = v2 +* 2

var num1 = 1

var num2 = num1++

num1

num2++

num2


var increaseNum = 8
func increase(inout a:Int){
    ++a;
}
increase(&increaseNum)
increaseNum


//没弄懂：实现一个累加任意数字的＋N器

func makeIncrementor (addNumber : Int) -> ((inout Int) -> ()){
    func incrementor (inout variable :Int) -> (){
        variable += addNumber
    }
    return incrementor
}

makeIncrementor(increaseNum)


//














