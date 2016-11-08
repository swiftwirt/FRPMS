//: [Next](@next)
/*:
 
 ### Challenges
 
 Write the following functions: 
 
 1. `makeAllUppercase` that takes an array of `String`s and returns an array of `String`s; all the strings in the returned array should only contain uppercase characters
 2. `convertAllToString` that takes an array of `Int`s and returns an array of `String`s where every `Int` was transformed to a `String`
 3. `keepOnlyOdds` that takes an array of `Int`s and returns an array of `Int`s that only has odd numbers
 4. `startingWithA` that takes an array of `String`s and returns an array of `String`s that only contains `String`s that start with the (uppercase) letter `A`
 5. `computeProduct` that takes an array of `Int`s and returns a single `Int` that is the product of all the elements in the array
 6. `concatenateAll` that takes an array of `String`s and returns a `String` that is concatenates all the elements in the array
 
 */

func makeAllUppercase(list: [String]) -> [String] {
    return list.map{ $0.uppercased() }
}

func convertAllToString(list: [Int]) -> [String]{
    return list.map{ String($0) }
}

func keepOnlyOdds(list: [Int]) -> [Int]{
    return list.filter{ $0%2 != 0 }
}

func startingWithA(list: [String]) -> [String]{
    return list.filter{ $0.lowercased()[$0.startIndex] == "a" }
}

func computeProduct(list: [Int]) -> Int{
    return list.reduce(1, *)
}

func concatenateAll(list: [String]) -> String{
    return list.reduce("", +)
}

makeAllUppercase(list: ["hello", "World", "anything"])

convertAllToString(list: [1, 3, 4, 5])

keepOnlyOdds(list: [1, 2, 3, 4, 5, 6])

startingWithA(list: ["Alex", "reilly", "Amy"])

computeProduct(list: [1, 2, 3, 4, 5])

concatenateAll(list: ["Alex", "Reilly", "Hello", "World"])


